--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Reference Code and Product Cross Match wsm 10/24/2019                                 
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Purpose: 
--@@@  This query cross references a PRODUCT code across all three reference code sections
--@@@  in Maven (HL7_EVENT_LOOKUP, LOINC, and SNOMED) and checks to see if the filters and 
--@@@  descriptions contain the required values to make the reference code set actually pick up the 
--@@@  correct PRODUCT
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@ Instructions: 1. replace the product code in the @ProductCode variable with the code you want
--@@@				2. execute query within a SQL Server client like SSMS
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

declare @ProductCode nvarchar(20) = 'sal'   --<< insert product codes

declare @ProductPlus nvarchar(20) = '%' + @ProductCode + '%'

select 
	@ProductCode as ProductCode
	,rc7.[REFERENCE_CODE]																as [HL7 Ref Code]
	,left(rc7.[REFERENCE_CODE], charindex('_',rc7.[REFERENCE_CODE])-1) 					as [HL7 Loinc]
	,rtrim(substring(rc7.[REFERENCE_CODE], charindex('_',rc7.[REFERENCE_CODE])+1,10))	as [HL7 Snomed]
	,rc7.[DESCRIPTION]																	as [HL7 Descr]
	,rcl.[REFERENCE_CODE]																as [Loinc Ref Code]
	,rcl.[FILTER]																		as [Loinc Filter]
	,rcl.[DESCRIPTION]																	as [Loinc Descr]
	,rcs.[REFERENCE_CODE]																as [Snomed Ref Code]
	,rcs.[DESCRIPTION]																	as [Snomed Descr]
	,rcs.[FILTER]																		as [Snomed Filter]	  

	,case when rcl.[FILTER] like @ProductPlus then 'Yes' else 'No'	end					as [Prod In Loinc Filter]
	
	,case when rcs.FILTER	like 	@ProductPlus 
			then 'Yes' else 'No'	end													as [Prod in Snomed Filter]	  
	
	,case when rcs.FILTER	like '%' + rcl.[REFERENCE_CODE]	 + '%' 
			then 'Yes' else 'No'	end													as [Loinc in Snomed Filter]	  
	
	,case when rcs.FILTER	like 	@ProductPlus 
			and rcs.FILTER	like '%' + rcl.[REFERENCE_CODE]	 + '%' 
			then 'Yes' else 'No'	end													as [Prod And Loinc in Snomed Filter]	 

	,case when rc7.[DESCRIPTION] like '%$$SkipNoMatch$$%'
			then 'Yes' else 'No'	end													as [Msg Can Bounce]	

  from [dbo].[IDS_REFERENCE_CODE]  rc7
		left join	
					(
					select *
					from [dbo].[IDS_REFERENCE_CODE]
					where [REFERENCE_GROUP] = 'LOINC' and [SUBGROUP] = 'LOINC_LABTEST'
					) 
					rcl on left(rc7.[REFERENCE_CODE], charindex('_',rc7.[REFERENCE_CODE])-1) = rcl.REFERENCE_CODE

		left join	
					(
					select *
					from [dbo].[IDS_REFERENCE_CODE]
					where [REFERENCE_GROUP] = 'SNOMED' and [SUBGROUP] = 'SNOMED_LABTEST'
					) 
					rcs on rtrim(substring(rc7.[REFERENCE_CODE], charindex('_',rc7.[REFERENCE_CODE])+1,10)) = rcs.REFERENCE_CODE

  where 1=1
		and rc7.[REFERENCE_GROUP] like '%7%' 
		and rc7.[DESCRIPTION] like @ProductPlus

  order by rc7.[REFERENCE_CODE]
