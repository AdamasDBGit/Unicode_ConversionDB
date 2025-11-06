CREATE PROCEDURE [LMS].[uspUpdateMandateLinkForStudentStatus](@StudentDetailID INT=NULL)
AS
BEGIN

	UPDATE T1
	set
	T1.S_MandateLink=ISNULL(T2.SubscriptionLink,''),
	T1.Dt_Updt_On=GETDATE(),
	T1.S_Updt_By='rice-group-admin',
	T1.B_IsInQueue=0
	FROM
	T_Student_Status T1
	inner join
	(
		select E.I_Invoice_Header_ID,
		CASE WHEN A.SubscriptionStatus='Success' THEN '' ELSE ISNULL(A.SubscriptionLink,'') END as SubscriptionLink 
		from ECOMMERCE.T_Transaction_Product_Details B 
		inner join ECOMMERCE.T_Product_Master C on B.ProductID=C.ProductID
		inner join T_Invoice_Child_Header D on C.CourseID=D.I_Course_ID
		inner join T_Invoice_Parent E on D.I_Invoice_Header_ID=e.I_Invoice_Header_ID
		inner join T_Student_Detail F on E.I_Student_Detail_ID=F.I_Student_Detail_ID
		left join ECOMMERCE.T_Transaction_Product_Subscription_Details A on A.TransactionProductDetailID=B.TransactionProductDetailID
		where
		E.I_Status in (1,3) and (ISNULL(BillingStartDate,GETDATE())<=GETDATE() and ISNULL(BillingEndDate,GETDATE())>=GETDATE())
		and B.IsCompleted=1 and B.PaymentModeID=2 and E.I_Student_Detail_ID= ISNULL(@StudentDetailID,F.I_Student_Detail_ID)
	) T2 on T1.InvoiceHeaderID=T2.I_Invoice_Header_ID 
	and ISNULL(T1.S_MandateLink,'') COLLATE DATABASE_DEFAULT!=ISNULL(T2.SubscriptionLink,'') COLLATE DATABASE_DEFAULT
	and T1.ValidTo IS NULL

END
