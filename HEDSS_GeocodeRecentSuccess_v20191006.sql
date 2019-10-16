
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Geocode Success by Wes McNeely 10/16/2019                                                @@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Purpose: Display geocode status of all addresses                                         @@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Instructions: 1. execute query                                                           @@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ For Help:     wesley.mcneely@houstontx.gov, 281-433-7934                                 @@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

select
	case GEOCODE_STATUS
		when -4 then '2_Invalid Data'
		when -3 then '3_Incomplete Data'
		when -2 then '1_Validation Error'
		when -1 then '0_Error'
		when  0 then '4_Pending'
		when  1 then '5_Successful'
		when  2 then '6_Manual'
		end as GeocodeStatus
 ,count(*)  as Addresses
 ,cast(100.0 * cast(count(*) as decimal(8,1))/cast((select count(*) from IDS_CONTACTPOINT)as decimal(8,1)) as decimal(8,1)) as [%]

from IDS_CONTACTPOINT  

group by case GEOCODE_STATUS
		when -4 then '2_Invalid Data'
		when -3 then '3_Incomplete Data'
		when -2 then '1_Validation Error'
		when -1 then '0_Error'
		when  0 then '4_Pending'
		when  1 then '5_Successful'
		when  2 then '6_Manual'
		end 

UNION 

select '7_TOTAL' as GeocodeStatus
	,count(*)  as Addresses
	,100.0 as [%]
from IDS_CONTACTPOINT
order by	
	case GEOCODE_STATUS
		when -4 then '2_Invalid Data'
		when -3 then '3_Incomplete Data'
		when -2 then '1_Validation Error'
		when -1 then '0_Error'
		when  0 then '4_Pending'
		when  1 then '5_Successful'
		when  2 then '6_Manual'
		end

