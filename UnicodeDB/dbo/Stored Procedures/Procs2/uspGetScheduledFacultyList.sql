CREATE PROCEDURE [dbo].[uspGetScheduledFacultyList]
    (
      @iBrandID INT ,
      @HierarchyDetailID NVARCHAR(max) ,
      @dFromDate DATE
    )
AS 
    BEGIN

        SELECT DISTINCT
                TED.I_Employee_ID ,
                TED.S_First_Name ,
                ISNULL(TED.S_Middle_Name, '') AS S_Middle_Name ,
                TED.S_Last_Name ,
                TUM.I_User_ID ,
                TUM.S_Login_ID ,
                TED.S_Title ,
                TED.S_Email_ID ,
                TUM.S_User_Type ,
                TED.I_Centre_Id ,
                TED.I_Status
        FROM    dbo.T_Employee_Dtls TED
                INNER JOIN dbo.T_TimeTable_Faculty_Map TTTFM ON TED.I_Employee_ID = TTTFM.I_Employee_ID
                INNER JOIN dbo.T_TimeTable_Master TTTM ON TTTFM.I_TimeTable_ID = TTTM.I_TimeTable_ID
                INNER JOIN dbo.T_User_Master TUM ON TED.I_Employee_ID = TUM.I_Reference_ID
        WHERE   TED.I_Status = 3
                AND TTTM.I_Status = 1
                AND TTTFM.B_Is_Actual IN ( 0, 1 )
                AND TTTM.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@HierarchyDetailID,
                                                   @iBrandID) FGCFR )
                AND CONVERT(DATE, TTTM.Dt_Schedule_Date) = CONVERT(DATE, @dFromDate)

    END


