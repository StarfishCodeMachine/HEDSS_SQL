--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Report Server Freshness by wsm 10/24/2019                                  
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Purpose: Check how old the newest record in the HEDSS maven_rpt db      
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Instructions: 1. execute query 
--@@@               2. If the report server is supposed to be updated daily but the last record is more 
--@@@					than 24 hours old it should be investigated and corrected
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


--USE maven_rpt;

select case 
		when	
				cast((datediff(ss, max(CREATE_DATE),getdate())/86400)/30 as nvarchar) = '0' 
			and	cast((datediff(ss, max(CREATE_DATE),getdate())/86400)%30 as nvarchar) = '0' 
		then

			'At ' 
			+ left(convert(nvarchar(30), getdate(), 114), 5) 
			+ 'hrs on ' 
			+ datename(dw, getdate()) 
			+ ', ' 
			+ convert(nvarchar(30), getdate(), 101) 
			+ ', the newest case in the HEDSS Report Database has a CREATE_DATE of ' 
			+ datename(dw, max(CREATE_DATE))
			+ ', ' 
			+ convert(nvarchar(30),max(CREATE_DATE), 101)
			+ ', ' 
			+ left(convert(nvarchar(30),max(CREATE_DATE), 114), 5)  
			+ 'hrs, which is ' 
			+ cast((datediff(ss, max(CREATE_DATE),getdate())%86400)/3600 as nvarchar) + ' hours, ' 
			+ cast((datediff(ss, max(CREATE_DATE),getdate())%3600)/60 as nvarchar) + ' minutes, and ' 
			+ cast(datediff(ss, max(CREATE_DATE),getdate())%60 as nvarchar) + ' seconds old.' 

		when	cast((datediff(ss, max(CREATE_DATE),getdate())/86400)/30 as nvarchar) = '0' 
			and	cast((datediff(ss, max(CREATE_DATE),getdate())/86400)%30 as nvarchar) = '1' 
		then

			'At ' 
			+ left(convert(nvarchar(30), getdate(), 114), 5) 
			+ 'hrs on ' 
			+ datename(dw, getdate()) 
			+ ', ' 
			+ convert(nvarchar(30), getdate(), 101) 
			+ ', the newest case in the HEDSS Report Database has a CREATE_DATE of ' 
			+ datename(dw, max(CREATE_DATE))
			+ ', ' 
			+ convert(nvarchar(30),max(CREATE_DATE), 101)
			+ ', ' 
			+ LEFT(convert(nvarchar(30),max(CREATE_DATE), 114), 5)  
			+ 'hrs, which is ' 
			+ cast((datediff(ss, max(CREATE_DATE),getdate())/86400)%30 as nvarchar) + ' day, ' 
			+ cast((datediff(ss, max(CREATE_DATE),getdate())%86400)/3600 as nvarchar) + ' hours, ' 
			+ cast((datediff(ss, max(CREATE_DATE),getdate())%3600)/60 as nvarchar) + ' minutes, and ' 
			+ cast(datediff(ss, max(CREATE_DATE),getdate())%60 as nvarchar) + ' seconds old.' 

		when	cast((datediff(ss, max(CREATE_DATE),getdate())/86400)/30 as nvarchar) = '0' 
			and	cast((datediff(ss, max(CREATE_DATE),getdate())/86400)%30 as nvarchar) > '1' 
		then

			'At ' 
			+ LEFT(convert(nvarchar(30), getdate(), 114), 5) 
			+ 'hrs on ' 
			+ datename(dw, getdate()) 
			+ ', ' 
			+ convert(nvarchar(30), getdate(), 101) 
			+ ', the newest case in the HEDSS Report Database has a CREATE_DATE of ' 
			+ datename(dw, max(CREATE_DATE))
			+ ', ' 
			+ convert(nvarchar(30),max(CREATE_DATE), 101)
			+ ', ' 
			+ left(convert(nvarchar(30),max(CREATE_DATE), 114), 5)  
			+ 'hrs, which is ' 
			+ cast((datediff(ss, max(CREATE_DATE),getdate())/86400)%30 as nvarchar) + ' days, ' 
			+ cast((datediff(ss, max(CREATE_DATE),getdate())%86400)/3600 as nvarchar) + ' hours, ' 
			+ cast((datediff(ss, max(CREATE_DATE),getdate())%3600)/60 as nvarchar) + ' minutes, and ' 
			+ cast(datediff(ss, max(CREATE_DATE),getdate())%60 as nvarchar) + ' seconds old.' 

		else

			'At ' 
			+ left(convert(nvarchar(30), getdate(), 114), 5) 
			+ 'hrs on ' 
			+ datename(dw, getdate()) 
			+ ', ' 
			+ convert(nvarchar(30), getdate(), 101) 
			+ ', the newest case in the HEDSS Report Database has a CREATE_DATE of ' 
			+ datename(dw, max(CREATE_DATE))
			+ ', ' 
			+ convert(nvarchar(30),max(CREATE_DATE), 101)
			+ ', ' 
			+ left(convert(nvarchar(30),max(CREATE_DATE), 114), 5)  
			+ 'hrs, which is ' 
			+ cast((datediff(ss, max(CREATE_DATE),getdate())/86400)/30 as nvarchar) + ' months, '
			+ cast((datediff(ss, max(CREATE_DATE),getdate())/86400)%30 as nvarchar) + ' days, ' 
			+ cast((datediff(ss, max(CREATE_DATE),getdate())%86400)/3600 as nvarchar) + ' hours, ' 
			+ cast((datediff(ss, max(CREATE_DATE),getdate())%3600)/60 as nvarchar) + ' minutes, and ' 
			+ cast(datediff(ss, max(CREATE_DATE),getdate())%60 as nvarchar) + ' seconds old.'
		end as Message

		,cast((datediff(ss, max(CREATE_DATE),getdate())/86400)/30 as nvarchar) + 'M '
			+ cast((datediff(ss, max(CREATE_DATE),getdate())/86400)%30 as nvarchar) + 'D ' 
			+ cast((datediff(ss, max(CREATE_DATE),getdate())%86400)/3600 as nvarchar) + ':' 
			+ cast((datediff(ss, max(CREATE_DATE),getdate())%3600)/60 as nvarchar) + ':' 
			+ cast(datediff(ss, max(CREATE_DATE),getdate())%60 as nvarchar)
			as AgeOfNewestCase

from IDS_CASE
