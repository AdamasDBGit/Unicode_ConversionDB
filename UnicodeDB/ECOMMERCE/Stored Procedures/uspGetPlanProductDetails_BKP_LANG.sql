CREATE PROCEDURE [ECOMMERCE].[uspGetPlanProductDetails_BKP_LANG](@PlanID INT)
as
begin

--Table 0
	select A.*,B.PlanName 
	from ECOMMERCE.T_Plan_Product_Map A
	inner join ECOMMERCE.T_Plan_Master B on A.PlanID=B.PlanID
	inner join ECOMMERCE.T_Product_Master C on A.ProductID=C.ProductID
	inner join ECOMMERCE.T_Category_Master D on C.CategoryID=D.ID
	where 
	A.PlanID=@PlanID and A.StatusID=1 and B.IsPublished=1 and C.IsPublished=1
	and (B.ValidFrom<=GETDATE() and ISNULL(B.ValidTo,GETDATE())>=GETDATE())
	order by (CASE WHEN D.CategoryCode!='Pro' THEN 0 ELSE 1 END),D.CategoryCode

--Table 1
	select TPPM.PlanID, TPPM.PlanProductID,TPM.*,TCM.ID as CategoryID,TCM.CategoryCode,TCM.CategoryName,TCM.CategoryDesc,TCM.IsOnline,TCM.IsOffline 
	from ECOMMERCE.T_Product_Master TPM
	inner join ECOMMERCE.T_Category_Master TCM on TPM.CategoryID=TCM.ID
	inner join ECOMMERCE.T_Plan_Product_Map TPPM on TPM.ProductID=TPPM.ProductID and TPPM.StatusID=1
	where 
	TPM.StatusID=1 and TPM.IsPublished=1 --and (TPM.ValidFrom<=GETDATE() and ISNULL(TPM.ValidTo,GETDATE())>=GETDATE())
	and TPPM.PlanID=@PlanID
	order by (CASE WHEN TCM.CategoryCode!='Pro' THEN 0 ELSE 1 END),TCM.CategoryCode

--Table 2
	select TPCM.*,TCHND.S_Center_Name,TCC.S_Config_Value as ProspectusAmount 
	from ECOMMERCE.T_Product_Center_Map TPCM
	inner join T_Center_Hierarchy_Name_Details TCHND on TCHND.I_Center_ID=TPCM.CenterID
	inner join
	(
		select  DISTINCT ProductCentreID from ECOMMERCE.T_Product_FeePlan 
		where 
		StatusID=1 and IsPublished=1 and (ValidFrom<=CONVERT(DATE,GETDATE()) and ISNULL(ValidTo,CONVERT(DATE,GETDATE()))>=CONVERT(DATE,GETDATE()))
	) TPFP on TPCM.ProductCentreID=TPFP.ProductCentreID
	left join T_Center_Configuration TCC on TCC.I_Center_Id=TCHND.I_Center_ID and TCC.I_Status=1 and TCC.S_Config_Code='PROSPECTUS_FEES'
	where
	TPCM.StatusID=1
	and TPCM.IsPublished=1
	--and TPCM.CenterID!=132
	and TPCM.ProductID in
	(
		select TPM.ProductID from ECOMMERCE.T_Product_Master TPM
		inner join ECOMMERCE.T_Category_Master TCM on TPM.CategoryID=TCM.ID
		inner join ECOMMERCE.T_Plan_Product_Map TPPM on TPM.ProductID=TPPM.ProductID and TPPM.StatusID=1
		where 
		TPM.StatusID=1 and TPM.IsPublished=1 --and (TPM.ValidFrom<=GETDATE() and ISNULL(TPM.ValidTo,GETDATE())>=GETDATE())
		and TPPM.PlanID=@PlanID
	)
	order by (CASE WHEN TCHND.S_Center_Name!='Pro' THEN 0 ELSE 1 END),TCHND.S_Center_Name

