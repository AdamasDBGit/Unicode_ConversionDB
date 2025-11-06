CREATE PROCEDURE [REPORT].[uspGetResourceUtilizationReport]
(
	@sHierarchyList VARCHAR(MAX),
	@iBrandID INT,
	@dtStartDate DATETIME = NULL,
	@dtEndDate DATETIME = NULL,
	@iFacultyID INT = NULL,
	@iRoomID INT = NULL,
	@iBatchID INT = NULL
)
AS
BEGIN
	DECLARE @sResourceName VARCHAR(250)
	
	IF(@iRoomID = 0)
		SET @iRoomID = NULL
		
	IF(@iFacultyID = 0)
		SET @iFacultyID = NULL
	
	IF(@iBatchID = 0)
		SET @iBatchID = NULL
		
	IF (@iRoomID IS NOT NULL)
		SELECT @sResourceName = trm.S_Room_No FROM dbo.T_Room_Master AS trm WHERE trm.I_Room_ID = @iRoomID
	ELSE IF (@iFacultyID IS NOT NULL)
		SELECT @sResourceName = ted.S_First_Name + ' ' + ISNULL(ted.S_Middle_Name,'') + ' ' + ted.S_Last_Name 
		FROM dbo.T_Employee_Dtls AS ted WHERE ted.I_Employee_ID = @iFacultyID
	ELSE IF (@iBatchID IS NOT NULL)
		SELECT @sResourceName = tsbm.S_Batch_Name FROM dbo.T_Student_Batch_Master AS tsbm WHERE tsbm.I_Batch_ID = @iBatchID
	
	SELECT DISTINCT @sResourceName AS s_Resource_Name, tttm.I_Batch_ID, tctm.I_Center_ID, tctm.I_TimeSlot_ID, 
			tttm.I_Room_ID, trm.S_Room_No, tttm.I_Skill_ID, tttfm.I_Employee_ID, tttm.Dt_Schedule_Date, CAST(DATEPART(MM,tttm.Dt_Schedule_Date) AS CHAR(2)) + ' /' + CAST(DATEPART(YYYY,tttm.Dt_Schedule_Date) AS CHAR(4)) AS Period, tcm.S_Course_Code, 
			tcm.S_Course_Name, tsbm.S_Batch_Code, tsbm.S_Batch_Name, tctm.Dt_Start_Time, tctm.Dt_End_Time,
			ted.S_First_Name + ' ' + ISNULL(ted.S_Middle_Name, '') + ' ' + ted.S_Last_Name AS S_Faculty_Name
	FROM dbo.T_TimeTable_Master AS tttm
	INNER JOIN dbo.T_TimeTable_Faculty_Map AS tttfm ON tttm.I_TimeTable_ID = tttfm.I_TimeTable_ID
	INNER JOIN dbo.T_Center_Timeslot_Master AS tctm ON tctm.I_TimeSlot_ID = tttm.I_TimeSlot_ID
	INNER JOIN dbo.T_Student_Batch_Master AS tsbm ON tttm.I_Batch_ID = tsbm.I_Batch_ID
	INNER JOIN dbo.T_Course_Master AS tcm ON tsbm.I_Course_ID = tcm.I_Course_ID
	INNER JOIN dbo.T_Room_Master AS trm ON trm.I_Room_ID = tttm.I_Room_ID
	INNER JOIN dbo.T_Employee_Dtls AS ted ON ted.I_Employee_ID = tttfm.I_Employee_ID
	INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
			ON tttm.I_Center_ID=FN1.CenterID
	WHERE tttm.I_Batch_ID = ISNULL(@iBatchID, tttm.I_Batch_ID)
	AND tttfm.I_Employee_ID = ISNULL(@iFacultyID, tttfm.I_Employee_ID)
	AND tttm.I_Room_ID = ISNULL(@iRoomID, tttm.I_Room_ID)
	AND DATEDIFF(dd,ISNULL(@dtStartDate,tttm.Dt_Schedule_Date), tttm.Dt_Schedule_Date) >= 0
	AND DATEDIFF(dd,ISNULL(@dtEndDate,tttm.Dt_Schedule_Date), tttm.Dt_Schedule_Date) <= 0
END
