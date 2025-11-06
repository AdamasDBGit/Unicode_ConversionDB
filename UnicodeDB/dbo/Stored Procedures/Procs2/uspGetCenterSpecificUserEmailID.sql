CREATE PROCEDURE [dbo].[uspGetCenterSpecificUserEmailID] 
(	
	@iHierarchyDetailID int,	
	@iTrustDomainID int
)

AS
BEGIN
	
	SET NOCOUNT ON;
	
	-- Select User Details 
	SELECT	UHD.I_Hierarchy_Master_ID AS iHierarchyDetailID,
			UHD.I_User_ID AS iUserID,
			UM.S_Email_ID AS sEmailID,
			HMD.S_Hierarchy_Chain AS sHierarchyChain
	FROM dbo.T_User_Hierarchy_Details UHD
	INNER JOIN dbo.T_User_Master UM
	ON UHD.I_User_ID = UM.I_User_ID
	INNER JOIN dbo.T_Hierarchy_Mapping_Details HMD
	ON UHD.I_Hierarchy_Detail_ID = HMD.I_Hierarchy_Detail_ID
	WHERE UHD.I_Hierarchy_Detail_ID = @iHierarchyDetailID
	AND UHD.I_Status = 1
	AND UM.I_Status = 1
	AND GETDATE() >= ISNULL(UHD.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(UHD.Dt_Valid_To, GETDATE())
	AND UHD.I_User_ID IN
	(	SELECT I_User_ID
		FROM dbo.T_User_Hierarchy_Details
		WHERE I_Hierarchy_Detail_ID = @iTrustDomainID
		AND I_Status = 1
		AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
		AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())	)

END
