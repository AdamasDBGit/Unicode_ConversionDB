CREATE PROCEDURE [ECOMMERCE].[uspGetProductDetailsForPublishing](@BrandID INT,@CenterID INT=NULL, @CategoryID INT=NULL)
AS
BEGIN

	select DISTINCT TPM.* from ECOMMERCE.T_Product_Master TPM
	inner join ECOMMERCE.T_Category_Master TCM on TPM.CategoryID=TCM.ID
	inner join ECOMMERCE.T_Product_Center_Map TPCM on TPM.ProductID=TPCM.ProductID
	inner join ECOMMERCE.T_Product_FeePlan TPFP on TPCM.ProductCentreID=TPFP.ProductCentreID
	inner join ECOMMERCE.T_Product_ExamCategory_Map TPECM on TPM.ProductID=TPECM.ProductID
	inner join ECOMMERCE.T_Product_Config TPC on TPC.ProductID=TPM.ProductID
	where 
	TPM.StatusID=1 and TPM.IsPublished in (1,0) and (ISNULL(TPM.ValidTo,GETDATE())>=GETDATE())
	and TPM.BrandID=@BrandID
	and TPM.CategoryID=ISNULL(@CategoryID,TCM.ID)
	and TPCM.StatusID=1
	and TPCM.IsPublished=1
	and TPFP.StatusID=1 and TPFP.IsPublished=1 and (ISNULL(TPFP.ValidTo,GETDATE())>=GETDATE())
	and TPECM.StatusID=1
	and TPC.StatusID=1


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
		TPM.StatusID=1 and TPM.IsPublished=1 and (ISNULL(TPM.ValidTo,GETDATE())>=GETDATE())
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
			TPM.StatusID=1 and TPM.IsPublished=1 and (ISNULL(TPM.ValidTo,GETDATE())>=GETDATE())
			and TPM.BrandID=@BrandID
			and TPM.CategoryID=ISNULL(@CategoryID,TCM.ID)
		)
	)
	and TPFP.StatusID=1 and TPFP.IsPublished=1 and (ISNULL(TPFP.ValidTo,GETDATE())>=GETDATE())




END
