CREATE PROCEDURE [dbo].[uspGetRolesforDefaultUser] 
(	
	@iHierarchyMasterID int,	
	@iTrustDomainID int
)

AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT	DISTINCT C.S_Hierarchy_Chain as sHierarchyChain,
				     B.S_Email_ID AS sEmailID
	FROM dbo.T_User_Hierarchy_Details A
	INNER JOIN dbo.T_User_Master B
	ON A.I_User_ID = B.I_User_ID
	INNER JOIN dbo.T_Hierarchy_Mapping_Details C
	ON A.I_Hierarchy_Detail_ID = C.I_Hierarchy_Detail_ID
	WHERE A.I_Hierarchy_Master_ID = @iHierarchyMasterID
	AND A.I_Status = 1
	AND B.I_Status = 1
	AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())
	AND A.I_User_ID IN (	
					SELECT I_User_ID
					FROM dbo.T_User_Hierarchy_Details
					WHERE I_Hierarchy_Detail_ID = @iTrustDomainID
					AND I_Status = 1
					AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
					AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())	
						)
	AND C.I_Status = 1
	AND GETDATE() >= ISNULL(C.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(C.Dt_Valid_To, GETDATE())
	
END
