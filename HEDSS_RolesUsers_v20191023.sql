﻿
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Active Roles and Active Users by wsm 10/23/2019                                  
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Purpose: Creates a list of Active Roles and the Active Users who have the Roles
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Instructions: 1. execute Query 1 from a SQL Server client like SSMS 
--@@@               2. execute Query 2 within a Maven tabular report
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@



--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@  Query 1
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

-- use maven_db1

IF object_id ('tempdb..#temp') is not null  drop table #temp

select u.[UNID]					as UserUNID
      ,u.[LOGIN_NAME]			as UserLOGIN_NAME
      ,u.[NOTES]					as UserNOTES
      ,u.[LAST_LOGIN]				as UserLAST_LOGIN
      ,u.[SUPERVISOR_ID]					as UserSUPERVISOR_ID
      ,u.[PARTY_ID]					as UserPARTY_ID
	  ,pty.FULL_NAME as UserNAME
	  ,r.UNID as ROLE_UNID
	  ,r.NAME as ROLE_Name
into #temp 
from IDS_USER u 
  left join [IDS_USER_ROLE_MAP] urm on u.UNID = urm.USER_ID
  left join [IDS_ROLE] r on urm.ROLE_ID = r.UNID
  left join IDS_PARTY pty on u.PARTY_ID = pty.UNID
where 1=1 
	and u.STATUS = 0   --active users
	and r.STATUS = 0   --active roles


select 
		ROLE_UNID
		,t1.ROLE_Name
		,RoleMembers = STUFF(										--<<<<<
								(									--<<<<<
								select ', '+ UserNAME				--<<<<<
								from #temp t2						--<<<<<	
								where ROLE_UNID = t1.ROLE_UNID		--<<<<< a little trick i pulled off the internet
								order by ROLE_Name					--<<<<<	
								FOR XML PATH('')),1,1,''			--<<<<<	
							)										--<<<<<
from #temp t1
where t1.ROLE_UNID is not null 
group by t1.ROLE_UNID 
		,t1.ROLE_Name
order by t1.ROLE_Name


--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@  Query 2 
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@



select 
		RoleUNID as [Role UNID]
		,t1.RoleName as [Role Name]
		,[Role Members] = stuff(
								(
								select ', '+ UserName 
								from	(
										select 
												r.UNID as RoleUNID
												,r.NAME as RoleName
												,pty.FULL_NAME as UserName
										from IDS_USER u 
										  left join IDS_USER_ROLE_MAP urm on u.UNID = urm.USER_ID
										  left join IDS_ROLE r on urm.ROLE_ID = r.UNID
										  left join IDS_PARTY pty on u.PARTY_ID = pty.UNID
										where u.STATUS = 0
											and r.STATUS = 0   
										) t2 
								where RoleUNID = t1.RoleUNID 
								order by RoleName
								for xml path('')
								),1,1,''
							)
from	(
		select 
				r.UNID as RoleUNID
				,r.NAME as RoleName
				,pty.FULL_NAME as UserName
		from IDS_USER u 
		  left join IDS_USER_ROLE_MAP urm on u.UNID = urm.USER_ID
		  left join IDS_ROLE r on urm.ROLE_ID = r.UNID
		  left join IDS_PARTY pty on u.PARTY_ID = pty.UNID
		where u.STATUS = 0
		and r.STATUS = 0   
		) as t1
where t1.RoleUNID is not null 
group by t1.RoleUNID 
		,t1.RoleName
order by t1.RoleName

