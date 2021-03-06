﻿--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Table Schemas by wsm 10/24/2019                                  
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Purpose: Display Fields of any table in the database
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Instructions: 1. execute query within a SQL Server client like SSMS
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


select [TABLE_CATALOG]
      ,[TABLE_NAME]
      ,[COLUMN_NAME]
      ,','+ [COLUMN_NAME] as ColumnNameWithComma
      ,[ORDINAL_POSITION]
      ,[IS_NULLABLE]
      ,[DATA_TYPE]
      ,[CHARACTER_MAXIMUM_LENGTH]
      ,[NUMERIC_PRECISION]
      ,[DATETIME_PRECISION]
  from [INFORMATION_SCHEMA].[COLUMNS]
 where TABLE_NAME in ('IDS_CASE')  
 order by TABLE_NAME, ORDINAL_POSITION

