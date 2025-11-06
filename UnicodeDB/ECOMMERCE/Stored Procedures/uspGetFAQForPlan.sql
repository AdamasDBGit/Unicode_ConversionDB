CREATE PROCEDURE [ECOMMERCE].[uspGetFAQForPlan](@PlanID INT)
AS
BEGIN

	select A.PlanID,B.* from ECOMMERCE.T_Plan_FAQ_Map A
	inner join ECOMMERCE.T_FAQ_Header B on A.FAQHeaderID=B.FAQHeaderID
	where
	A.PlanID=@PlanID and A.StatusID=1 and B.StatusID=1

	select C.* from ECOMMERCE.T_Plan_FAQ_Map A
	inner join ECOMMERCE.T_FAQ_Header B on A.FAQHeaderID=B.FAQHeaderID
	inner join ECOMMERCE.T_FAQ_Details C on B.FAQHeaderID=C.FAQHeaderID
	where
	A.PlanID=@PlanID and A.StatusID=1 and B.StatusID=1  and C.StatusID=1

END
