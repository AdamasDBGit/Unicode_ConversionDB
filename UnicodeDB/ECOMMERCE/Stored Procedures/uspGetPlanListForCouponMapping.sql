CREATE PROCEDURE [ECOMMERCE].[uspGetPlanListForCouponMapping](@sBrandID VARCHAR(MAX), @ExamCategoryIDs VARCHAR(MAX)=NULL, @CategoryID INT=NULL, @CouponID INT=0)
AS
BEGIN

IF(@CategoryID=0)
	SET @CategoryID=NULL


create table #Plans
(
	PlanID INT
)



	IF(@CouponID>0)
	BEGIN

		insert into #Plans
		select DISTINCT A.PlanID 
		from ECOMMERCE.T_Plan_Product_Map A
		inner join ECOMMERCE.T_Product_Master C on A.ProductID=C.ProductID and C.IsPublished=1
		inner join
		(
			select DISTINCT T2.PlanID from
			(
				select DISTINCT A.CouponID,CAST(C.I_Centre_ID AS VARCHAR(MAX))+'#'+CAST(D.I_Course_ID AS VARCHAR(MAX)) as CenterCourse
				from ECOMMERCE.T_Coupon_Master A
				inner join T_Discount_Scheme_Master B on A.DiscountSchemeID=B.I_Discount_Scheme_ID 
											--and (CONVERT(DATE,B.Dt_Valid_From)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,B.Dt_Valid_To)>=CONVERT(DATE,GETDATE()))
				inner join T_Discount_Center_Detail C on B.I_Discount_Scheme_ID=C.I_Discount_Scheme_ID and C.I_Status=1
				inner join T_Discount_Course_Detail D on C.I_Discount_Center_Detail_ID=D.I_Discount_Centre_Detail_ID and D.I_Status=1
				where A.CouponID=@CouponID and A.StatusID=1
			) T1
			inner join
			(
				select DISTINCT A.PlanID,CAST(B.CenterID AS VARCHAR(MAX))+'#'+CAST(C.CourseID AS VARCHAR(MAX)) as CenterCourse 
				from ECOMMERCE.T_Plan_Product_Map A
				inner join ECOMMERCE.T_Product_Center_Map B on A.ProductID=B.ProductID
				inner join ECOMMERCE.T_Product_Master C on A.ProductID=C.ProductID and C.StatusID=1 and C.IsPublished=1
				where
				A.StatusID=1 and B.StatusID=1
			) T2 on T1.CenterCourse=T2.CenterCourse
		) CP on A.PlanID=CP.PlanID
		where
		A.StatusID=1

	END

	--select * from #Plans

select DISTINCT A.* from ECOMMERCE.T_Plan_Master A
inner join ECOMMERCE.T_Plan_Brand_Map B on A.PlanID=B.PlanID and B.StatusID=1
where 
A.StatusID=1 and A.IsPublished=0 and B.BrandID in (select CAST(Val as INT) from fnString2Rows(@sBrandID,','))
and A.PlanID in
(
	select PlanID from #Plans
) order by A.SequenceNo -- added by susmita 2022-09-28


select TPC.PlanConfigID,TPC.PlanID,TPC.ConfigID,TCPM.ConfigCode,ISNULL(TPC.ConfigDisplayName,TCPM.ConfigName) as DisplayName,
ISNULL(TPC.ConfigValue,TCPM.ConfigDefaultValue) as ConfigValue
from ECOMMERCE.T_Plan_Config TPC
inner join ECOMMERCE.T_Cofiguration_Property_Master TCPM on TPC.ConfigID=TCPM.ConfigID
inner join ECOMMERCE.T_Plan_Master TPM on TPC.PlanID=TPM.PlanID
where TPC.StatusID=1 and TPM.PlanID in
(
	select DISTINCT A.PlanID from ECOMMERCE.T_Plan_Master A
	inner join ECOMMERCE.T_Plan_Brand_Map B on A.PlanID=B.PlanID and B.StatusID=1
	where 
	A.StatusID=1 and A.IsPublished=0 and B.BrandID in (select CAST(Val as INT) from fnString2Rows(@sBrandID,',')) 
	and A.PlanID in
	(
		select PlanID from #Plans
	)

)


select B.PlanID,A.I_Brand_ID,A.S_Brand_Name from T_Brand_Master A
inner join
(
	select A.PlanID,B.BrandID from ECOMMERCE.T_Plan_Master A
	inner join ECOMMERCE.T_Plan_Brand_Map B on A.PlanID=B.PlanID and B.StatusID=1
	where 
	A.StatusID=1 and A.IsPublished=0 and B.BrandID in (select CAST(Val as INT) from fnString2Rows(@sBrandID,','))
	and A.PlanID in
	(
		select PlanID from #Plans
	)
) B on B.BrandID=A.I_Brand_ID


END
