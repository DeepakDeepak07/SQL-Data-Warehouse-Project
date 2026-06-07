/*
===============================================================================
SILVER LAYER TRANSFORMATION PIPELINE
===============================================================================

Purpose:
    This stored procedure orchestrates the transformation of raw Bronze-layer
    datasets into conformed Silver-layer tables within a structured data
    warehouse architecture.

    It serves as the core data cleansing and standardization stage in the ETL
    pipeline, ensuring that all downstream analytical layers operate on
    consistent, validated, and business-aligned data.

    Specifically, this process:
      - Converts raw operational data into analytics-ready structures
      - Applies deterministic data quality rules (deduplication, validation,
        and correction of inconsistent values)
      - Standardizes domain values (e.g., gender, marital status, product lines)
      - Resolves structural inconsistencies introduced by source systems
      - Enforces referential and business key integrity where applicable
      - Produces trusted dimensional and fact datasets for reporting layers

    The output of this layer is designed to support:
      - BI dashboards and reporting systems
      - Data marts and Gold-layer aggregations
      - Analytical modeling and downstream feature engineering

Design Principle:
    Bronze = Immutable raw ingestion layer (source-aligned, unvalidated)
    Silver = Conformed integration layer (cleaned, standardized, reliable)
    Gold   = Business aggregate layer (metrics, KPIs, reporting optimized)

Execution Model:
    This procedure performs a full refresh load per execution cycle,
    ensuring deterministic outputs and eliminating residual data drift.
===============================================================================
*/
EXEC Silver.load_silver

