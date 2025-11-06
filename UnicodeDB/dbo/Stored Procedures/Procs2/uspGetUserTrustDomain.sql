CREATE PROC [dbo].[uspGetUserTrustDomain]
(
	@iUserID INT
)
AS
BEGIN

SET NOCOUNT ON

SELECT	A.I_Hierarchy_Detail_ID AS TrustDomainID, 
			C.S_Hierarchy_Name AS TrustDomainName
	FROM dbo.T_User_Hierarchy_Details A, 
	dbo.T_Hierarchy_Master B, 
	dbo.T_Hierarchy_Details C WITH(NOLOCK)
	WHERE A.I_User_ID = @iUserID
	AND A.I_Hierarchy_Master_ID = B.I_Hierarchy_Master_ID
	AND B.S_Hierarchy_Type = 'RH'
	AND A.I_Hierarchy_Detail_ID = C.I_Hierarchy_Detail_ID
	AND A.I_Status = 1
	AND B.I_Status = 1
	AND C.I_Status = 1
	AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())

END
