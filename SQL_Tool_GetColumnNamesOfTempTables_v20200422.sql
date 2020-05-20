--/*

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

--*/
