--
use [mavendb_41]
-- use [maven_rpt]

--use mavendb_test

IF object_id ('tempdb..#temp1') IS NOT NULL drop table #temp1




SELECT [UNID] as Import_UNID
		--,left(substring([CONTENT],30+CHARINDEX('Name="ImportMessageID" Value="', [CONTENT]),50), charindex('"' ,substring([CONTENT],30+CHARINDEX('Name="ImportMessageID" Value="', [CONTENT]),50) )-1) as ImportMessageID
		--,CHARINDEX('Name="ImportMessageID" Value="', [CONTENT]) as ImportMessageID


      ,convert(nvarchar(40), [CREATE_DATE], 120) as ImportDateTime
      ,xs.ImportStatus
      ,case when xs.ImportStatus = 'Failed'  then xs.ImportStatus else xt.ImportType end  as ImportType
		,case when xs.ImportStatus = 'Failed'  then xs.ImportStatus
					else (case when CHARINDEX('Creating new case', [MESSAGE]) > 0 then 'Yes'else 'No' end) end as NewCase
		,case when xs.ImportStatus = 'Failed'  then xs.ImportStatus
					else (case when CHARINDEX('could not identify party', [MESSAGE]) > 0 then 'Yes'else 'No' end) end as NewParty
		,case when xs.ImportStatus = 'Failed'  then xs.ImportStatus
					else substring([MESSAGE],11+CHARINDEX('externalid:', [MESSAGE]),9) end as Event_ID
		,left(substring([CONTENT],11+CHARINDEX('FirstName="', [CONTENT]),50), CHARINDEX('"',substring([CONTENT],11+CHARINDEX('FirstName="', [CONTENT]),50))-1) as FirstName
		,CHARINDEX('FirstName="', [CONTENT]) as FirstName2

		,left(substring([CONTENT],12+CHARINDEX('MiddleName="', [CONTENT]),50), CHARINDEX('"',substring([CONTENT],12+CHARINDEX('MiddleName="', [CONTENT]),50))-1) as MiddleName
		,left(substring([CONTENT],10+CHARINDEX('LastName="', [CONTENT]),50), CHARINDEX('"',substring([CONTENT],10+CHARINDEX('LastName="', [CONTENT]),50))-1) as LastName
		,left(substring([CONTENT],10+CHARINDEX(' Street1="', [CONTENT]),50), CHARINDEX('"',substring([CONTENT],10+CHARINDEX(' Street1="', [CONTENT]),50))-1) as Street1
		,CHARINDEX(' Street1="', [CONTENT]) as Street3
		,left(substring([CONTENT],7+CHARINDEX(' City="', [CONTENT]),50), CHARINDEX('"',substring([CONTENT],7+CHARINDEX(' City="', [CONTENT]),50))-1) as City
		,left(substring([CONTENT],8+CHARINDEX(' State="', [CONTENT]),50), CHARINDEX('"',substring([CONTENT],8+CHARINDEX(' State="', [CONTENT]),50))-1) as State
		,CHARINDEX('State="', [CONTENT])  as State2
		,left(substring([CONTENT],13+CHARINDEX('ProductCode="', [CONTENT]),30),CHARINDEX('"',substring([CONTENT],13+CHARINDEX('ProductCode="', [CONTENT]),30))-1)  as Product
		,left(substring([CONTENT],29+CHARINDEX('Name="SpecimenNumber" Value="', [CONTENT]),30), charindex('"' ,substring([CONTENT],29+CHARINDEX('Name="SpecimenNumber" Value="', [CONTENT]),30) )-1) as SpecimenNumber
		,left(substring([CONTENT],19+CHARINDEX('Name="Test" Value="', [CONTENT]),30), charindex('"' ,substring([CONTENT],19+CHARINDEX('Name="Test" Value="', [CONTENT]),30) )-1) as LOINC

		,case when CHARINDEX('Name="Result" Value="', [CONTENT]) > 0  then left(substring([CONTENT],21+CHARINDEX('Name="Result" Value="', [CONTENT]),30), charindex('"' ,substring([CONTENT],21+CHARINDEX('Name="Result" Value="', [CONTENT]),30) )-1) 
		else '' end as SNOMED

		,case when CHARINDEX('Name="ReferenceRange" Value="', [CONTENT])  > 0  then 
		left(substring([CONTENT],29+CHARINDEX('Name="ReferenceRange" Value="', [CONTENT]),50), charindex('"' ,substring([CONTENT],29+CHARINDEX('Name="ReferenceRange" Value="', [CONTENT]),50) )-1) 
		else '' end as ReferenceRange

		,case when CHARINDEX('Name="CLIA" Value="', [CONTENT])  > 0  then 
		substring([CONTENT],19+CHARINDEX('Name="CLIA" Value="', [CONTENT]),10) 
		else '' end as CLIA

		,left(substring([CONTENT],12+CHARINDEX('ExternalID="', [CONTENT]),50), charindex('"' ,substring([CONTENT],12+CHARINDEX('ExternalID="', [CONTENT]),50) )-1) as ExternalID
