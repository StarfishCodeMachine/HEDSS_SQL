  
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Products by wsm 10/24/2019                                  
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Purpose: View Maven products with some added details
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Instructions: 1. execute from a SQL Server client like SSMS or within a Maven tabular report
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

select p.UNID					as Product_UNID
		,p.CODE
		,p.NAME					as ProductName
		,p.DESCRIPTION			as ProductDescription
		,ps.DISPLAY_NAME		as ProductStatus
		,p.TIME_FRAME
		,p.GRACE_PERIOD
		,p.NOTES				as ProductNotes
		,p.PREFERRED_MODEL		as Model
		,m.NAME					as CaseDataMapping

from IDS_PRODUCT p 
	join IDS_CASE_DATA_MAP m on p.CASE_DATA_MAP_ID = m.UNID
  	join	(	
			select VALUE, DISPLAY_NAME
			from IDS_ENUM_ENTRY
			where ENUM_NAME = 'Product.Status'
			) 
			ps on p.STATUS = ps.VALUE
order by p.NAME