CREATE OR ALTER PROCEDURE Silver.load_silver 
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @pipeline_start DATETIME2 = SYSDATETIME(),
        @stage_start DATETIME2,
        @stage_end DATETIME2;

    PRINT '======================================================';
    PRINT 'SILVER LAYER LOAD STARTED';
    PRINT 'Start Time: ' + CAST(@pipeline_start AS NVARCHAR);
    PRINT '======================================================';


    /*========================
      CUSTOMER DIMENSION
    ========================*/
    PRINT '--- Loading: crm_cust_info ---';
    SET @stage_start = SYSDATETIME();

    TRUNCATE TABLE Silver.crm_cust_info;

    INSERT INTO Silver.crm_cust_info (
        cst_id, cst_key, cst_firstname, cst_lastname,
        cst_marital_status, cst_gndr, cst_create_date
    )
    SELECT
        cst_id,
        cst_key,
        TRIM(cst_firstname),
        TRIM(cst_lastname),
        CASE 
            WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
            WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
            ELSE 'n/a'
        END,
        CASE 
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            ELSE 'n/a'
        END,
        cst_create_date
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (
                   PARTITION BY cst_id
                   ORDER BY cst_create_date DESC
               ) rn
        FROM Bronze.crm_cust_info
        WHERE cst_id IS NOT NULL
    ) t
    WHERE rn = 1;

    SET @stage_end = SYSDATETIME();
    PRINT 'crm_cust_info completed in: ' 
        + CAST(DATEDIFF(SECOND, @stage_start, @stage_end) AS NVARCHAR) + ' seconds';


    /*========================
      PRODUCT DIMENSION
    ========================*/
    PRINT '--- Loading: crm_prd_info ---';
    SET @stage_start = SYSDATETIME();

    TRUNCATE TABLE Silver.crm_prd_info;

    INSERT INTO Silver.crm_prd_info (
        prd_id, cat_id, prd_key, prd_nm,
        prd_cost, prd_line, prd_start_dt, prd_end_dt
    )
    SELECT
        prd_id,
        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_'),
        SUBSTRING(prd_key, 7, LEN(prd_key)),
        prd_nm,
        ISNULL(prd_cost, 0),
        CASE 
            WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
            WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
            WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
            WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
            ELSE 'n/a'
        END,
        CAST(prd_start_dt AS DATE),
        CAST(
            LEAD(prd_start_dt) OVER (
                PARTITION BY prd_key ORDER BY prd_start_dt
            ) - 1 AS DATE
        )
    FROM Bronze.crm_prd_info;

    SET @stage_end = SYSDATETIME();
    PRINT 'crm_prd_info completed in: ' 
        + CAST(DATEDIFF(SECOND, @stage_start, @stage_end) AS NVARCHAR) + ' seconds';


    /*========================
      SALES FACT
    ========================*/
    PRINT '--- Loading: crm_sales_details ---';
    SET @stage_start = SYSDATETIME();

    TRUNCATE TABLE Silver.crm_sales_details;

    INSERT INTO Silver.crm_sales_details (
        sls_ord_num, sls_prd_key, sls_cust_id,
        sls_order_dt, sls_ship_dt, sls_due_dt,
        sls_sales, sls_quantity, sls_price
    )
    SELECT
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) <> 8 THEN NULL
             ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) END,
        CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) <> 8 THEN NULL
             ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) END,
        CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) <> 8 THEN NULL
             ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) END,
        CASE 
            WHEN sls_sales IS NULL 
              OR sls_sales <= 0 
              OR sls_sales <> sls_quantity * ABS(sls_price)
            THEN sls_quantity * ABS(sls_price)
            ELSE sls_sales
        END,
        sls_quantity,
        CASE 
            WHEN sls_price IS NULL OR sls_price <= 0
            THEN sls_sales / NULLIF(sls_quantity, 0)
            ELSE sls_price
        END
    FROM Bronze.crm_sales_details;

    SET @stage_end = SYSDATETIME();
    PRINT 'crm_sales_details completed in: ' 
        + CAST(DATEDIFF(SECOND, @stage_start, @stage_end) AS NVARCHAR) + ' seconds';


    /*========================
      ERP CUSTOMER DEMOGRAPHICS
    ========================*/
    PRINT '--- Loading: erp_cust_az12 ---';
    SET @stage_start = SYSDATETIME();

    TRUNCATE TABLE Silver.erp_cust_az12;

    INSERT INTO Silver.erp_cust_az12 (cid, bdate, gen)
    SELECT
        CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
             ELSE cid END,
        CASE WHEN bdate > GETDATE() THEN NULL ELSE bdate END,
        CASE
            WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(gen,
                CHAR(13), ''), CHAR(10), ''),
                CHAR(0), ''), CHAR(32), '')
            ) IN ('F','FEMALE') THEN 'Female'
            WHEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(gen,
                CHAR(13), ''), CHAR(10), ''),
                CHAR(0), ''), CHAR(32), '')
            ) IN ('M','MALE') THEN 'Male'
            ELSE 'n/a'
        END
    FROM Bronze.erp_cust_az12;

    SET @stage_end = SYSDATETIME();
    PRINT 'erp_cust_az12 completed in: ' 
        + CAST(DATEDIFF(SECOND, @stage_start, @stage_end) AS NVARCHAR) + ' seconds';


    /*========================
      LOCATION REFERENCE
    ========================*/
    PRINT '--- Loading: erp_loc_a101 ---';
    SET @stage_start = SYSDATETIME();

    TRUNCATE TABLE Silver.erp_loc_a101;

    INSERT INTO Silver.erp_loc_a101 (cid, cntry)
    SELECT
        REPLACE(cid, '-', ''),
        CASE 
            WHEN TRIM(cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
            WHEN TRIM(cntry) IS NULL OR TRIM(cntry) = '' THEN 'n/a'
            ELSE TRIM(cntry)
        END
    FROM Bronze.erp_loc_a101;

    SET @stage_end = SYSDATETIME();
    PRINT 'erp_loc_a101 completed in: ' 
        + CAST(DATEDIFF(SECOND, @stage_start, @stage_end) AS NVARCHAR) + ' seconds';


    /*========================
      CATEGORY REFERENCE
    ========================*/
    PRINT '--- Loading: erp_px_cat_g1v2 ---';
    SET @stage_start = SYSDATETIME();

    TRUNCATE TABLE Silver.erp_px_cat_g1v2;

    INSERT INTO Silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
    SELECT id, cat, subcat, maintenance
    FROM Bronze.erp_px_cat_g1v2;

    SET @stage_end = SYSDATETIME();
    PRINT 'erp_px_cat_g1v2 completed in: ' 
        + CAST(DATEDIFF(SECOND, @stage_start, @stage_end) AS NVARCHAR) + ' seconds';


    /*========================
      PIPELINE SUMMARY
    ========================*/
    DECLARE @pipeline_end DATETIME2 = SYSDATETIME();

    PRINT '======================================================';
    PRINT 'SILVER LAYER LOAD COMPLETED';
    PRINT 'Total Duration: ' 
        + CAST(DATEDIFF(SECOND, @pipeline_start, @pipeline_end) AS NVARCHAR) 
        + ' seconds';
    PRINT 'End Time: ' + CAST(@pipeline_end AS NVARCHAR);
    PRINT '======================================================';

END;

