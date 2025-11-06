CREATE VIEW dbo.T_Student_Attendance_Details
AS
    SELECT  SA.I_Attendance_Detail_ID ,
            SA.I_Student_Detail_ID ,
            TTTM.I_TimeTable_ID ,
            TTTM.I_Batch_ID ,
            TSCD.I_Centre_Id,
            TTTM.I_Term_ID ,
            TTTM.I_Module_ID ,
            TTTM.I_Session_ID ,
            TTTM.S_Session_Name ,
            TTTM.S_Session_Topic ,
            TTTM.Dt_Schedule_Date ,
            TTTM.Dt_Actual_Date AS Dt_Attendance_Date ,
            1 AS I_Has_Attended ,
            TTTM.I_Is_Complete ,
            SA.S_Crtd_By ,
            SA.Dt_Crtd_On ,
            SBM.I_Course_ID ,
            SBM.I_TimeSlot_ID
    FROM    dbo.T_Student_Attendance AS SA
            INNER JOIN dbo.T_TimeTable_Master AS TTTM ON SA.I_TimeTable_ID = TTTM.I_TimeTable_ID
            INNER JOIN dbo.T_Student_Batch_Master AS SBM ON TTTM.I_Batch_ID = SBM.I_Batch_ID
            INNER JOIN dbo.T_Student_Detail AS SD ON SD.I_Student_Detail_ID = SA.I_Student_Detail_ID
            INNER JOIN dbo.T_Enquiry_Regn_Detail AS ERD ON SD.I_Enquiry_Regn_ID = ERD.I_Enquiry_Regn_ID
            INNER JOIN dbo.T_Student_Center_Detail AS TSCD ON TSCD.I_Student_Detail_ID = SD.I_Student_Detail_ID AND SA.I_Student_Detail_ID=TSCD.I_Student_Detail_ID
            WHERE
            TSCD.I_Status=1