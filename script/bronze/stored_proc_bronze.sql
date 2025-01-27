/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

EXEC bronze.load_bronze


CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
DECLARE @start_time DATETIME, @endtime DATETIME,@batch_start_time DATETIME,@batch_end_time DATETIME;

	BEGIN TRY
	SET @batch_start_time = GETDATE();
	PRINT '========================================';
	PRINT 'Load Bronze Layer';
	PRINT '========================================';

		PRINT '------------------------------';
		PRINT ' Load CRM Tables ';
		PRINT '------------------------------';
		SET @start_time = GETDATE();
		PRINT'>> Trancating bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Raffaelo\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm/cust_info.csv'
		WITH
		(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);

		SET @endtime = GETDATE();
		
		PRINT'>> Load Duration :' + CAST(DATEDIFF(second,@start_time,@endtime) AS NVARCHAR) + 'Seconds';
		Print'......................................................................................';

		SET @start_time = GETDATE();
		PRINT'>> Trancating bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Raffaelo\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm/prd_info.csv'
		WITH
		(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);

		SET @endtime = GETDATE();
		
		PRINT'>> Load Duration :' + CAST(DATEDIFF(second,@start_time,@endtime) AS NVARCHAR) + 'Seconds';
		Print'......................................................................................';



			SET @start_time = GETDATE();
		PRINT'>> Trancating bronze.crm_sales_details';

		TRUNCATE TABLE bronze.crm_sales_details;
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Raffaelo\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm/sales_details.csv'
		WITH
		(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);

		SET @endtime = GETDATE();
		
		PRINT'>> Load Duration :' + CAST(DATEDIFF(second,@start_time,@endtime) AS NVARCHAR) + 'Seconds';
		Print'......................................................................................';

		PRINT '------------------------------';
		PRINT ' Load ERP Tables ';
		PRINT '------------------------------'

		SET @start_time = GETDATE();
		PRINT'>> Trancating bronze.erp_cust_az12';

		TRUNCATE TABLE bronze.erp_cust_az12;
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\Raffaelo\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp/CUST_AZ12.csv'
		WITH
		(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);

		SET @endtime = GETDATE();
		
		PRINT'>> Load Duration :' + CAST(DATEDIFF(second,@start_time,@endtime) AS NVARCHAR) + 'Seconds';
		Print'......................................................................................';



		SET @start_time = GETDATE();
		PRINT'>> Trancating bronze.erp_loc_a101';

		TRUNCATE TABLE bronze.erp_loc_a101;
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\Raffaelo\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp/LOC_A101.csv'
		WITH
		(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @endtime = GETDATE();
		
		PRINT'>> Load Duration :' + CAST(DATEDIFF(second,@start_time,@endtime) AS NVARCHAR) + 'Seconds';
		Print'......................................................................................';


		SET @start_time = GETDATE();
		PRINT'>> Trancating bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\Raffaelo\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp/PX_CAT_G1V2.csv'
		WITH
		(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @endtime = GETDATE();
		
		PRINT'>> Load Duration :' + CAST(DATEDIFF(second,@start_time,@endtime) AS NVARCHAR) + 'Seconds';
		Print'......................................................................................';


		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
	END TRY
	BEGIN CATCH
	PRINT'===========================================';
	PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER'
	PRINT 'Error Message' + ERROR_MESSAGE();
	PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
	PRINT 'Error Message' + CAST(ERROR_STATE()AS NVARCHAR);
	PRINT'===========================================';

	END CATCH


END


