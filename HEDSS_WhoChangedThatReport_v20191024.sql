--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Who Changed That Report? by wsm 10/24/2019                                                        
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Purpose: Display useful details about Maven reports
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Instructions: 1. execute from a SQL Server client like SSMS or within a Maven tabular report
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


SELECT r.UNID							as Report_UNID 
    ,r.CATEGORY							as Category
	,r.NAME								as ReportName
	,rs.DISPLAY_NAME					as Status
	,rt.DISPLAY_NAME					as Type
    ,r.DATA_SOURCE						as DataSource
    ,r.QUERY							as Query
    ,r.CREATE_DATE						as CreatedDate
	,uc.LOGIN_NAME						as CreatedByLogin
	,pc.FULL_NAME						as CreatedByName
    ,r.MODIFICATION_DATE				as ModifiedDate
	,um.LOGIN_NAME						as ModifiedByLogin
	,pm.FULL_NAME						as ModifiedByName

  FROM IDS_REPORT r
	  join IDS_USER uc on r.CREATED_BY_ID =  uc.UNID
	  join IDS_PARTY pc on uc.PARTY_ID =  pc.UNID
	  join IDS_USER um on r.MODIFIED_BY_ID =  um.UNID
	  join IDS_PARTY pm on um.PARTY_ID =  pm.UNID
	  join  (	
					select VALUE, DISPLAY_NAME
					from IDS_ENUM_ENTRY
					where ENUM_NAME = 'Report.Status'
				  ) 
				  rs on r.STATUS = rs.VALUE
	  join  (	
					select VALUE, DISPLAY_NAME
					from IDS_ENUM_ENTRY
					where ENUM_NAME = 'Report.Type'
				  ) 
				  rt on r.STATUS = rt.VALUE

  ORDER BY CATEGORY, NAME	