--Table 3
	select TPFP.*,TCFP.S_Fee_Plan_Name,ISNULL(TCFP.N_TotalLumpSum,0) as N_TotalLumpSum,TCFP.N_TotalInstallment,ISNULL(FPD.N_No_Of_Installments,0) as N_No_Of_Installments,
	FD.FirstInstAmount,
	ISNULL(dbo.fnCalculateTaxAmountForFeeStructure(TCFP.I_Course_Fee_Plan_ID,'L'),0) as LumpsumTax,
	ISNULL(dbo.fnCalculateTaxAmountForFeeStructure(TCFP.I_Course_Fee_Plan_ID,'I'),0) as InstalmentTax,
	ISNULL(dbo.fnCalculateTaxAmountForFeeStructure(TCFP.I_Course_Fee_Plan_ID,'IA'),0) as TotalInstalmentTax
	from ECOMMERCE.T_Product_FeePlan TPFP
	inner join T_Course_Fee_Plan TCFP on TPFP.CourseFeePlanID=TCFP.I_Course_Fee_Plan_ID
	left join
	(
		select A.I_Course_Fee_Plan_ID,SUM(A.I_Item_Value) as FirstInstAmount 
		from T_Course_Fee_Plan_Detail A
		where
		A.I_Installment_No=1
		group by A.I_Course_Fee_Plan_ID
	) FD on TPFP.CourseFeePlanID=FD.I_Course_Fee_Plan_ID
	left join
	(
		select I_Course_Fee_Plan_ID,COUNT(DISTINCT I_Installment_No) as N_No_Of_Installments 
		from T_Course_Fee_Plan_Detail
		where
		I_Installment_No>0 and I_Item_Value>0
		group by I_Course_Fee_Plan_ID
	) FPD on TCFP.I_Course_Fee_Plan_ID=FPD.I_Course_Fee_Plan_ID
	where
	TPFP.ProductCentreID in
	(
		select TPCM.ProductCentreID from ECOMMERCE.T_Product_Center_Map TPCM
		inner join T_Center_Hierarchy_Name_Details TCHND on TCHND.I_Center_ID=TPCM.CenterID
		where
		TPCM.StatusID=1
		and TPCM.IsPublished=1
		and TPCM.ProductID in
		(
			select TPM.ProductID from ECOMMERCE.T_Product_Master TPM
			inner join ECOMMERCE.T_Category_Master TCM on TPM.CategoryID=TCM.ID
			inner join ECOMMERCE.T_Plan_Product_Map TPPM on TPM.ProductID=TPPM.ProductID and TPPM.StatusID=1
			where 
			TPM.StatusID=1 and TPM.IsPublished=1 --and (TPM.ValidFrom<=GETDATE() and ISNULL(TPM.ValidTo,GETDATE())>=GETDATE())
			and TPPM.PlanID=@PlanID
		)
	)
	and TPFP.StatusID=1 and TPFP.IsPublished=1 and (TPFP.ValidFrom<=CONVERT(DATE,GETDATE()) and ISNULL(TPFP.ValidTo,CONVERT(DATE,GETDATE()))>=CONVERT(DATE,GETDATE()))

--Table 4
	select A.ProductConfigID,A.ProductID,A.ConfigID,ISNULL(A.ConfigValue,B.ConfigDefaultValue) as ConfigValue,
	ISNULL(A.ConfigDisplayName,B.ConfigName) as ConfigDisplayName,B.ConfigCode,
	ISNULL(A.HeaderID,0) as HeaderID,ISNULL(A.SubHeaderID,0) as SubHeaderID,
	ISNULL(A.HeaderDisplayName,C.HeaderDesc) as HeaderDisplayName,ISNULL(A.SubHeaderDisplayName,D.HeaderDesc) as SubHeaderDisplayName
	from 
	ECOMMERCE.T_Product_Config A
	inner join ECOMMERCE.T_Cofiguration_Property_Master B on A.ConfigID=B.ConfigID
	left join ECOMMERCE.T_Heading_Master C on A.HeaderID=C.ID and C.HeaderType='Header'
	left join ECOMMERCE.T_Heading_Master D on A.SubHeaderID=D.ID and C.HeaderType='SubHeader'
	WHERE
	A.ProductID in
	(
		select TPM.ProductID from ECOMMERCE.T_Product_Master TPM
		inner join ECOMMERCE.T_Category_Master TCM on TPM.CategoryID=TCM.ID
		inner join ECOMMERCE.T_Plan_Product_Map TPPM on TPM.ProductID=TPPM.ProductID and TPPM.StatusID=1
		where 
		TPM.StatusID=1 and TPM.IsPublished=1 --and (TPM.ValidFrom<=GETDATE() and ISNULL(TPM.ValidTo,GETDATE())>=GETDATE())
		and TPPM.PlanID=@PlanID
	)
	and A.StatusID=1

--Table 5
	select TPCM.ProductID,TCHND.* from ECOMMERCE.T_Product_ExamCategory_Map TPCM
	inner join ECOMMERCE.T_ExamCategory_Master TCHND on TCHND.ExamCategoryID=TPCM.ExamCategoryID
	where
	TPCM.StatusID=1
	and TPCM.ProductID in
	(
		select TPM.ProductID from ECOMMERCE.T_Product_Master TPM
		inner join ECOMMERCE.T_Category_Master TCM on TPM.CategoryID=TCM.ID
		inner join ECOMMERCE.T_Plan_Product_Map TPPM on TPM.ProductID=TPPM.ProductID and TPPM.StatusID=1
		where 
		TPM.StatusID=1 --and TPM.IsPublished=1 and (TPM.ValidFrom<=GETDATE() and ISNULL(TPM.ValidTo,GETDATE())>=GETDATE())
		and TPPM.PlanID=@PlanID
	)

--Table 6
	select TPC.PlanConfigID,TPC.PlanID,TPC.ConfigID,TCPM.ConfigCode,ISNULL(TPC.ConfigDisplayName,TCPM.ConfigName) as DisplayName,
	ISNULL(TPC.ConfigValue,TCPM.ConfigDefaultValue) as ConfigValue
	from ECOMMERCE.T_Plan_Config TPC
	inner join ECOMMERCE.T_Cofiguration_Property_Master TCPM on TPC.ConfigID=TCPM.ConfigID
	inner join ECOMMERCE.T_Plan_Master TPM on TPC.PlanID=TPM.PlanID
	where TPC.StatusID=1 and TPM.PlanID=@PlanID
	
end
