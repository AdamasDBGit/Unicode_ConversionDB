-- =============================================
-- Author:		Swagatam Sarkar 
-- Create date: 29/5/2007
-- Description:	To retrieve notification configuration info
-- =============================================

CREATE PROCEDURE [dbo].[uspGetNotificationConfig]
(
	-- Add the parameters for the stored procedure here
	@iTaskID int = NULL,
	@iHierarchyDetailID int = NULL
)

AS
BEGIN
	IF @iTaskID IS NULL AND @iHierarchyDetailID IS NULL
	BEGIN
		SELECT	DISTINCT TM.S_Name AS Task_Name, TM.I_Task_Master_Id AS Task_ID, 
		CASE TM.I_Type WHEN '1' THEN 'Information' WHEN '2' THEN 'Task' END AS Task_Type,
		HD.S_Hierarchy_Name, HD.I_Hierarchy_Detail_ID
		FROM T_Task_Master TM 
		LEFT OUTER JOIN T_Task_Hierarchy_Mapping THM
		ON TM.I_Task_Master_Id = THM.I_Task_Master_Id 
		LEFT OUTER JOIN T_Hierarchy_Details HD 
		ON THM.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID 
		WHERE TM.I_IsActive = 1
		ORDER BY TM.S_Name
	END
	ELSE IF @iTaskID IS NULL AND @iHierarchyDetailID IS NOT NULL
	BEGIN
		SELECT	DISTINCT TM.S_Name AS Task_Name, TM.I_Task_Master_Id AS Task_ID, 
		CASE TM.I_Type WHEN '1' THEN 'Information' WHEN '2' THEN 'Task' END AS Task_Type,
		HD.S_Hierarchy_Name, HD.I_Hierarchy_Detail_ID
		FROM T_Task_Master TM 
		LEFT OUTER JOIN T_Task_Hierarchy_Mapping THM
		ON TM.I_Task_Master_Id = THM.I_Task_Master_Id 
		AND TM.I_Task_Master_Id = ISNULL(null,TM.I_Task_Master_Id)
		LEFT OUTER JOIN T_Hierarchy_Details HD 
		ON THM.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID 
		WHERE THM.I_Hierarchy_Detail_ID = @iHierarchyDetailID
		AND TM.I_IsActive = 1
		ORDER BY TM.S_Name
	END
	ELSE IF @iHierarchyDetailID IS NULL AND @iTaskID IS NOT NULL
	BEGIN
		SELECT	DISTINCT TM.S_Name AS Task_Name, TM.I_Task_Master_Id AS Task_ID, 
		CASE TM.I_Type WHEN '1' THEN 'Information' WHEN '2' THEN 'Task' END AS Task_Type,
		HD.S_Hierarchy_Name, HD.I_Hierarchy_Detail_ID
		FROM T_Task_Master TM 
		LEFT OUTER JOIN T_Task_Hierarchy_Mapping THM
		ON TM.I_Task_Master_Id = THM.I_Task_Master_Id 
		LEFT OUTER JOIN T_Hierarchy_Details HD 
		ON THM.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID 
		WHERE TM.I_Task_Master_Id = @iTaskID
		AND TM.I_IsActive = 1
		ORDER BY TM.I_Task_Master_Id
	END
	ELSE
	BEGIN
		SELECT	DISTINCT TM.S_Name AS Task_Name, TM.I_Task_Master_Id AS Task_ID, 
		CASE TM.I_Type WHEN '1' THEN 'Information' WHEN '2' THEN 'Task' END AS Task_Type,
		HD.S_Hierarchy_Name, HD.I_Hierarchy_Detail_ID
		FROM T_Task_Master TM 
		INNER JOIN T_Task_Hierarchy_Mapping THM
		ON TM.I_Task_Master_Id = THM.I_Task_Master_Id 
		INNER JOIN T_Hierarchy_Details HD 
		ON THM.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID 
		WHERE TM.I_Task_Master_Id = @iTaskID
		AND THM.I_Hierarchy_Detail_ID = @iHierarchyDetailID
		AND TM.I_IsActive = 1
		ORDER BY TM.I_Task_Master_Id
	END

END
