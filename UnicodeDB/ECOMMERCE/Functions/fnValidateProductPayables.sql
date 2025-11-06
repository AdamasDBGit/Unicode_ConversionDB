-- =============================================
-- Author:		Shankha Roy
-- Create date: '08/17/2007'
-- Description:	This Function return a table 
-- constains Exam Module name List
-- Return: Table
-- =============================================
CREATE FUNCTION [ECOMMERCE].[fnValidateProductPayables]
(
	@BrandID INT,
	@CouponCode VARCHAR(MAX),
	@PlanID INT,
	@ProductID INT,
	@CenterID INT,
	@PaymentMode INT
)
RETURNS  @rtnTable TABLE
(
	PayableAmount DECIMAL(14,2),
	PayableTax DECIMAL(14,2),
	IsCouponApplicable BIT
)

AS 
-- Return the Table containing the student course details.
BEGIN
	declare @couponid int=0
	declare @discountschemeid int=0
	declare @feeplanid int=0
	declare @flag bit=0

	DECLARE @TblFeePlanDtls TABLE
	(
		ID INT,
		I_Course_Fee_Plan_Detail_ID INT ,
		I_Fee_Component_ID INT,
		I_Course_Fee_Plan_ID INT,
		I_Item_Value Decimal(14,2),
		N_Discount decimal(14,2),
		I_Installment_No INT,
		I_Sequence INT,
		C_Is_LumpSum varchar(1),
		I_Display_Fee_Component_ID INT
	)

	select TOP 1 @couponid=TCM.CouponID,@discountschemeid=TDSM.I_Discount_Scheme_ID 
	from ECOMMERCE.T_Coupon_Master TCM
	inner join T_Discount_Scheme_Master TDSM on TCM.DiscountSchemeID=TDSM.I_Discount_Scheme_ID
	inner join T_Discount_Scheme_Details TDSD on TDSD.I_Discount_Scheme_ID=TCM.DiscountSchemeID
	inner join T_Discount_Center_Detail TDCD on TDCD.I_Discount_Scheme_ID=TCM.DiscountSchemeID and TDCD.I_Status=1
	inner join T_Discount_Course_Detail TDCD2 on TDCD.I_Discount_Center_Detail_ID=TDCD2.I_Discount_Centre_Detail_ID and TDCD2.I_Status=1
	inner join ECOMMERCE.T_Product_Master TPM on  TPM.CourseID=TDCD2.I_Course_ID
	inner join ECOMMERCE.T_Product_Center_Map TPCM2 on TPM.ProductID=TPCM2.ProductID and TPCM2.StatusID=1 and TPCM2.CenterID=@CenterID
	inner join ECOMMERCE.T_Plan_Coupon_Map TPCM on TPCM.CouponID=TCM.CouponID and TPCM.StatusID=1
	inner join ECOMMERCE.T_Plan_Product_Map TPPM on TPPM.PlanID=TPCM.PlanID and TPPM.ProductID=TPM.ProductID and TPPM.StatusID=1
	inner join ECOMMERCE.T_Coupon_Brand_Map TCBM on TCBM.CouponID=TCM.CouponID
	inner join ECOMMERCE.T_Plan_Brand_Map TPBM on TPCM.PlanID=TPBM.PlanID and TPBM.StatusID=1
	where
	TCM.StatusID=1 and TDSM.I_Status=1
	and CONVERT(DATE,TCM.ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,TCM.ValidTo)>=CONVERT(DATE,GETDATE())
	and CONVERT(DATE,TDSM.Dt_Valid_From)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,TDSM.Dt_Valid_To)>=CONVERT(DATE,GETDATE())
	and TCBM.BrandID=@BrandID
	and TPBM.BrandID=@BrandID
	and TCM.CouponCategoryID IN (1,2,3)
	and TCM.CouponCount>TCM.AssignedCount
	and TDSD.I_IsApplicableOn=@PaymentMode
	and TPM.ProductID=@ProductID
	and TPCM.PlanID=@PlanID
	and TDCD.I_Centre_ID=@CenterID
	and TCM.CouponCode=@CouponCode


	select @feeplanid=B.CourseFeePlanID from ECOMMERCE.T_Product_Center_Map A
	inner join ECOMMERCE.T_Product_FeePlan B on A.ProductCentreID=B.ProductCentreID
	inner join ECOMMERCE.T_Plan_Product_Map C on A.ProductID=C.ProductID
	where
	A.CenterID=@CenterID and A.ProductID=@ProductID and C.PlanID=@PlanID
	and C.StatusID=1

	--print @feeplanid


	insert into @TblFeePlanDtls
	select * from [ECOMMERCE].[fnGetFeePlanDiscountDetails] (@feeplanid,@PaymentMode,@discountschemeid)


	
	

	

	if(@couponid>0)
		set @flag=1




	IF(@PaymentMode=1)
	BEGIN
		
		insert into @rtnTable
		select SUM(P.PayableAmount) as PayableAmount,SUM(P.PayableTax) as PayableTax, @flag as IsCouponApplicable from
		(
			select T1.Amount as PayableAmount,((T1.Amount*T2.TaxRate)/100) as PayableTax
			from
			(
				select A.I_Course_Fee_Plan_ID,A.I_Fee_Component_ID,SUM(A.I_Item_Value-A.N_Discount) as Amount 
				from @TblFeePlanDtls A
				where A.I_Installment_No=0
				group by A.I_Course_Fee_Plan_ID,A.I_Fee_Component_ID
			) T1
			left join
			(
				select A.I_Fee_Component_ID,SUM(ISNULL(A.N_Tax_Rate,0)) as TaxRate 
				from T_Tax_Country_Fee_Component A 
				where A.Dt_Valid_To>=GETDATE()
				group by A.I_Fee_Component_ID
			) T2 on T1.I_Fee_Component_ID=T2.I_Fee_Component_ID
		) P

	END
	ELSE IF(@PaymentMode=2)
	BEGIN

		DECLARE @MinInstNo INT

		select @MinInstNo=MIN(I_Installment_No) from @TblFeePlanDtls where I_Installment_No>0

		insert into @rtnTable
		select SUM(P.PayableAmount) as PayableAmount,SUM(P.PayableTax) as PayableTax, @flag as IsCouponApplicable 
		from
		(
			select T1.Amount as PayableAmount,((T1.Amount*T2.TaxRate)/100) as PayableTax
			from
			(
				select A.I_Course_Fee_Plan_ID,A.I_Fee_Component_ID,SUM(A.I_Item_Value-A.N_Discount) as Amount 
				from @TblFeePlanDtls A
				where A.I_Installment_No=@MinInstNo
				group by A.I_Course_Fee_Plan_ID,A.I_Fee_Component_ID
			) T1
			left join
			(
				select A.I_Fee_Component_ID,SUM(ISNULL(A.N_Tax_Rate,0)) as TaxRate 
				from T_Tax_Country_Fee_Component A 
				where A.Dt_Valid_To>=GETDATE()
				group by A.I_Fee_Component_ID
			) T2 on T1.I_Fee_Component_ID=T2.I_Fee_Component_ID
		) P

	END

	RETURN;

END