--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ 24 Hours of ELRs by wsm 10/23/2019                                  
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Purpose: Display hourly counts of ELRs for prior 24 hours
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Instructions: 1. execute query within a SQL Server client like SSMS
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


-- use maven_db1

if object_id ('tempdb..#Calendar') is not null drop table #Calendar
create table #Calendar
(
    CalendarDate datetime
)

declare @StartDate datetime
declare @EndDate datetime
set @EndDate = getdate()
set @StartDate = @EndDate -1

while @StartDate <= @EndDate
      begin
             insert into #Calendar
             (
                   CalendarDate
             )
             select  @StartDate

             set @StartDate = DATEADD(HH, 1, @StartDate) 
		end

if object_id ('tempdb..#Calendar2') is not null drop table #Calendar2

select convert(varchar(8), CalendarDate, 112) + ' ' 
			+ right('0' + cast(datepart(HH, CalendarDate) as varchar(2)), 2) as Date_Hour
into #Calendar2
from #Calendar 

if object_id ('tempdb..#elrs') is not null drop table #elrs

select convert(varchar(8), CREATE_DATE, 112) + ' ' 
			+ right('0' + cast(datepart(HH, CREATE_DATE) as varchar(2)), 2) as Date_Hour
		,count(*) as Count
into #elrs
from IDS_INVESTIGATION  
where 1=1
	and CREATE_DATE between  getdate()-1 and getdate()
	and DESCRIPTION is null -- i.e. ELR
group by convert(varchar(8), CREATE_DATE, 112) + ' ' 
			+ right('0' + cast(datepart(HH, CREATE_DATE) as varchar(2)), 2)
	
select c.Date_Hour + ':00 hrs' as Hour
		,case  when e.Count is null then '0' else e.Count end as Count
from #Calendar2 c left join #elrs e on c.Date_Hour = e.Date_Hour
order by c.Date_Hour desc
