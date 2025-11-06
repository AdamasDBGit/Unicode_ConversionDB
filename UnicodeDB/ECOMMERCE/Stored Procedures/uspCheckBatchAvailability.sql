CREATE PROCEDURE [ECOMMERCE].[uspCheckBatchAvailability]
AS
BEGIN


	select DISTINCT A.*,G.RegID,G.FirstName,ISNULL(G.MiddleName,'') as MiddleName,G.LastName,B.ProductName,C.PlanName,B.BrandID
	from 
	ECOMMERCE.T_Batch_Availability_Notification A
	inner join ECOMMERCE.T_Product_Master B on A.ProductID=B.ProductID
	inner join ECOMMERCE.T_Plan_Master C on A.PlanID=C.PlanID
	inner join T_Student_Batch_Master D on B.CourseID=D.I_Course_ID
	inner join T_Center_Batch_Details E on A.CenterID=E.I_Centre_Id and D.I_Batch_ID=E.I_Batch_ID
	inner join T_Course_Master F on B.CourseID=F.I_Course_ID
	inner join ECOMMERCE.T_Registration G on A.CustomerID=G.CustomerID
	where
	D.Dt_BatchStartDate>=CONVERT(DATE,GETDATE()) and A.NotifiedOn IS NULL and A.StatusID=1



END
