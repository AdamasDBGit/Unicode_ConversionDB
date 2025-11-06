CREATE PROCEDURE [ECOMMERCE].[uspGetPayoutTransaction]
(
	@TransactionNo VARCHAR(MAX),
	@FeeScheduleID INT=0
)
AS
BEGIN

	DECLARE @CentreID INT=0
	DECLARE @BrandID INT=0

	IF(@FeeScheduleID IS NULL OR @FeeScheduleID=0)
	BEGIN

		SET @FeeScheduleID=0

		select @FeeScheduleID=FeeScheduleID from ECOMMERCE.T_Payout_Transaction where 
		TransactionNo=@TransactionNo and StatusID=1 --and TransactionStatus='Pending'
		--and IsCompleted=0

	END

	select @CentreID=ISNULL(I_Centre_Id,0),@BrandID=ISNULL(B.I_Brand_ID,0)
	from T_Invoice_Parent A 
	inner join T_Center_Hierarchy_Name_Details B on A.I_Centre_Id=B.I_Center_ID
	where A.I_Invoice_Header_ID=@FeeScheduleID and A.I_Status in (1,3)

	select A.*,D.S_Student_ID as StudentID,D.I_Student_Detail_ID,@CentreID as CenterID,@BrandID as BrandID
	from ECOMMERCE.T_Payout_Transaction A
	inner join T_Invoice_Parent B on A.FeeScheduleID=B.I_Invoice_Header_ID
	inner join T_Student_Detail D on B.I_Student_Detail_ID=D.I_Student_Detail_ID
	where 
	A.TransactionNo=@TransactionNo and A.StatusID=1 and A.FeeScheduleID=@FeeScheduleID

END
