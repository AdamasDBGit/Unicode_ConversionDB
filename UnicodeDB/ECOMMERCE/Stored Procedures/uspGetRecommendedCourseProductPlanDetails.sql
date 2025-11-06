
-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2022-11-09>
-- Description:	<Get All Recommended Course Products and Plans>
-- =============================================
CREATE PROCEDURE [ECOMMERCE].[uspGetRecommendedCourseProductPlanDetails]
	@CourseID INT 
AS
BEGIN
	
   create table #RC
	(
	CourseID INT,
	RecommendedCourseID INT
	)

	DECLARE @Prod TABLE
	(
		ProductID INT,
		CourseID INT
	)

	
	insert into #RC
	select DISTINCT @CourseID,RC.Recommended_Course_ID from 
	ECOMMERCE.T_Recommended_Course as RC
	inner join ECOMMERCE.T_Product_Master as PM on PM.CourseID=RC.Recommended_Course_ID
	inner join T_Course_Master as CM on CM.I_Course_ID=PM.CourseID 
	where RC.CourseID=@CourseID 
	and RC.Recommended_Course_ID != @CourseID 
	and RC.I_Status=1 and PM.StatusID=1 and CONVERT(DATE,PM.ValidTo) > CONVERT(DATE,GETDATE())
	and CM.I_Status=1

	---Recommended Course Lists
	select DISTINCT CM.I_Course_ID as Recommended_Course_ID,CM.S_Course_Code as Recommended_Course_Code,
	CM.S_Course_Name as Recommended_Course_Name,CM.I_Status as Course_Status from 
	#RC as Recourse
	inner join
	T_Course_Master as CM on CM.I_Course_ID=Recourse.RecommendedCourseID 

	--Recmmended Course Product Lists

	insert into @Prod
	select DISTINCT A.ProductID,A.CourseID
	from 
	ECOMMERCE.T_Product_Master A
	inner join ECOMMERCE.T_Category_Master B on A.CategoryID=B.ID and B.StatusID=1
	inner join ECOMMERCE.T_Product_ExamCategory_Map C on A.ProductID=C.ProductID and C.StatusID=1
	inner join ECOMMERCE.T_ExamGroup_ExamCategory_Map D on C.ExamCategoryID=D.ExamCategoryID and D.StatusID=1
	inner join ECOMMERCE.T_ExamGroup_Master E on E.ExamGroupID=D.ExamGroupID and E.StatusID=1
	inner join ECOMMERCE.T_Plan_Product_Map F on A.ProductID=F.ProductID and F.StatusID=1
	inner join ECOMMERCE.T_Plan_Master G on F.PlanID=G.PlanID and G.StatusID=1
	where
	A.StatusID=1 and A.IsPublished=1 and G.IsPublished=1
	and Convert(DATE,ISNULL(A.ValidFrom,GETDATE()))<=CONVERT(DATE,GETDATE()) and Convert(DATE,ISNULL(A.ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())
	and Convert(DATE,ISNULL(G.ValidFrom,GETDATE()))<=CONVERT(DATE,GETDATE()) and Convert(DATE,ISNULL(G.ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())


	select A.*,B.I_Course_ID as Course_ID,B.S_Course_Name as CourseName,D.CategoryName
	from 
	ECOMMERCE.T_Product_Master A
	inner join #RC as recomcourse on A.CourseID=recomcourse.RecommendedCourseID
	inner join T_Course_Master B on recomcourse.RecommendedCourseID=B.I_Course_ID
	inner join ECOMMERCE.T_Category_Master D on A.CategoryID=D.ID
	inner join @Prod C on A.ProductID=C.ProductID

	--Recmmended Course Plan Lists

	select PlanM.*,PM.ProductID,PM.ProductName
	from 
	ECOMMERCE.T_Product_Master PM
	inner join #RC as recomcourse on PM.CourseID=recomcourse.RecommendedCourseID
	inner join T_Course_Master CM on recomcourse.RecommendedCourseID=CM.I_Course_ID
	inner join ECOMMERCE.T_Category_Master TCM on PM.CategoryID=TCM.ID
	inner join @Prod C on PM.ProductID=C.ProductID
	inner join T_Plan_Product_Map as PPM on PPM.ProductID=PM.ProductID
	inner join T_Plan_Master as PlanM on PlanM.PlanID=PPM.PlanID
	where
	PM.StatusID=1 and PlanM.StatusID=1 and PlanM.IsPublished=1
	and Convert(DATE,ISNULL(PlanM.ValidFrom,GETDATE()))<=CONVERT(DATE,GETDATE()) and Convert(DATE,ISNULL(PlanM.ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())




END
