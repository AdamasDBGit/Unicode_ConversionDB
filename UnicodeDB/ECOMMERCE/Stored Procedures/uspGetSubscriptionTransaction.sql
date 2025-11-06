CREATE PROCEDURE [ECOMMERCE].[uspGetSubscriptionTransaction]
(
	@TransactionNo VARCHAR(MAX),
	@FeeScheduleID INT=0
)
AS
BEGIN

	DECLARE @CentreID INT=0
	DECLARE @BrandID INT=0

	select @CentreID=ISNULL(I_Centre_Id,0),@BrandID=ISNULL(B.I_Brand_ID,0)
	from T_Invoice_Parent A 
	inner join T_Center_Hierarchy_Name_Details B on A.I_Centre_Id=B.I_Center_ID
	where A.I_Invoice_Header_ID=@FeeScheduleID and A.I_Status in (1,3)

	select A.*,C.StudentID,D.I_Student_Detail_ID,@CentreID as CenterID,@BrandID as BrandID
	from ECOMMERCE.T_Subscription_Transaction A
	inner join ECOMMERCE.T_Transaction_Product_Subscription_Details B on A.SubscriptionDetailID=B.SubscriptionDetailID
	inner join ECOMMERCE.T_Transaction_Product_Details C on C.TransactionProductDetailID=B.TransactionProductDetailID
	inner join T_Student_Detail D on C.StudentID=D.S_Student_ID
	where 
	A.TransactionNo=@TransactionNo and A.StatusID=1 and A.FeeScheduleID=@FeeScheduleID

END
