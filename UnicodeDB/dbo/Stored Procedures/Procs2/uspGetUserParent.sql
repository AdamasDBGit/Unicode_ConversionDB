-- =============================================
-- Author:		Aritra Saha
-- Create date: 26/06/2007
-- Description:	Get the Trust Doamin Details
-- =============================================

CREATE PROCEDURE [dbo].[uspGetUserParent] 
(
	-- Add the parameters for the stored procedure here
	@iUserId int
)
AS
BEGIN
	
	DECLARE @iHierarchyMasterIDforTD int	
	SELECT @iHierarchyMasterIDforTD = I_Hierarchy_Master_ID 
	FROM dbo.T_Hierarchy_Master THM WHERE THM.S_Hierarchy_Type = 'RH'

	CREATE TABLE #TempTable
	(
		I_User_ID INT,
		S_Email_ID VARCHAR(200)
	)
				
	INSERT INTO #TempTable									 
	SELECT TUM.I_User_ID, TUM.S_Email_ID FROM dbo.T_User_Master TUM
	INNER JOIN 
		(SELECT TUHD.I_User_ID FROM dbo.T_User_Hierarchy_Details TUHD
		INNER JOIN 
			(SELECT I_Parent_ID FROM dbo.T_Hierarchy_Mapping_Details THMD
			INNER JOIN
				(	SELECT I_Hierarchy_Detail_ID FROM dbo.T_User_Hierarchy_Details TUHD
					WHERE 
					TUHD.I_Hierarchy_Master_ID = @iHierarchyMasterIDforTD
					AND I_User_ID = @iUserId
					AND TUHD.I_Status <> 0 
					AND GETDATE() >= ISNULL(TUHD.Dt_Valid_From,GETDATE())
					AND GETDATE() <= ISNULL(TUHD.Dt_Valid_To,GETDATE())
				 ) TMP2
			ON THMD.I_Hierarchy_Detail_ID = TMP2.I_Hierarchy_Detail_ID
			) TMP1
		ON TUHD.I_Hierarchy_Detail_ID = TMP1.I_Parent_ID		
		AND I_Hierarchy_Master_ID =@iHierarchyMasterIDforTD
		AND I_Status <> 0 
		AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())
		AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())		
		) TMP		
	ON TUM.I_User_ID = TMP.I_User_ID
	
	


	DECLARE @iHierarchyMasterIDforSO int	
	SELECT @iHierarchyMasterIDforSO = THM.I_Hierarchy_Master_ID 
	FROM dbo.T_Hierarchy_Master THM 
	INNER JOIN dbo.T_User_Hierarchy_Details TUHD
	ON THM.I_Hierarchy_Master_ID = TUHD.I_Hierarchy_Master_ID
	WHERE THM.S_Hierarchy_Type = 'SO'
	

	CREATE TABLE #TempTable1
	(
		I_User_ID INT,
		S_Email_ID VARCHAR(200)
	)
				
	INSERT INTO #TempTable1									 
	SELECT TUM.I_User_ID, TUM.S_Email_ID FROM dbo.T_User_Master TUM
	INNER JOIN 
		(SELECT TUHD.I_User_ID FROM dbo.T_User_Hierarchy_Details TUHD
		INNER JOIN 
			(SELECT I_Parent_ID FROM dbo.T_Hierarchy_Mapping_Details THMD
			INNER JOIN
				(	SELECT I_Hierarchy_Detail_ID FROM dbo.T_User_Hierarchy_Details TUHD
					WHERE 
					TUHD.I_Hierarchy_Master_ID = @iHierarchyMasterIDforSO
					AND I_User_ID = @iUserId
					AND TUHD.I_Status <> 0 
					AND GETDATE() >= ISNULL(TUHD.Dt_Valid_From,GETDATE())
					AND GETDATE() <= ISNULL(TUHD.Dt_Valid_To,GETDATE())
				 ) TMP2
			ON THMD.I_Hierarchy_Detail_ID = TMP2.I_Hierarchy_Detail_ID
			) TMP1
		ON TUHD.I_Hierarchy_Detail_ID = TMP1.I_Parent_ID		
		AND I_Hierarchy_Master_ID =@iHierarchyMasterIDforSO
		AND I_Status <> 0 
		AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())
		AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())		
		) TMP		
	ON TUM.I_User_ID = TMP.I_User_ID
	

	SELECT * FROM #TempTable
	INTERSECT
	SELECT * FROM #TempTable1

END
