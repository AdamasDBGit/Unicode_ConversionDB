/*
-- =================================================================
-- Author : Swagatam Sarkar
-- Create date : 12/Feb/2007 
-- Description : 
-- =================================================================
*/


CREATE PROCEDURE [MBP].[uspGetActualSummary]
(
	@iBrandID int,
	@iHierarchyDetailID int
)
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @tblHD TABLE
	(
		ID INT IDENTITY(1,1),
		I_Hierarchy_Detail_ID int,
		S_Hierarchy_Name VARCHAR(200)
	)
	DECLARE @tblSum TABLE
	(
		I_Hierarchy_Detail_ID int,
		S_Hierarchy_Name VARCHAR(200),
		I_Actual_Enquiry int,
		I_Actual_Booking int,
		I_Actual_Enrollment int,
		I_Actual_Billing int
	)
	DECLARE @iCount INT, @iRow INT
	DECLARE @iHierachyDetailID INT
	DECLARE @sHierarchyName VARCHAR(200)
	
	INSERT INTO @tblHD
	SELECT HMD.I_Hierarchy_Detail_ID, HD.S_Hierarchy_Name 
	FROM dbo.T_Hierarchy_Mapping_Details HMD
	INNER JOIN dbo.T_Hierarchy_Details HD 
	ON HMD.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID
	WHERE HMD.I_Parent_ID = @iHierarchyDetailID AND HMD.I_Status = 1

	SELECT * FROM @tblHD

	SET @iCount = 1
	SET @iRow = (SELECT COUNT(*) FROM @tblHD)

	WHILE @iCount <= @iRow
	BEGIN
		SET @iHierachyDetailID = (SELECT I_Hierarchy_Detail_ID FROM @tblHD WHERE ID = @iCount)
		SET @sHierarchyName = (SELECT S_Hierarchy_Name FROM @tblHD WHERE ID = @iCount)
		INSERT INTO @tblSUM
		SELECT @iHierachyDetailID, @sHierarchyName, SUM(I_Actual_Enquiry), SUM(I_Actual_Booking), SUM(I_Actual_Enrollment), SUM(I_Actual_Billing)
		FROM MBP.T_MBPerformance WHERE I_Center_ID IN
		(SELECT * FROM dbo.fnGetCenterIDFromHierarchy(@iHierachyDetailID,@iBrandID))
		SET @iCount = @iCount + 1
	END

	SELECT * FROM @tblSUM
	
END
