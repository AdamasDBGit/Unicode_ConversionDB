CREATE PROCEDURE [dbo].[uspTimeTableWiseGetScheduleFromTimeTableID] --[dbo].[uspTimeTableWiseGetScheduleFromTimeTableID] 1   
    (    
      @I_TimeTable_ID INT 
    )  
AS   
    BEGIN      
        SET NOCOUNT ON
        SELECT TTTM.I_TimeTable_ID ,
			   TTTM.I_Center_ID ,
			   TTTM.I_Batch_ID ,
               TTM.S_Term_Name ,
               TMM.S_Module_Name ,
               TTTM.S_Session_Name ,
               TTTM.Dt_Schedule_Date ,
               TTTM.Dt_Actual_Date,
               TTTM.I_Sub_Batch_ID,
               TSBM.S_Sub_Batch_Name
        FROM dbo.T_TimeTable_Master as TTTM
        INNER JOIN dbo.T_Term_Master AS TTM ON TTM.I_Term_ID = TTTM.I_Term_ID
        INNER JOIN dbo.T_Module_Master AS TMM ON TMM.I_module_ID = TTTM.I_module_ID
        LEFT OUTER JOIN T_Student_Sub_Batch_Master TSBM ON TTTM.I_Sub_Batch_ID=TSBM.I_Sub_Batch_ID
        WHERE TTTM.I_TimeTable_ID=@I_TimeTable_ID        
        AND TTTM.I_Status=1 
        AND TTM.I_Status=1
        AND TMM.I_Status=1
    END
