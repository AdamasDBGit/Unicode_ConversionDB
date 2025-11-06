CREATE PROCEDURE [dbo].[uspInsertPlannedRoutineData]
AS 
    BEGIN

        INSERT  INTO dbo.T_TimeTable_Master_Planned
                ( I_TimeTable_ID ,
                  I_Center_ID ,
                  Dt_Schedule_Date ,
                  I_TimeSlot_ID ,
                  I_Batch_ID ,
                  I_Room_ID ,
                  I_Skill_ID ,
                  I_Status ,
                  S_Crtd_By ,
                  Dt_Crtd_On ,
                  S_Updt_By ,
                  Dt_Updt_On ,
                  S_Remarks ,
                  I_Session_ID ,
                  I_Term_ID ,
                  I_Module_ID ,
                  S_Session_Name ,
                  S_Session_Topic ,
                  Dt_Actual_Date ,
                  I_Is_Complete ,
                  I_Employee_ID ,
                  B_Is_Actual 
            
                )
                SELECT  TTTM.I_TimeTable_ID ,
                        TTTM.I_Center_ID ,
                        TTTM.Dt_Schedule_Date ,
                        TTTM.I_TimeSlot_ID ,
                        TTTM.I_Batch_ID ,
                        TTTM.I_Room_ID ,
                        TTTM.I_Skill_ID ,
                        TTTM.I_Status ,
                        TTTM.S_Crtd_By ,
                        TTTM.Dt_Crtd_On ,
                        TTTM.S_Updt_By ,
                        TTTM.Dt_Updt_On ,
                        TTTM.S_Remarks ,
                        TTTM.I_Session_ID ,
                        TTTM.I_Term_ID ,
                        TTTM.I_Module_ID ,
                        TTTM.S_Session_Name ,
                        TTTM.S_Session_Topic ,
                        TTTM.Dt_Actual_Date ,
                        TTTM.I_Is_Complete ,
                        TTTFM.I_Employee_ID ,
                        TTTFM.B_Is_Actual
                FROM    dbo.T_TimeTable_Master TTTM
                        INNER JOIN dbo.T_TimeTable_Faculty_Map TTTFM ON TTTM.I_TimeTable_ID = TTTFM.I_TimeTable_ID
                WHERE   CONVERT(DATE, TTTM.Dt_Schedule_Date) = CONVERT(DATE, GETDATE())
                        AND TTTM.I_Status = 1            
    END
