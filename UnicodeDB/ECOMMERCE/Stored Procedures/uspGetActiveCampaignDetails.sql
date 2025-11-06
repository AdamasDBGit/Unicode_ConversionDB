
/*******************************************************
Description : Get E-Project Query List
Author	:     Soma Pal
Date	:	  08-NOV-2022
*********************************************************/

CREATE PROCEDURE [ECOMMERCE].[uspGetActiveCampaignDetails] 

AS

--------Part 1
select CampaignBrandMap.ID		CampaignBrand_ID
,CampaignBrandMap.CampaignID	CampaignBrand_CampaignID
,CampaignBrandMap.BrandID		CampaignBrand_BrandID
,CampaignBrandMap.StatusID		CampaignBrand_StatusID

,CampaignMaster.CampaignID		CampaignMaster_CampaignID
,CampaignMaster.CampaignName	CampaignMaster_CampaignName
,CampaignMaster.CampaignDesc	CampaignMaster_CampaignDesc
,CampaignMaster.StatusID		CampaignMaster_StatusID
,CampaignMaster.ValidFrom		CampaignMaster_ValidFrom
,CampaignMaster.ValidTo			CampaignMaster_ValidTo
,CampaignMaster.CreatedOn		CampaignMaster_CreatedOn
,CampaignMaster.CreatedBy		CampaignMaster_CreatedBy
,CampaignMaster.UpdatedOn		CampaignMaster_UpdatedOn
,CampaignMaster.UpdatedBy		CampaignMaster_UpdatedBy


from ECOMMERCE.T_Campaign_Brand_Map CampaignBrandMap
inner join ECOMMERCE.T_Campaign_Master CampaignMaster on CampaignBrandMap.CampaignID=CampaignMaster.CampaignID

where cast(CampaignMaster.ValidTo as date)>=cast(getdate() as date)
and CampaignBrandMap.StatusID=1
and CampaignMaster.StatusID=1

--------Part 2

	select CampaignBrandMap.CampaignID	CampaignBrand_CampaignID
,CampaignDiscountMap.ID						CampaignDiscount_ID
,CampaignDiscountMap.CampaignID				CampaignID
,CampaignDiscountMap.FromMarks				CampaignDiscount_FromMarks
,CampaignDiscountMap.ToMarks				CampaignDiscount_ToMarks
,CampaignDiscountMap.DiscountID				CampaignDiscount_DiscountID
,CampaignDiscountMap.ValidFrom				CampaignDiscount_ValidFrom
,CampaignDiscountMap.ValidTo				CampaignDiscount_ValidTo
,ISNULL(CampaignDiscountMap.StatusID,0)				CampaignDiscount_StatusID
,CampaignDiscountMap.CreatedOn				CampaignDiscount_CreatedOn
,CampaignDiscountMap.CreatedBy				CampaignDiscount_CreatedBy
,CampaignDiscountMap.UpdatedOn				CampaignDiscount_UpdatedOn
,CampaignDiscountMap.UpdatedBy				CampaignDiscount_UpdatedBy
,CampaignDiscountMap.CouponName				CampaignDiscount_CouponName
,CampaignDiscountMap.CouponPrefix			CampaignDiscount_CouponPrefix
,CampaignDiscountMap.CouponTypeID			CampaignDiscount_CouponTypeID
,CampaignDiscountMap.CouponCount			CampaignDiscount_CouponCount
,CampaignDiscountMap.GenerationCount		CampaignDiscount_GenerationCount
,CampaignDiscountMap.MessageDesc			CampaignDiscount_MessageDesc
,CampaignDiscountMap.SMSTypeID				CampaignDiscount_SMSTypeID

,ISNULL(DiscountSchemeMaster.I_Discount_Scheme_ID,0)		DiscountScheme_I_Discount_Scheme_ID
,ISNULL(DiscountSchemeMaster.S_Discount_Scheme_Name,'')	DiscountScheme_S_Discount_Scheme_Name
,DiscountSchemeMaster.Dt_Valid_From				DiscountScheme_Dt_Valid_From
,DiscountSchemeMaster.Dt_Valid_To				DiscountScheme_Dt_Valid_To
,ISNULL(DiscountSchemeMaster.I_Status,0)					DiscountScheme_I_Status
,DiscountSchemeMaster.S_Crtd_By					DiscountScheme_S_Crtd_By
,DiscountSchemeMaster.S_Upd_By					DiscountScheme_S_Upd_By
,DiscountSchemeMaster.Dt_Crtd_On				DiscountScheme_Dt_Crtd_On
,DiscountSchemeMaster.Dt_Upd_On					DiscountScheme_Dt_Upd_On


from ECOMMERCE.T_Campaign_Brand_Map CampaignBrandMap
inner join ECOMMERCE.T_Campaign_Master CampaignMaster on CampaignBrandMap.CampaignID=CampaignMaster.CampaignID
inner join ECOMMERCE.T_Campaign_Discount_Map CampaignDiscountMap on CampaignBrandMap.CampaignID=CampaignDiscountMap.CampaignID
left join dbo.T_Discount_Scheme_Master DiscountSchemeMaster on CampaignDiscountMap.DiscountID=DiscountSchemeMaster.I_Discount_Scheme_ID


where cast(CampaignMaster.ValidTo as date)>=cast(getdate() as date)
and cast(CampaignDiscountMap.ValidTo as date)>=cast(getdate() as date)
and cast(DiscountSchemeMaster.Dt_Valid_To as date)>=cast(getdate() as date) or DiscountSchemeMaster.Dt_Valid_To is null
and CampaignBrandMap.StatusID=1
and CampaignMaster.StatusID=1
and CampaignDiscountMap.StatusID=1
and DiscountSchemeMaster.I_Status=1 or DiscountSchemeMaster.I_Status is null