,cast([MESSAGE] as nvarchar(4000)) as [Message]
,cast(CONTENT as nvarchar(4000)) as Content
--,CONTENT as ContentFull
into #temp1
from [IDS_IMPORT_ENTRY] ie
	join  (	
			select VALUE, DISPLAY_NAME as ImportStatus
			from IDS_ENUM_ENTRY
			where ENUM_NAME = 'Import.Status'
			) 
			xs on ie.STATUS = xs.VALUE
	join  (	
			select VALUE, DISPLAY_NAME  as ImportType
			from IDS_ENUM_ENTRY
			where ENUM_NAME = 'Import.Type'
			) 
			xt on ie.TYPE = xt.VALUE
where 1=1 
	--
	and cast(CREATE_DATE as date) >= dateadd(day,-1, cast(getdate() as date)) 
	--and CREATE_DATE between '04/08/2020' and '04/09/2020'
--order by CREATE_DATE desc





select [Import_UNID] 
	--,[ImportMessageID] 
	,[ImportDateTime] 
	,[ImportStatus] 
	,[ImportType] 
	,[NewCase] 
	,[NewParty] 
	,[Event_ID] 
	,[FirstName]
	,[MiddleName] 
	,[LastName] 
	,Street1
	,City
	,State
	,[Product] 
	,[SpecimenNumber] 
	,[LOINC] 
	,[SNOMED]
	,rc_snomed.DESCRIPTION
	,[CLIA] 
	,[ExternalID] 
	,[Message] 
	,[Content] 
	--,ContentFull
from #temp1
	left join [IDS_REFERENCE_CODE] rc_snomed  ON [SNOMED] = rc_snomed.REFERENCE_CODE 
												and rc_snomed.[REFERENCE_GROUP]= 'snomed' 
												and rc_snomed.SUBGROUP = 'SNOMED_LABTEST' 
where 1=1 
	--
	and (Product like '%wuhan%' )
	--and LastName = 'carroll'
	--	and Event_ID = '102159519'
	and CLIA = '45D2034771'
order by 	ImportDateTime desc --,[LastName] ,[FirstName] ,[MiddleName], 



/*


IF object_id ('tempdb..#temp1') IS NOT NULL drop table #temp1


select * 
from #temp1 		

where 1=1 
	and (Product like '%wuhan%' )
order by ImportDateTime desc 


declare @TableName as nvarchar(20) = '#temp1'
declare @object_id_str as nvarchar(20) = 'tempdb..' + @TableName
declare @from_str as nvarchar(20) = 'from ' + @TableName

if object_id ('tempdb..#tempSchema') is not null drop table #tempSchema
select column_id
	,case when column_id = 1 then  'select ['+name+'] '
		else ',[' + name + '] ' end as ColumnName
	, Name
into 	#tempSchema
from tempdb.sys.columns 
where object_id = object_id(@object_id_str);

insert into #tempSchema (column_id, ColumnName)
values ((SELECT TOP 1 column_id FROM #tempSchema ORDER BY column_id DESC)+1,@from_str);
select * from #tempSchema

	--	and (Product like '%unknown%' )
	-- and Event_ID = '102041519'	
	
	--	and (Product like '%wuhan%' or Product like '%unknown%' )
	--and ImportDate = cast(getdate() as date) --today	
	--and LastName = 'Gomez Banegas'
	--and ImportStatus ='Failed'
	--and snomed = '260373001' -- positive
	--and clia = '45D0490589'



*/