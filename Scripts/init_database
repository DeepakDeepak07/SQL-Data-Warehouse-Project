/*
===============================================================================
 Data Warehouse Initialization Script
===============================================================================

 Author      : Deepak
 Project     : Data Warehouse & Analytics Platform
 Description : Creates the DataWarehouse database and the Bronze, Silver,
               and Gold schemas used for the Medallion Architecture.

 Architecture:
    Bronze  -> Raw source data
    Silver  -> Cleaned and transformed data
    Gold    -> Business-ready reporting layer

 Warning:
    - This script creates a new database.
    - Existing database with the same name may be dropped if the optional
      DROP section is enabled.
    - Run with appropriate permissions.

===============================================================================
*/

USE master;
GO

/*--------------------------------------------------------------------------
 STEP 1: Check if Database Already Exists
--------------------------------------------------------------------------*/

IF DB_ID('DataWarehouse') IS NOT NULL
BEGIN
    PRINT 'Database already exists.';
END
ELSE
BEGIN
    PRINT 'Creating DataWarehouse database...';

    CREATE DATABASE DataWarehouse;

    PRINT 'Database created successfully.';
END
GO

/*--------------------------------------------------------------------------
 STEP 2: Switch Context
--------------------------------------------------------------------------*/

USE DataWarehouse;
GO

/*--------------------------------------------------------------------------
 STEP 3: Create Bronze Schema
--------------------------------------------------------------------------*/

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'Bronze'
)
BEGIN
    EXEC('CREATE SCHEMA Bronze');
    PRINT 'Bronze schema created.';
END
ELSE
BEGIN
    PRINT 'Bronze schema already exists.';
END
GO

/*--------------------------------------------------------------------------
 STEP 4: Create Silver Schema
--------------------------------------------------------------------------*/

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'Silver'
)
BEGIN
    EXEC('CREATE SCHEMA Silver');
    PRINT 'Silver schema created.';
END
ELSE
BEGIN
    PRINT 'Silver schema already exists.';
END
GO

/*--------------------------------------------------------------------------
 STEP 5: Create Gold Schema
--------------------------------------------------------------------------*/

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'Gold'
)
BEGIN
    EXEC('CREATE SCHEMA Gold');
    PRINT 'Gold schema created.';
END
ELSE
BEGIN
    PRINT 'Gold schema already exists.';
END
GO

/*--------------------------------------------------------------------------
 STEP 6: Validation
--------------------------------------------------------------------------*/

SELECT
    name AS SchemaName
FROM sys.schemas
WHERE name IN ('Bronze', 'Silver', 'Gold')
ORDER BY name;
GO

PRINT 'Data Warehouse initialization completed successfully.';
GO
