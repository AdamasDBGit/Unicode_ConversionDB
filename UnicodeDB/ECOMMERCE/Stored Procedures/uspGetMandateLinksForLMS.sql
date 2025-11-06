CREATE PROCEDURE [ECOMMERCE].[uspGetMandateLinksForLMS](@CustomerID VARCHAR(MAX))
AS
BEGIN

	select * from
	(
		select DISTINCT D.CustomerID,E.PlanID,D.TransactionNo,E.PlanName,A.SubscriptionLink,ISNULL(A.SubscriptionStatus,'NA') as SubscriptionStatus
		from 
		ECOMMERCE.T_Transaction_Product_Details B 
		inner join ECOMMERCE.T_Transaction_Plan_Details C on B.TransactionPlanDetailID=C.TransactionPlanDetailID
		inner join ECOMMERCE.T_Transaction_Master D on C.TransactionID=D.TransactionID
		inner join ECOMMERCE.T_Plan_Master E on E.PlanID=C.PlanID
		inner join ECOMMERCE.T_Registration F on D.CustomerID=F.CustomerID and F.StatusID=1
		inner join ECOMMERCE.T_Registration_Enquiry_Map G on F.RegID=G.RegID and G.StatusID=1
		left join ECOMMERCE.T_Transaction_Product_Subscription_Details A on A.TransactionProductDetailID=B.TransactionProductDetailID --and ISNULL(A.SubscriptionStatus,'NA')!='Success'
		where
		D.CustomerID=@CustomerID and D.IsCompleted=1  --and A.SubscriptionLink IS NOT NULL
		and B.PaymentModeID=2
	) T1
	where T1.SubscriptionLink IS NULL and T1.SubscriptionStatus!='Success'


END
