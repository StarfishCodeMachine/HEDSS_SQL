﻿--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Groups, Users, Workflows, and Reports by wsm 10/23/2019                                  
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Purpose: Outputs list of all active (0) and inactive (1) Groups with their Users, Workflows, and Reports
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Instructions: 1. execute query within a SQL Server client like SSMS 
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@



IF object_id ('tempdb..#temp') IS NOT NULL drop table #temp

SELECT

	  r.UNID																as Group_UNID
	  ,cast(r.[STATUS] as nvarchar(1)) 	+ ' - ' + r.NAME					as [Group]
	  ,case when u.[STATUS] is null then '' else 
		cast(u.[STATUS] as varchar(1))	+ ' - ' + pty.FULL_NAME	
		end																	as [User]

into #temp 

FROM [IDS_USERGROUP] r 
  left join [IDS_USERGROUP_MEMBERSHIP] urm			on r.UNID = urm.GROUP_ID
  left join [IDS_USER] u					on urm.[USER_ID] = u.UNID
  left join IDS_PARTY pty					on u.PARTY_ID = pty.UNID

where 1=1 


-- Denormalize Users

IF object_id ('tempdb..#tempRU') IS NOT NULL drop table #tempRU

select 
		Group_UNID
		,t1.[Group]
		,Users = STUFF(										
								(									
								select ', '+ [User]				
								from #temp t2						
								where t2.Group_UNID = t1.Group_UNID
								order by [User]					
								FOR XML PATH('')
								),1,1,''			
						)									
into #tempRU
from #temp t1
group by t1.Group_UNID 
		,t1.[Group]
order by t1.[Group]



-- Groups Users Workflows

IF object_id ('tempdb..#tempRUW') IS NOT NULL drop table #tempRUW

select ru.Group_UNID 
		,ru.[Group] 
		,ru.[Users] 
		,case when wq.NAME is null then ''
			else cast(wq.[STATUS] as varchar(1))	+ ' - ' + wq.NAME end as Workflow
into #tempRUW
from #tempRU ru
		left join [IDS_WORKFLOW_QUERY_GROUPMAP] wfr		on ru.Group_UNID = wfr.GROUP_ID
		left join [IDS_WORKFLOW_QUERY] wq				on wfr.QUERY_ID = wq.UNID



-- Denormalize Workflows

IF object_id ('tempdb..#tempRUW2') IS NOT NULL drop table #tempRUW2

select 
		t1.Group_UNID
		,t1.[Group]
		,t1.Users
		,Workflows = STUFF(										
								(									
								select ', '+ Workflow				
								from #tempRUW t2						
								where t2.Group_UNID = t1.Group_UNID	
								order by Workflow					
								FOR XML PATH('')
								),1,1,''			
						)										
into #tempRUW2

from #tempRUW t1

group by t1.Group_UNID 
		,t1.[Group]
		,t1.Users

order by t1.[Group]



--Groups, Users, Worflows, Reports


IF object_id ('tempdb..#tempRUWRp') IS NOT NULL drop table #tempRUWRp


select ru.Group_UNID 
		,ru.[Group] 
		,ru.[Users]
		,ru.Workflows 
		,case when rp.NAME is null then ''
			else cast(rp.[STATUS] as varchar(1))	+ ' - ' + rp.NAME end as Report
into #tempRUWRp
from #tempRUW2 ru
		left join [IDS_REPORT_GROUPMAP] rr		on ru.Group_UNID = rr.GROUP_ID
		left join [IDS_REPORT] rp				on rr.REPORT_ID = rp.UNID
order by ru.Group_UNID 

-- Denormalize Reports

IF object_id ('tempdb..#tempRUWRp2') IS NOT NULL drop table #tempRUWRp2

select 
		t1.Group_UNID
		,t1.[Group]
		,t1.Users
		,Workflows 
		,Reports= STUFF(										
								(								
								select ', '+ Report				
								from #tempRUWRp t2					
								where t2.Group_UNID = t1.Group_UNID	
								order by Report					
								FOR XML PATH('')
								),1,1,''			
						)										
into #tempRUWRp2

from #tempRUWRp t1

group by t1.Group_UNID 
		,t1.[Group]
		,t1.Users
		,t1.Workflows

order by t1.[Group]


--Final Output

select * from #tempRUWRp2 order by [Group]



