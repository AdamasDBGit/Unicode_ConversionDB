CREATE PROCEDURE [ECOMMERCE].[uspGetProductDetails](@BrandID INT,@CenterID INT=NULL, @CategoryID INT=NULL, @IsPublished BIT=1)
AS
BEGIN

IF(@IsPublished=1)
BEGIN

	select * from ECOMMERCE.T_Product_Master TPM
	inner join ECOMMERCE.T_Category_Master TCM on TPM.CategoryID=TCM.ID
	where 
	TPM.StatusID=1 and TPM.IsPublished=1 and (TPM.ValidFrom<=GETDATE() and ISNULL(TPM.ValidTo,GETDATE())>=GETDATE())
	and TPM.BrandID=@BrandID
	and TPM.CategoryID=ISNULL(@CategoryID,TCM.ID)


	select TPCM.*,TCHND.S_Center_Name from ECOMMERCE.T_Product_Center_Map TPCM
	inner join T_Center_Hierarchy_Name_Details TCHND on TCHND.I_Center_ID=TPCM.CenterID
	where
	TPCM.CenterID=ISNULL(@CenterID,TCHND.I_Center_ID) and TPCM.StatusID=1
	and TPCM.IsPublished=1
	and TPCM.ProductID in
	(
		select TPM.ProductID from ECOMMERCE.T_Product_Master TPM
		inner join ECOMMERCE.T_Category_Master TCM on TPM.CategoryID=TCM.ID
		where 
		TPM.StatusID=1 and TPM.IsPublished=1 and (TPM.ValidFrom<=GETDATE() and ISNULL(TPM.ValidTo,GETDATE())>=GETDATE())
		and TPM.BrandID=@BrandID
		and TPM.CategoryID=ISNULL(@CategoryID,TCM.ID)
	)


	select TPFP.*,TCFP.S_Fee_Plan_Name,TCFP.N_TotalLumpSum,TCFP.N_TotalInstallment,TCFP.N_No_Of_Installments 
	from ECOMMERCE.T_Product_FeePlan TPFP
	inner join T_Course_Fee_Plan TCFP on TPFP.CourseFeePlanID=TCFP.I_Course_Fee_Plan_ID
	where
	TPFP.ProductCentreID in
	(
		select TPCM.ProductCentreID from ECOMMERCE.T_Product_Center_Map TPCM
		inner join T_Center_Hierarchy_Name_Details TCHND on TCHND.I_Center_ID=TPCM.CenterID
		where
		TPCM.CenterID=ISNULL(@CenterID,TCHND.I_Center_ID) and TPCM.StatusID=1
		and TPCM.IsPublished=1
		and TPCM.ProductID in
		(
			select TPM.ProductID from ECOMMERCE.T_Product_Master TPM
			inner join ECOMMERCE.T_Category_Master TCM on TPM.CategoryID=TCM.ID
			where 
			TPM.StatusID=1 and TPM.IsPublished=1 and (TPM.ValidFrom<=GETDATE() and ISNULL(TPM.ValidTo,GETDATE())>=GETDATE())
			and TPM.BrandID=@BrandID
			and TPM.CategoryID=ISNULL(@CategoryID,TCM.ID)
		)
	)
	and TPFP.StatusID=1 and TPFP.IsPublished=1 and (TPFP.ValidFrom<=GETDATE() and ISNULL(TPFP.ValidTo,GETDATE())>=GETDATE())

END
ELSE IF(@IsPublished=0)
BEGIN

	select * from ECOMMERCE.T_Product_Master TPM
	inner join ECOMMERCE.T_Category_Master TCM on TPM.CategoryID=TCM.ID
	where 
	TPM.StatusID=1 and ISNULL(TPM.IsPublished,0)=0 and (ISNULL(TPM.ValidTo,GETDATE())>=GETDATE())
	and TPM.BrandID=@BrandID
	and TPM.CategoryID=ISNULL(@CategoryID,TCM.ID)

		select TPCM.*,TCHND.S_Center_Name from ECOMMERCE.T_Product_Center_Map TPCM
	inner join T_Center_Hierarchy_Name_Details TCHND on TCHND.I_Center_ID=TPCM.CenterID
	where
	TPCM.CenterID=ISNULL(@CenterID,TCHND.I_Center_ID) and TPCM.StatusID=1
	and TPCM.IsPublished=1
	and TPCM.ProductID in
	(
		select TPM.ProductID from ECOMMERCE.T_Product_Master TPM
		inner join ECOMMERCE.T_Category_Master TCM on TPM.CategoryID=TCM.ID
		where 
		TPM.StatusID=1 and ISNULL(TPM.IsPublished,0)=0 and (ISNULL(TPM.ValidTo,GETDATE())>=GETDATE())
		and TPM.BrandID=@BrandID
		and TPM.CategoryID=ISNULL(@CategoryID,TCM.ID)
	)


	select TPFP.*,TCFP.S_Fee_Plan_Name,TCFP.N_TotalLumpSum,TCFP.N_TotalInstallment,TCFP.N_No_Of_Installments 
	from ECOMMERCE.T_Product_FeePlan TPFP
	inner join T_Course_Fee_Plan TCFP on TPFP.CourseFeePlanID=TCFP.I_Course_Fee_Plan_ID
	where
	TPFP.ProductCentreID in
	(
		select TPCM.ProductCentreID from ECOMMERCE.T_Product_Center_Map TPCM
		inner join T_Center_Hierarchy_Name_Details TCHND on TCHND.I_Center_ID=TPCM.CenterID
		where
		TPCM.CenterID=ISNULL(@CenterID,TCHND.I_Center_ID) and TPCM.StatusID=1
		and TPCM.IsPublished=1
		and TPCM.ProductID in
		(
			select TPM.ProductID from ECOMMERCE.T_Product_Master TPM
			inner join ECOMMERCE.T_Category_Master TCM on TPM.CategoryID=TCM.ID
			where 
			TPM.StatusID=1 and ISNULL(TPM.IsPublished,0)=0 and (ISNULL(TPM.ValidTo,GETDATE())>=GETDATE())
			and TPM.BrandID=@BrandID
			and TPM.CategoryID=ISNULL(@CategoryID,TCM.ID)
		)
	)
	and TPFP.StatusID=1 and TPFP.IsPublished=1 and (ISNULL(TPFP.ValidTo,GETDATE())>=GETDATE())

END




END
