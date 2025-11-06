CREATE PROCEDURE [ECOMMERCE].[uspGetProductList]
(
	@BrandID INT,
	@CategoryID INT=NULL,
	@sExamGroupList VARCHAR(MAX)=NULL,
	@PlanID INT=0
)
AS
BEGIN

	IF(@PlanID=0)
		set @PlanID=NULL

	DECLARE @Prod TABLE
	(
		ProductID INT
	)


	IF(@sExamGroupList IS NULL OR @sExamGroupList='')
	BEGIN

		insert into @Prod
		select DISTINCT A.ProductID
		from 
		ECOMMERCE.T_Product_Master A
		inner join ECOMMERCE.T_Category_Master B on A.CategoryID=B.ID and B.StatusID=1
		inner join ECOMMERCE.T_Product_ExamCategory_Map C on A.ProductID=C.ProductID and C.StatusID=1
		inner join ECOMMERCE.T_ExamGroup_ExamCategory_Map D on C.ExamCategoryID=D.ExamCategoryID and D.StatusID=1
		inner join ECOMMERCE.T_ExamGroup_Master E on E.ExamGroupID=D.ExamGroupID and E.StatusID=1
		inner join ECOMMERCE.T_Plan_Product_Map F on A.ProductID=F.ProductID and F.StatusID=1
		inner join ECOMMERCE.T_Plan_Master G on F.PlanID=G.PlanID and G.StatusID=1
		where
		A.BrandID=@BrandID and A.StatusID=1 and A.IsPublished=1 and G.IsPublished=1
		and Convert(DATE,ISNULL(A.ValidFrom,GETDATE()))<=CONVERT(DATE,GETDATE()) and Convert(DATE,ISNULL(A.ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())
		and Convert(DATE,ISNULL(G.ValidFrom,GETDATE()))<=CONVERT(DATE,GETDATE()) and Convert(DATE,ISNULL(G.ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())
		and F.PlanID=ISNULL(@PlanID,G.PlanID)
		and A.CategoryID=ISNULL(@CategoryID,B.ID)

	END
	ELSE
	BEGIN

		insert into @Prod
		select DISTINCT A.ProductID
		from 
		ECOMMERCE.T_Product_Master A
		inner join ECOMMERCE.T_Category_Master B on A.CategoryID=B.ID and B.StatusID=1
		inner join ECOMMERCE.T_Product_ExamCategory_Map C on A.ProductID=C.ProductID and C.StatusID=1
		inner join ECOMMERCE.T_ExamGroup_ExamCategory_Map D on C.ExamCategoryID=D.ExamCategoryID and D.StatusID=1
		inner join ECOMMERCE.T_ExamGroup_Master E on E.ExamGroupID=D.ExamGroupID and E.StatusID=1
		inner join ECOMMERCE.T_Plan_Product_Map F on A.ProductID=F.ProductID and F.StatusID=1
		inner join ECOMMERCE.T_Plan_Master G on F.PlanID=G.PlanID and G.StatusID=1
		where
		A.BrandID=@BrandID and A.StatusID=1 and A.IsPublished=1 and G.IsPublished=1
		and Convert(DATE,ISNULL(A.ValidFrom,GETDATE()))<=CONVERT(DATE,GETDATE()) and Convert(DATE,ISNULL(A.ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())
		and Convert(DATE,ISNULL(G.ValidFrom,GETDATE()))<=CONVERT(DATE,GETDATE()) and Convert(DATE,ISNULL(G.ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())
		and F.PlanID=ISNULL(@PlanID,G.PlanID)
		and A.CategoryID=ISNULL(@CategoryID,B.ID)
		and E.ExamGroupID in (select CAST(Val as INT) from fnString2Rows(@sExamGroupList,','))


	END

	
	select A.*,B.S_Course_Name as CourseName,D.CategoryName
	from 
	ECOMMERCE.T_Product_Master A
	inner join T_Course_Master B on A.CourseID=B.I_Course_ID
	inner join ECOMMERCE.T_Category_Master D on A.CategoryID=D.ID
	inner join @Prod C on A.ProductID=C.ProductID


	select A.ProductID,A.ConfigID,B.ConfigCode,ISNULL(A.ConfigValue,B.ConfigDefaultValue) as ConfigValue,ISNULL(A.ConfigDisplayName,B.ConfigName) as ConfigName
	from 
	ECOMMERCE.T_Product_Config A
	inner join ECOMMERCE.T_Cofiguration_Property_Master B on A.ConfigID=B.ConfigID and A.StatusID=1
	inner join @Prod C on A.ProductID=C.ProductID




END
