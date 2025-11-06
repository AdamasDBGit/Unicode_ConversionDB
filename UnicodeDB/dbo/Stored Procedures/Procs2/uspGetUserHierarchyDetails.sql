CREATE PROCEDURE [dbo].[uspGetUserHierarchyDetails] 

-- Add the parameters for the stored procedure here

	@iUserID INT

AS
BEGIN

	SELECT	A.I_User_Hierarchy_Detail_ID, 
			A.I_User_ID,
			A.I_Hierarchy_Master_ID,
			A.I_Hierarchy_Detail_ID,
			B.S_Hierarchy_Type,
			D.I_Sequence			
	FROM dbo.T_User_Hierarchy_Details A 
	INNER JOIN dbo.T_Hierarchy_Master B
	ON A.I_Hierarchy_Master_ID = B.I_Hierarchy_Master_ID
	INNER JOIN dbo.T_Hierarchy_Details C
	ON A.I_Hierarchy_Detail_ID = C.I_Hierarchy_Detail_ID
	INNER JOIN dbo.T_Hierarchy_Level_Master D
	ON C.I_Hierarchy_Level_Id = D.I_Hierarchy_Level_Id
	AND A.I_User_ID = @iUserID
	AND A.I_Status <> 0
	AND B.I_Status <> 0
	AND C.I_Status <> 0
	AND D.I_Status <> 0
	AND GETDATE() >= ISNULL(A.Dt_Valid_From,GETDATE())
	AND GETDATE() <= ISNULL(A.Dt_Valid_To,GETDATE())

END
