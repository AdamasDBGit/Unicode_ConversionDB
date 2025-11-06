CREATE PROCEDURE [ECOMMERCE].[uspValidateCouponCodeForPlan_BySomaForTest]
--(
--	@BrandID INT,
--	@CouponCode VARCHAR(MAX),
--	@PlanID INT,
--	@ProductID INT,
--	@CenterID INT,
--	@PaymentMode INT,
--	@PurchaseAmount DECIMAL(14,2)=0,
--	@CustomerID VARCHAR(MAX)=NULL
--)
AS
declare @BrandID INT=109,
	@CouponCode VARCHAR(MAX)='HOLI',
	@PlanID INT=17,
	@ProductID INT=18,
	@CenterID INT=132,
	@PaymentMode INT=1,
	@PurchaseAmount DECIMAL(14,2)=6999,
	@CustomerID VARCHAR(MAX)=NULL

BEGIN

	--RSMRT463

	declare @couponid int=0
	declare @discountschemeid int=0
	declare @feeplanid int=0
	declare @flag bit=0
	declare @totalInstalmentPayable DECIMAL(14,0)=0
	declare @totalInstalmentPayableTax DECIMAL(14,0)=0
	DECLARE @perstudentcouponcount INT=0

	create table #TblFeePlanDtls
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
		I_Display_Fee_Component_ID INT,
		InstalmentDate Datetime,
		ActualInstalmentNo INT
	)

	SELECT @perstudentcouponcount=ISNULL(COUNT(DISTINCT A.TransactionID),0) 
	FROM ECOMMERCE.T_Transaction_Master A
	INNER JOIN ECOMMERCE.T_Transaction_Plan_Details B ON B.TransactionID = A.TransactionID
	INNER JOIN ECOMMERCE.T_Transaction_Product_Details C ON C.TransactionPlanDetailID = B.TransactionPlanDetailID
	WHERE
    A.CustomerID COLLATE DATABASE_DEFAULT=ISNULL(@CustomerID,'') COLLATE DATABASE_DEFAULT
	AND A.StatusID=1 
	AND A.TransactionStatus!='Failure'
	AND C.CouponCode IS NOT NULL 
	AND C.CouponCode COLLATE DATABASE_DEFAULT=@CouponCode COLLATE DATABASE_DEFAULT



	IF(@CustomerID IS NOT NULL)
	BEGIN

		PRINT 'Customer'

		select TOP 1 @couponid=TCM.CouponID,@discountschemeid=TDSM.I_Discount_Scheme_ID 
		FROM ECOMMERCE.T_Coupon_Master TCM
		inner join T_Discount_Scheme_Master TDSM on TCM.DiscountSchemeID=TDSM.I_Discount_Scheme_ID
		inner join T_Discount_Scheme_Details TDSD on TDSD.I_Discount_Scheme_ID=TCM.DiscountSchemeID
		inner join T_Discount_Center_Detail TDCD on TDCD.I_Discount_Scheme_ID=TCM.DiscountSchemeID and TDCD.I_Status=1
		inner join T_Discount_Course_Detail TDCD2 on TDCD.I_Discount_Center_Detail_ID=TDCD2.I_Discount_Centre_Detail_ID and TDCD2.I_Status=1
		inner join ECOMMERCE.T_Product_Master TPM on  TPM.CourseID=TDCD2.I_Course_ID
		inner join ECOMMERCE.T_Product_Center_Map TPCM2 on TPM.ProductID=TPCM2.ProductID and TPCM2.StatusID=1 and TPCM2.CenterID=@CenterID
		inner join ECOMMERCE.T_Plan_Coupon_Map TPCM on TPCM.CouponID=TCM.CouponID and TPCM.StatusID=1
		inner join ECOMMERCE.T_Plan_Product_Map TPPM on TPPM.PlanID=TPCM.PlanID and TPPM.ProductID=TPM.ProductID and TPPM.StatusID=1
		inner join ECOMMERCE.T_Registration TR on TR.CustomerID=TCM.CustomerID
		inner join ECOMMERCE.T_Coupon_Brand_Map TCBM on TCBM.CouponID=TCM.CouponID
		inner join ECOMMERCE.T_Plan_Brand_Map TPBM on TPCM.PlanID=TPBM.PlanID and TPBM.StatusID=1
		where
		TCM.StatusID=1 and TDSM.I_Status=1
		and CONVERT(DATE,TCM.ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,TCM.ValidTo)>=CONVERT(DATE,GETDATE())
		and CONVERT(DATE,TDSM.Dt_Valid_From)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,TDSM.Dt_Valid_To)>=CONVERT(DATE,GETDATE())
		and TCBM.BrandID=@BrandID
		and TPBM.BrandID=@BrandID
		and TCM.CouponCategoryID=3
		and TCM.CouponCount>TCM.AssignedCount
		and TDSD.I_IsApplicableOn=@PaymentMode
		and TPM.ProductID=@ProductID
		and TPCM.PlanID=@PlanID
		and TDCD.I_Centre_ID=@CenterID
		and TCM.CouponCode=@CouponCode
		and TCM.CustomerID=@CustomerID

		PRINT @couponid

	END

	IF(@PurchaseAmount IS NOT NULL and @PurchaseAmount>0 and @couponid<=0)
	BEGIN

		PRINT 'Purchase'

		select TOP 1 @couponid=TCM.CouponID,@discountschemeid=TDSM.I_Discount_Scheme_ID 
		FROM ECOMMERCE.T_Coupon_Master TCM
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
		and TCM.CouponCategoryID=2
		and TCM.CouponCount>TCM.AssignedCount
		and TDSD.I_IsApplicableOn=@PaymentMode
		and TPM.ProductID=@ProductID
		and TPCM.PlanID=@PlanID
		and TDCD.I_Centre_ID=@CenterID
		and TCM.CouponCode=@CouponCode
		and TCM.GreaterThanAmount<@PurchaseAmount
		AND ISNULL(TCM.PerStudentCount,1)>@perstudentcouponcount

		PRINT @couponid

	END

	IF(@couponid<=0)
	BEGIN

	PRINT 'Plan'

	select TOP 1 @couponid=TCM.CouponID,@discountschemeid=TDSM.I_Discount_Scheme_ID from ECOMMERCE.T_Coupon_Master TCM
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
	and TCM.CouponCategoryID=1
	and TCM.CouponCount>TCM.AssignedCount
	and TDSD.I_IsApplicableOn=@PaymentMode
	and TPM.ProductID=@ProductID
	and TPCM.PlanID=@PlanID
	and TDCD.I_Centre_ID=@CenterID
	and TCM.CouponCode=@CouponCode
	AND ISNULL(TCM.PerStudentCount,1)>@perstudentcouponcount

	PRINT @couponid

	END


	select @feeplanid=B.CourseFeePlanID from ECOMMERCE.T_Product_Center_Map A
	inner join ECOMMERCE.T_Product_FeePlan B on A.ProductCentreID=B.ProductCentreID
	inner join ECOMMERCE.T_Plan_Product_Map C on A.ProductID=C.ProductID
	where
	A.CenterID=@CenterID and A.ProductID=@ProductID and C.PlanID=@PlanID
	and C.StatusID=1

	print @feeplanid


	insert into #TblFeePlanDtls
	exec ECOMMERCE.uspGetFeePlanDiscountDetails @feeplanid,@PaymentMode,@discountschemeid,NULL


	
	

	

	if(@couponid>0)
		set @flag=1


	select @totalInstalmentPayable=SUM(ISNULL(P.PayableAmount,0)),@totalInstalmentPayableTax=SUM(ISNULL(P.PayableTax,0)) 
		from
		(
			select ISNULL(T1.Amount,0) as PayableAmount,((ISNULL(T1.Amount,0)*T2.TaxRate)/100) as PayableTax
			from
			(
				select A.I_Course_Fee_Plan_ID,A.I_Fee_Component_ID,SUM(A.I_Item_Value-A.N_Discount) as Amount 
				from #TblFeePlanDtls A
				where A.I_Installment_No>0
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




	IF(@PaymentMode=1)
	BEGIN
		
		select SUM(P.PayableAmount) as PayableAmount,SUM(P.PayableTax) as PayableTax, @flag as IsCouponApplicable,0 as TotalInstalmentPayable,0 as TotalInstalmentPayableTax
		from
		(
			select T1.Amount as PayableAmount,((T1.Amount*T2.TaxRate)/100) as PayableTax
			from
			(
				select A.I_Course_Fee_Plan_ID,A.I_Fee_Component_ID,SUM(A.I_Item_Value-A.N_Discount) as Amount 
				from #TblFeePlanDtls A
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

		select @MinInstNo=MIN(I_Installment_No) from #TblFeePlanDtls where I_Installment_No>0

		select SUM(P.PayableAmount) as PayableAmount,SUM(P.PayableTax) as PayableTax, @flag as IsCouponApplicable,@totalInstalmentPayable as TotalInstalmentPayable,@totalInstalmentPayableTax as TotalInstalmentPayableTax 
		from
		(
			select T1.Amount as PayableAmount,((T1.Amount*T2.TaxRate)/100) as PayableTax
			from
			(
				select A.I_Course_Fee_Plan_ID,A.I_Fee_Component_ID,SUM(A.I_Item_Value-A.N_Discount) as Amount 
				from #TblFeePlanDtls A
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


END
