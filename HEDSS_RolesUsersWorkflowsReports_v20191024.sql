--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Roles, Users, Workflows, and Reports by wsm 10/24/2019                                                        
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Purpose:  Outputs list of all active (0) and inactive (1) Roles with their Users, Workflows, and Reports
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Instructions: 1. execute from a SQL Server client like SSMS or within a Maven tabular report
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@



-- Roles and Users

IF object_id ('tempdb..#temp') IS NOT NULL drop table #temp

SELECT


	  r.UNID											as ROLE_UNID
	  ,cast(r.STATUS as nvarchar(1)) 	+ ' - ' + r.NAME				as Role
	  ,case when u.STATUS is null then '' else 
		cast(u.STATUS as varchar(1))	+ ' - ' + pty.FULL_NAME	
		end		as MavenUser

into #temp 

FROM IDS_ROLE r 
  left join IDS_USER_ROLE_MAP urm			on r.UNID = urm.ROLE_ID
  left join IDS_USER u					on urm.USER_ID = u.UNID
  left join IDS_PARTY pty					on u.PARTY_ID = pty.UNID

where 1=1 



--  select * from #temp



-- Denormalize Users

IF object_id ('tempdb..#tempRU') IS NOT NULL drop table #tempRU


select 
		Role_UNID
		,t1.Role
		,MavenUsers = STUFF(										
								(								
								select ', '+ MavenUser				
								from #temp t2						
								where t2.Role_UNID = t1.ROLE_UNID	
								order by User				
								FOR XML PATH('')
								),1,1,''			
						)										
into #tempRU
from #temp t1

group by t1.ROLE_UNID 
		,t1.Role
order by t1.Role



--	select * from #tempRU

-- Roles Users Workflows

IF object_id ('tempdb..#tempRUW') IS NOT NULL drop table #tempRUW

select ru.Role_UNID 
		,ru.Role 
		,ru.MavenUsers 
		,case when wq.NAME is null then ''
			else cast(wq.STATUS as varchar(1))	+ ' - ' + wq.NAME end as Workflow
into #tempRUW
from #tempRU ru
		left join IDS_WORKFLOW_QUERY_ROLEMAP wfr		on ru.ROLE_UNID = wfr.ROLE_ID
		left join IDS_WORKFLOW_QUERY wq				on wfr.QUERY_ID = wq.UNID


--	select * from #tempRUW



-- Denormalize Workflows

IF object_id ('tempdb..#tempRUW2') IS NOT NULL drop table #tempRUW2


select 
		t1.Role_UNID
		,t1.Role
		,t1.MavenUsers
		,Workflows = STUFF(										
								(								
								select ', '+ Workflow			
								from #tempRUW t2					
								where t2.Role_UNID = t1.ROLE_UNID	
								order by Workflow				
								FOR XML PATH('')
								),1,1,''			
						)										
into #tempRUW2

from #tempRUW t1

group by t1.ROLE_UNID 
		,t1.Role
		,t1.MavenUsers

order by t1.Role



-- select * from #tempRUW2

--Roles, Users, Worflows, Reports


IF object_id ('tempdb..#tempRUWRp') IS NOT NULL drop table #tempRUWRp


select ru.Role_UNID 
		,ru.Role 
		,ru.MavenUsers
		,ru.Workflows 
		,case when rp.NAME is null then ''
			else cast(rp.STATUS as varchar(1))	+ ' - ' + rp.NAME end as Report
into #tempRUWRp
from #tempRUW2 ru
		left join IDS_REPORT_ROLEMAP rr		on ru.ROLE_UNID = rr.ROLE_ID
		left join IDS_REPORT rp				on rr.REPORT_ID = rp.UNID
order by ru.Role_UNID 


--select * from #tempRUWRp

-- Denormalize Reports


IF object_id ('tempdb..#tempRUWRp2') IS NOT NULL drop table #tempRUWRp2


select 
		t1.Role_UNID
		,t1.Role
		,t1.MavenUsers
		,Workflows 
		,Reports= STUFF(										
							(								
							select ', '+ Report				
							from #tempRUWRp t2					
							where t2.Role_UNID = t1.ROLE_UNID	
							order by Report				
							FOR XML PATH('')
							),1,1,''			
						)									
into #tempRUWRp2

from #tempRUWRp t1

group by t1.ROLE_UNID 
		,t1.Role
		,t1.MavenUsers
		,t1.Workflows

order by t1.Role


--Final Output

select * from #tempRUWRp2 order by Role



