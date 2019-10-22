--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Maven Audit by Wes McNeely 10/16/2019                                                    @@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Purpose: Display Audit Events                                                            @@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Instructions: 1. select audit event values using code below in step 1                    @@@@@@@@@@@
--@@@               2. take values for events you want to view and enter                       @@@@@@@@@@@
--@@@                   them in the 'where' statement i.e.				       @@@@@@@@@@@
--@@@                   'and ae.[EVENT_TYPE] in (0,1,2,3,4,5)' ... add your own                @@@@@@@@@@@
--@@@               3. choose the login name you want to audit and set 'where' statement       @@@@@@@@@@@
--@@@               4. choose the date range you want to audit and set 'where' statement       @@@@@@@@@@@
--@@@               5. execute query                                                           @@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


/*  Use this code to pick audit event values from the IDS_ENUM_ENTRY table									--step 1

	select ENUM_NAME, VALUE, DISPLAY_NAME
	from IDS_ENUM_ENTRY
	where ENUM_NAME = 'Audit.Event'
	
*/

select	ae.UNID								as Audit_UNID
		,ae.CASE_ID						as Case_UNID
		,p.FULL_NAME						as ActionBy
		,ae.CREATE_DATE						as ActionDate
		,en.DISPLAY_NAME					as ActionType
		,ae.[MESSAGE]						as ActionDescription
		,cast(ae.DETAILS as nvarchar(4000)) 			as ActionDetails
		,ae.OLD_VALUE						as OldValue
		,ae.NEW_VALUE						as NewValue	

from	IDS_AUDIT_EVENT ae
		join IDS_USER u on ae.[USER_ID] = u.UNID
		join IDS_PARTY p on u.PARTY_ID = p.UNID
		join  (	
				select [VALUE], DISPLAY_NAME
				from IDS_ENUM_ENTRY
				where ENUM_NAME = 'Audit.Event'
			  ) 
			  en on ae.EVENT_TYPE = en.[VALUE]

where	1=1 
		and ae.[EVENT_TYPE] in (0,1,2,3,4,5)	-- enter event types to be audited.								--step 2
												--  0 'Open Case'
												--, 1 'Search Case'
												--, 2 'View Report'
												--, 3 'Add User'
												--, 4 'Edit User'
												--, 5 'Add Role' 
		and u.LOGIN_NAME = 'wmcneely'			-- change target of audit or comment out to ausit everyone		--step 3
		-- and u.LOGIN_NAME in ('rkhayat', 'dmorrison')			
		and ae.CREATE_DATE between '01/01/2019' and getdate()													--step 4
												 
order by ae.CREATE_DATE 
		--,ae.[EVENT_TYPE] 

