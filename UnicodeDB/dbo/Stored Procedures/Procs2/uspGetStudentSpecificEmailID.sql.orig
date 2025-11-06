CREATE PROCEDURE [dbo].[uspGetStudentSpecificEmailID] 
(	
	@sStudentIDs varchar(1000),
	@iHierarchyDetailID int	
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	DECLARE @sHierarchyChain varchar(100)

	SELECT @sHierarchyChain = S_Hierarchy_Chain
	FROM dbo.T_Hierarchy_Mapping_Details 
	WHERE I_Hierarchy_Detail_ID = @iHierarchyDetailID
	AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())
	AND I_Status = 1
	
	-- Select User Details 
	SELECT	SD.S_Email_ID AS sEmailID,
			@sHierarchyChain AS sHierarchyChain
	FROM dbo.T_Student_Detail SD
	INNER JOIN dbo.T_User_Master UM
	ON SD.I_Student_Detail_ID = UM.I_Reference_ID
	AND UM.S_User_Type = 'ST'
	AND SD.I_Status = 1
	AND UM.I_Status = 1
	INNER JOIN dbo.T_User_Hierarchy_Details UHD
	ON UM.I_User_ID = UHD.I_User_ID
	AND GETDATE() >= ISNULL(UHD.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(UHD.Dt_Valid_To, GETDATE())
	WHERE SD.I_Student_Detail_ID IN
	(
		SELECT * FROM [dbo].[fnString2Rows](@sStudentIDs,',')
	)

END
