/* 
===============================================================================
Stored Procedure: Bronze.load_bronze
===============================================================================

Purpose:
    This stored procedure loads raw data from external CSV files into the 
    Bronze layer of the data warehouse.

    It performs full refresh (TRUNCATE + LOAD) for all Bronze tables across:
    - CRM source system
    - ERP source system

    Key features:
    - Full reload (no incremental logic)
    - Bulk data ingestion using BULK INSERT
    - Execution time tracking per table and per batch
    - Basic row-level load visibility
    - Error handling using TRY...CATCH

Stored Procedure Type:
    ETL Ingestion Layer (Bronze Layer Loader)

Data Flow:
    Flat Files (CSV) → Bronze Schema Tables (Raw Staging Layer)

Usage:
    EXEC Bronze.load_bronze;

    Recommended execution:
    - Run at start of ETL pipeline
    - Scheduled via SQL Agent Job (if automated)
    - Execute before Silver / transformation layer refresh

Assumptions:
    - Source CSV files exist at fixed file paths
    - SQL Server service account has read access to file directory
    - Target tables already exist in Bronze schema

===============================================================================
*/
CREATE OR ALTER PROCEDURE Bronze.load_bronze
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME,
        @rows_loaded INT;

    BEGIN TRY

        SET @batch_start_time = GETDATE();

        PRINT '==========================================';
        PRINT 'BRONZE LAYER LOAD STARTED';
        PRINT '==========================================';

        -------------------------------------------------
        -- CRM TABLES
        -------------------------------------------------

        /* ================= CRM CUSTOMER ================= */
        SET @start_time = GETDATE();

        TRUNCATE TABLE Bronze.crm_cust_info;

        BULK INSERT Bronze.crm_cust_info
        FROM 'C:\Users\Deepa\Documents\PROJECTS\SQL Data Warehouse Project\sql-data-warehouse-project\datasets\source_crm\cust_info.CSV'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );

        SET @rows_loaded = @@ROWCOUNT;

        SET @end_time = GETDATE();
        PRINT 'crm_cust_info | Rows: ' + CAST(@rows_loaded AS NVARCHAR) 
              + ' | Time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 's';


        /* ================= CRM PRODUCT ================= */
        SET @start_time = GETDATE();

        TRUNCATE TABLE Bronze.crm_prd_info;

        BULK INSERT Bronze.crm_prd_info
        FROM 'C:\Users\Deepa\Documents\PROJECTS\SQL Data Warehouse Project\sql-data-warehouse-project\datasets\source_crm\prd_info.CSV'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );

        SET @rows_loaded = @@ROWCOUNT;

        SET @end_time = GETDATE();
        PRINT 'crm_prd_info | Rows: ' + CAST(@rows_loaded AS NVARCHAR) 
              + ' | Time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 's';


        /* ================= CRM SALES ================= */
        SET @start_time = GETDATE();

        TRUNCATE TABLE Bronze.crm_sales_details;

        BULK INSERT Bronze.crm_sales_details
        FROM 'C:\Users\Deepa\Documents\PROJECTS\SQL Data Warehouse Project\sql-data-warehouse-project\datasets\source_crm\sales_details.CSV'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );

        SET @rows_loaded = @@ROWCOUNT;

        SET @end_time = GETDATE();
        PRINT 'crm_sales_details | Rows: ' + CAST(@rows_loaded AS NVARCHAR) 
              + ' | Time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 's';


        -------------------------------------------------
        -- ERP TABLES
        -------------------------------------------------

        /* ================= ERP LOCATION ================= */
        SET @start_time = GETDATE();

        TRUNCATE TABLE Bronze.erp_loc_a101;

        BULK INSERT Bronze.erp_loc_a101
        FROM 'C:\Users\Deepa\Documents\PROJECTS\SQL Data Warehouse Project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );

        SET @rows_loaded = @@ROWCOUNT;

        SET @end_time = GETDATE();
        PRINT 'erp_loc_a101 | Rows: ' + CAST(@rows_loaded AS NVARCHAR) 
              + ' | Time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 's';


        /* ================= ERP CUSTOMER ================= */
        SET @start_time = GETDATE();

        TRUNCATE TABLE Bronze.erp_cust_az12;

        BULK INSERT Bronze.erp_cust_az12
        FROM 'C:\Users\Deepa\Documents\PROJECTS\SQL Data Warehouse Project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );

        SET @rows_loaded = @@ROWCOUNT;

        SET @end_time = GETDATE();
        PRINT 'erp_cust_az12 | Rows: ' + CAST(@rows_loaded AS NVARCHAR) 
              + ' | Time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 's';


        /* ================= ERP PRODUCT CATEGORY ================= */
        SET @start_time = GETDATE();

        TRUNCATE TABLE Bronze.erp_px_cat_g1v2;

        BULK INSERT Bronze.erp_px_cat_g1v2
        FROM 'C:\Users\Deepa\Documents\PROJECTS\SQL Data Warehouse Project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );

        SET @rows_loaded = @@ROWCOUNT;

        SET @end_time = GETDATE();
        PRINT 'erp_px_cat_g1v2 | Rows: ' + CAST(@rows_loaded AS NVARCHAR) 
              + ' | Time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 's';


        -------------------------------------------------
        -- END OF BATCH
        -------------------------------------------------

        SET @batch_end_time = GETDATE();

        PRINT '==========================================';
        PRINT 'BRONZE LAYER LOAD COMPLETED';
        PRINT 'TOTAL TIME: ' 
              + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '==========================================';

    END TRY
    BEGIN CATCH

        PRINT '==========================================';
        PRINT 'BRONZE LOAD FAILED';
        PRINT '==========================================';

        PRINT ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR(10));

        THROW;

    END CATCH
END;
