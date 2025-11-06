-- =============================================
-- Author:		Aritra Saha
-- Create date: 19/03/2007
-- Description:	Gets all the fee plan request for a course 
-- =============================================
CREATE PROCEDURE [dbo].[uspGetFeePlanRequestforCourse] 
(
	-- Add the parameters for the stored procedure here
	@iCourseID int = null,
	@iCenterID int = null
)

AS
BEGIN

	SET NOCOUNT OFF;

	-- FeePlan List
	-- Table[1]
	SELECT	A.I_Course_FeePlan_Request_ID,
		A.I_Currency_ID,
		A.I_Course_Delivery_ID,
		A.I_Course_Center_ID,
		A.N_TotalLumpSum,
		A.N_TotalInstallment,
		A.S_Description,
		A.S_Workflow_GUID_ID,
		A.I_Status,
		C.I_Delivery_Pattern_ID,
		D.S_Pattern_Name
FROM dbo.T_Course_FeePlan_Request A, dbo.T_Course_Center_Detail B, 
dbo.T_Course_Delivery_Map C, dbo.T_Delivery_Pattern_Master D
WHERE A.I_Course_Center_ID = B.I_Course_Center_ID
AND B.I_Centre_Id = @iCenterID
AND B.I_Course_ID = @iCourseID
AND A.I_Course_Delivery_ID = C.I_Course_Delivery_ID
AND C.I_Course_ID = @iCourseID
AND C.I_Delivery_Pattern_ID = D.I_Delivery_Pattern_ID
AND A.I_Status = 1
AND GETDATE() >= ISNULL(B.Dt_Valid_From,GETDATE())
AND GETDATE() <= ISNULL(B.Dt_Valid_To,GETDATE())
AND B.I_Status = 1
AND C.I_Status = 1
AND D.I_Status = 1  
	
	

END
