/*
===================================================================
Stored Proceudre: Load bronze layer(source-> Bronze)
===================================================================
Script Purpose:
This stored procedure loads data into the bronze schema from external csv files 
It performs the following actions :
- Truncate the bronze table before loading data 
- Use the 'BULK INSERT' command to insert data fro csv files to to bronze tables


Parameters: NONE
This stored procedure does not accept any parameters or return any values 


USAGE EXAMPLE:
EXEC bronze.load_bronze
===================================================================
*/




CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;


BEGIN TRY
SET @batch_start_time = GETDATE();
PRINT'==========================================';
PRINT 'Loading bronze layer';
PRINT'==========================================';


PRINT '-----------------------------------------';
PRINT'Loading CRM Table';
PRINT '-----------------------------------------';

SET @start_time = GETDATE();
PRINT'>> Truncating Table:bronze.crm_cust_info';
    TRUNCATE TABLE bronze.crm_cust_info
PRINT'>> Inserting data into:bronze.crm_cust_info';
    BULK INSERT bronze.crm_cust_info
    FROM '/tmp/cust_info.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK 
    );
SET @end_time = GETDATE();
PRINT '>> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time ) AS NVARCHAR) + 'seconds';
PRINT'----------------';

SET @start_time = GETDATE();
PRINT'>> Truncating Table:bronze.crm_prd_info';
    TRUNCATE TABLE bronze.crm_prd_info
PRINT'>> Inserting data into:bronze.crm_prd_info';
    BULK INSERT bronze.crm_prd_info
    FROM '/tmp/prd_info.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK 
    );
    SET @end_time = GETDATE();
PRINT '>> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time ) AS NVARCHAR) + 'seconds';
PRINT'----------------';

    SET @start_time = GETDATE();
PRINT'>> Truncating Table:bronze.crm_sales_details';
    TRUNCATE TABLE bronze.crm_sales_details
PRINT'>> Inserting data into:bronze.crm_sales_details';
    BULK INSERT bronze.crm_sales_details
    FROM '/tmp/sales_details.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK 
    );SET @end_time = GETDATE();
PRINT '>> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time ) AS NVARCHAR) + 'seconds';
PRINT'----------------';


PRINT '-----------------------------------------';
PRINT'Loading ERP Table';
PRINT '-----------------------------------------';

SET @start_time = GETDATE();
PRINT'>> Truncating Table:bronze.erp_cust_az12';
    TRUNCATE TABLE bronze.erp_cust_az12
PRINT'>> Inserting data into:bronze.erp_cust_az12';
    BULK INSERT bronze.erp_cust_az12
    FROM '/tmp/cust_az12.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK 
    );SET @end_time = GETDATE();
PRINT '>> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time ) AS NVARCHAR) + 'seconds';
PRINT'----------------';


SET @start_time = GETDATE();
PRINT'>> Truncating Table:bronze.erp_loc_a101';
    TRUNCATE TABLE bronze.erp_loc_a101
PRINT'>> Inserting data into:bronze.erp_loc_a101';
    BULK INSERT bronze.erp_loc_a101
    FROM '/tmp/loc_a101.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK 
    );
    SET @end_time = GETDATE();
PRINT '>> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time ) AS NVARCHAR) + 'seconds';
PRINT'----------------';


SET @start_time = GETDATE();
PRINT'>> Truncating Table:bronze.erp_px_cat_g1v2';
    TRUNCATE TABLE bronze.erp_px_cat_g1v2
    PRINT'>> Inserting data into:bronze.erp_px_cat_g1v2';
    BULK INSERT bronze.erp_px_cat_g1v2
    FROM '/tmp/PX_CAT_G1V2.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK 
    );
    SET @end_time = GETDATE();
PRINT '>> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time ) AS NVARCHAR) + 'seconds';
PRINT'----------------';
SET @end_time = GETDATE();
PRINT '>> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time ) AS NVARCHAR) + 'seconds';
PRINT'----------------';


    SET @batch_start_time = GETDATE();
    PRINT '================================';
    PRINT 'Loading bronze layer is completed';
    PRINT 'Total load duration: ' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time)AS NVARCHAR) + 'seconds';
    END TRY
    BEGIN CATCH
        PRINT'=========================================='
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
        PRINT 'Error Mesaage' + ERROR_MESSAGE();  
        PRINT 'Error Mesaage' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error Mesaage' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT'=========================================='
    END CATCH
END
