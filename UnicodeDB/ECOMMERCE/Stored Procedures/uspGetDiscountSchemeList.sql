CREATE PROCEDURE [ECOMMERCE].[uspGetDiscountSchemeList](@sBrand VARCHAR(MAX))
AS
BEGIN

select DISTINCT TDSM.* from T_Discount_Scheme_Master TDSM where TDSM.I_Discount_Scheme_ID in
(
	select A.I_Discount_Scheme_ID from T_Discount_Scheme_Master A
	inner join T_Discount_Brand_Map B on A.I_Discount_Scheme_ID=B.I_Discount_Scheme_ID and B.I_Status_ID=1
	left join 
	(
		select CAST(Val as INT) as BrandID from fnString2Rows(@sBrand,',')
	) FSR on B.I_Brand_ID=FSR.BrandID
	where ISNULL(A.Dt_Valid_From,CONVERT(DATE,GETDATE()))<=CONVERT(DATE,GETDATE()) and ISNULL(A.Dt_Valid_To,CONVERT(DATE,GETDATE()))>=CONVERT(DATE,GETDATE()) and A.I_Status=1
	group by A.I_Discount_Scheme_ID
	having COUNT(FSR.BrandID)=(select COUNT(*) as BrandID from fnString2Rows(@sBrand,','))
)

END
