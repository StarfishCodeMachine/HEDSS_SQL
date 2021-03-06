--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Event History wsm 10/24/2019                                  
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Purpose: List the case history (event history tab) of a case
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Instructions: 1. replace the maven id in the @event_ID variable with the ID you want
--@@@				2. execute query within a SQL Server client like SSMS
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

declare @event_id bigint = 9999999999

select c.EXTERNAL_ID			as Event_ID
      ,ch.ORIGINAL_CASE_ID
	  ,che.DISPLAY_NAME			as Event
      ,ch.CREATE_DATE			as CaseHistoryDate
      ,ch.MESSAGE
	  ,p.FULL_NAME				as PerformedBy
from IDS_CASE_HISTORY ch
	join IDS_CASE c on ch.CASE_ID = c.UNID
	join	(	
			select VALUE, DISPLAY_NAME
			from IDS_ENUM_ENTRY
			where ENUM_NAME = 'Case.History.Event'
			) 
			che on ch.EVENT_TYPE = che.VALUE
	join IDS_USER u on ch.USER_ID = u.UNID
	join IDS_PARTY p on u.PARTY_ID = p.UNID
where 1=1 
	and c.EXTERNAL_ID =	@event_id