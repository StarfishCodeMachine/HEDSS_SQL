--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Task History wsm 10/24/2019                                  
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Purpose: List the task history of a case
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Instructions: 1. replace the maven id in the @Event_ID variable with the ID you want
--@@@				2. execute query within a SQL Server client like SSMS
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

-- use maven_rpt

declare @event_id int = 999999999 -- i.e. Case ID


select distinct
	c.EXTERNAL_ID										as Event_ID   
	,t.UNID												as Task_UNID	
	,convert(nvarchar(30), t.CREATE_DATE,121)			as TaskCreateDate
	,cbp.FULL_NAME										as TaskCreatedBy
	,t.DESCRIPTION										as TaskDescription
	,tt.DISPLAY_NAME									as TaskType
	,ts.DISPLAY_NAME									as TaskStatus
	,t.NOTES											as TaskNotes
	,atp.FULL_NAME										as TaskAssignedToUser
	,atg.NAME											as TaskAssignedToGroup
	,mbp.FULL_NAME										as TaskModifiedBy	  
	,t.MODIFICATION_DATE								as TaskModifiedDate

FROM IDS_TASK t
		join IDS_CASE c on t.CASE_ID = c.UNID
		left join IDS_PRODUCT pr on c.PRODUCT_ID = pr.UNID
		left join IDS_USER atu on t.USER_ID = atu.UNID
		left join IDS_USER mbu on t.MODIFIED_BY_ID = mbu.UNID
		left join IDS_USER cbu on t.CREATED_BY_ID = cbu.UNID
		left join IDS_PARTY atp on atu.PARTY_ID = atp.UNID
		left join IDS_PARTY mbp on mbu.PARTY_ID = mbp.UNID
		left join IDS_PARTY cbp on cbu.PARTY_ID = cbp.UNID
		left join IDS_USERGROUP atg on t.USERGROUP_ID = atg.UNID
		left join IDS_USERGROUP abg on t.USERGROUP_ID = atg.UNID
	  join  (	
					select VALUE, DISPLAY_NAME
					from IDS_ENUM_ENTRY
					where ENUM_NAME = 'Task.Type'
				  ) 
				  tt on t.TYPE = tt.VALUE
	  join  (	
					select VALUE, DISPLAY_NAME
					from IDS_ENUM_ENTRY
					where ENUM_NAME = 'Task.Status'
				  ) 
				  ts on t.STATUS = ts.VALUE

where 1=1 
	and c.CASE_ID =	@event_id

order by t.UNID