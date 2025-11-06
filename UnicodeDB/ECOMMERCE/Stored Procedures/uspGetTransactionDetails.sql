CREATE PROCEDURE [ECOMMERCE].[uspGetTransactionDetails](@TransactionNo VARCHAR(MAX))
AS
BEGIN

	select A.*,B.FirstName+' '+ISNULL(B.MiddleName,'')+' '+B.LastName as CustomerName,ISNULL(B.MobileNo,'') as MobileNo,ISNULL(B.EmailID,'') as EmailID
	from ECOMMERCE.T_Transaction_Master A
	inner join ECOMMERCE.T_Registration B on A.CustomerID COLLATE DATABASE_DEFAULT=B.CustomerID COLLATE DATABASE_DEFAULT
	where A.TransactionNo=@TransactionNo and A.StatusID=1

	select * from ECOMMERCE.T_Transaction_Plan_Details where TransactionID in
	(
		select TransactionID from ECOMMERCE.T_Transaction_Master where TransactionNo=@TransactionNo and StatusID=1
	)


	select A.*,B.I_Course_ID,B.Dt_BatchStartDate,B.I_Delivery_Pattern_ID,C.I_Brand_ID 
	from ECOMMERCE.T_Transaction_Product_Details A
	left join T_Student_Batch_Master B on A.BatchID=B.I_Batch_ID
	left join T_Center_Hierarchy_Name_Details C on A.CenterID=C.I_Center_ID
	where A.TransactionPlanDetailID in
	(
		select TransactionPlanDetailID from ECOMMERCE.T_Transaction_Plan_Details where TransactionID in
		(
			select TransactionID from ECOMMERCE.T_Transaction_Master where TransactionNo=@TransactionNo and StatusID=1
		)
	)

END
