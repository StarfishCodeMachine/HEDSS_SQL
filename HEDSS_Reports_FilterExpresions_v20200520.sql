/****** Script for SelectTopNRows command from SSMS  ******/
use [Maven_41_rpt]

SELECT distinct 
	left(substring([REPORT_CONFIG],7+CHARINDEX('Filter=', [REPORT_CONFIG]),4000),charindex('|', substring([REPORT_CONFIG],7+CHARINDEX('Filter=', [REPORT_CONFIG]),4000))-1) as FilterExpresions

FROM [IDS_REPORT]
where 1=1 
	and cast([REPORT_CONFIG] as nvarchar(4000))  is not null
	and charindex('Filter=', cast([REPORT_CONFIG] as nvarchar(4000))) >0
	and substring([REPORT_CONFIG],7+CHARINDEX('Filter=', [REPORT_CONFIG]),1000) not like '|%'





