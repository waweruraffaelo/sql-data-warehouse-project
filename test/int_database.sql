/*
============================
Create database and schemas
===============================

Schemas created
1.Bronze
2.Silver.
3.Gold
WARNING: 
  Running the script will drop DataWarehouse 
*/
USE master;

IF EXISTS(SELECT 1 FROM  sys.databases WHERE name ='DataWarehouse')
  BEGIN
  ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE DataWarehouse
  END;
GO
 ----Create database
CREATE DATABASE DataWarehouse;
GO
USE DataWarehouse;
GO

 ----Create schema 
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
