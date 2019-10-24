--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Geocode Status by wsm 10/16/2019                                  
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Purpose: Display geocode status of select addresses or cases           
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Instructions: 1. put maven id in 'where' statement under 'and c.EXTERNAL_ID = ......    
--@@@               2. or put filter values for the other fields you want                     
--@@@               3. execute query                                                          
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


select 	
	c.EXTERNAL_ID							as Event_ID
	,c.UNID									as Case_UNID
	,prod.CODE								as ProductCode
	,case a.GEOCODE_STATUS
		when -4 then 'Invalid Data'
		when -3 then 'Incomplete Data'
		when -2 then 'Validation Error'
		when -1 then 'Error'
		when  0 then 'Pending'
		when  1 then 'Successful'
		when  2 then 'Manual'
		end									as GeocodeStatus
	,a.STREET1
	,a.CITY
	,a.STATE
	,a.POSTAL_CODE
	,a.LATITUDE
	,a.LONGITUDE
	,a.COUNTY
	--,TRACT
	--,OFFICIAL_PLACE
	--,BLOCK				--add any custom fields you might have

from IDS_CONTACTPOINT a 
	join IDS_PARTY p			on a.PARTY_ID		= p.UNID
	join IDS_PARTICIPANT pt		on p.UNID			= pt.PARTY_ID
	join IDS_CASE c				on pt.CASE_ID		= c.UNID
	join IDS_PRODUCT prod		on c.PRODUCT_ID		= prod.UNID
where	1=1
		and c.EXTERNAL_ID = 99999999									--step 1
		--and a.STREET1 = '123 Mickey Mouse St'								--step 2
		--and p.CREATE_DATE between '01/01/2014' and '02/01/2014'		--step 2
		--and prod.CODE not in ('HEPC_C','HEPB_C')						--step 2
		--and a.GEOCODE_STATUS = 1										--step 2





--use mavendb_test
/*
select 	
	c.EXTERNAL_ID as MavenID
	,p.CREATE_DATE
	,FULL_NAME	
	,case GEOCODE_STATUS
		when -4 then 'Invalid Data'
		when -3 then 'Incomplete Data'
		when -2 then 'Validation Error'
		when -1 then 'Error'
		when  0 then 'Pending'
		when  1 then 'Successful'
		when  2 then 'Manual'
		end as GeocodeStatus
	,STREET1
	,CITY
	,STATE
	,POSTAL_CODE
	,LATITUDE
	,LONGITUDE
	,COUNTY
	,OFFICIAL_PLACE
	,TRACT
	--,BLOCK

from IDS_CONTACTPOINT A 
	join IDS_PARTY p on a.PARTY_ID = p.UNID
	join IDS_PARTICIPANT pt on p.UNID = pt.PARTY_ID
	join IDS_CASE c on pt.CASE_ID = c.UNID
where	1=1
		and p.CREATE_DATE between '01/01/2015' and '02/01/2015'
		--and STREET1 = '123 Mickey Mouse St'
		--and c.EXTERNAL_ID = 99999999
		--and COUNTY = 'Dullard County'
		--and OFFICIAL_PLACE = 'Galveston'


--use mavendb_test



select count(*) as [Count]
	,case GEOCODE_STATUS
		when -4 then 'Invalid Data'
		when -3 then 'Incomplete Data'
		when -2 then 'Validation Error'
		when -1 then 'Error'
		when  0 then 'Pending'
		when  1 then 'Successful'
		when  2 then 'Manual'
		end as GeocodeStatus
	,COUNTY
	,OFFICIAL_PLACE

from IDS_CONTACTPOINT A 
	join IDS_PARTY p on a.PARTY_ID = p.UNID
	join IDS_PARTICIPANT pt on p.UNID = pt.PARTY_ID
	join IDS_CASE c on pt.CASE_ID = c.UNID
where	1=1
		and p.CREATE_DATE between '01/01/2015' and '01/02/2016'
		--and STREET1 = '123 Mickey Mouse St'
		--and c.EXTERNAL_ID = 99999999
group by 
	case GEOCODE_STATUS
		when -4 then 'Invalid Data'
		when -3 then 'Incomplete Data'
		when -2 then 'Validation Error'
		when -1 then 'Error'
		when  0 then 'Pending'
		when  1 then 'Successful'
		when  2 then 'Manual'
		end
			,COUNTY
	,OFFICIAL_PLACE

order by  count(*) desc

--order by 
--	case GEOCODE_STATUS
--		when -4 then 'Invalid Data'
--		when -3 then 'Incomplete Data'
--		when -2 then 'Validation Error'
--		when -1 then 'Error'
--		when  0 then 'Pending'
--		when  1 then 'Successful'
--		when  2 then 'Manual'
--		end
--			,COUNTY
--	,OFFICIAL_PLACE


*/
