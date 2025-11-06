-- =============================================
-- Author:		Soumya Sikder
-- Create date: 17/01/2007
-- Description:	Fetches all the Course Family Master Table Details
-- =============================================

CREATE PROCEDURE [dbo].[uspGetDiscountScheme] 

AS
BEGIN

	--SELECT  DSM.I_Discount_Scheme_ID,
	--		DSM.S_Discount_Scheme_Name,
	--		DSM.Dt_Valid_From,
	--		DSM.Dt_Valid_To,
	--		DSM.I_Status,
	--		DSM.S_Crtd_By,
	--		DSM.S_Upd_By,
	--		DSM.Dt_Crtd_On,
	--		DSM.Dt_Upd_On,
	--		DD.I_CourseList_ID,
	--		DD.N_Range_From,
	--		DD.N_Range_To,
	--		DD.N_Discount_Rate,
	--		CLM.S_CourseList_Name,
	--		CLM.I_Brand_ID
	--FROM dbo.T_Discount_Scheme_Master As DSM, 
	--dbo.T_Discount_Details As DD,
	--dbo.T_CourseList_Master As CLM
	--WHERE DSM.I_Discount_Scheme_ID = DD.I_Discount_Scheme_ID
	--AND DD.I_CourseList_ID = CLM.I_CourseList_ID
	--AND DSM.I_Status = 1
	--AND CLM.I_Status = 1
	--AND DATEDIFF(dd,[DSM].[Dt_Valid_To],GETDATE()) <= 0



	select DISTINCT A.* from T_Discount_Scheme_Master A
	inner join T_Discount_Scheme_Details B on A.I_Discount_Scheme_ID=B.I_Discount_Scheme_ID
	inner join T_Discount_Center_Detail C on A.I_Discount_Scheme_ID=C.I_Discount_Scheme_ID
	inner join T_Discount_Course_Detail D on C.I_Discount_Center_Detail_ID=D.I_Discount_Centre_Detail_ID
	where
	A.I_Status=1
	and C.I_Status=1 and D.I_Status=1 
	and (ISNULL(A.Dt_Valid_To,GETDATE())>=GETDATE() and ISNULL(A.Dt_Valid_From,GETDATE())<=GETDATE())


END
