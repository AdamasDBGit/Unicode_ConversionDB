CREATE PROCEDURE [dbo].[uspTimeTableGetScheduleFromBatchID] --[dbo].[uspTimeTableGetScheduleFromBatchID] 273,18       
    (        
      @iBatchID INT ,     
      @ICenterID INT,
      @I_Sub_Batch_ID INT= NULL
            
    )      
AS       
    BEGIN          
        SET NOCOUNT ON  
        IF @I_Sub_Batch_ID=0
        SET @I_Sub_Batch_ID=NULL
        SELECT  DISTINCT      
				TTTM.I_TimeTable_ID ,    
				TTTM.I_Center_ID ,     
                TTTM.I_Batch_ID ,    
                TTTM.I_Term_ID ,    
                TTM.S_Term_Name ,    
                TTTM.I_Module_ID ,     
                TMM.S_Module_Name ,    
                TTTM.I_Session_ID ,             
                TTTM.S_Session_Name ,    
                TTTM.S_Session_Topic ,                  
                TTTM.I_Room_ID ,    
                TRM.S_Building_Name ,    
                TRM.S_Block_Name ,    
                TRM.S_Floor_Name ,    
                TRM.S_Room_No ,      
                TTTM.I_TimeSlot_ID ,    
                TCTM.Dt_Start_Time ,    
                TCTM.Dt_End_Time ,                     
                TTTM.Dt_Schedule_Date ,    
                TTTM.Dt_Actual_Date ,    
                TTTFM.I_Employee_ID ,    
                TED.S_First_Name+' '+ISNULL(TED.S_Middle_Name,'')+' '+TED.S_Last_Name as S_Employee_Details ,   
                TTTFM2.I_Employee_ID AS I_Actual_Employee_ID,
                TED2.S_First_Name+' '+ISNULL(TED2.S_Middle_Name,'')+' '+TED2.S_Last_Name as S_Actual_Employee_Details ,    
                TTTM.I_Is_Complete,    
                TTTM.S_Remarks,
                tsbm.S_Sub_Batch_Code,
                tsbm.S_Sub_Batch_Name,
                tsbm.I_Sub_Batch_ID,
                TTTM.I_SessionTopic_Completed_Status_ID ,
                ISNULL(TTTM.I_ClassType,3) AS I_ClassTest_Status_ID
        INTO    #temp                    
        FROM    dbo.T_TimeTable_Master as TTTM    
        INNER JOIN dbo.T_Term_Master AS TTM ON TTM.I_Term_ID = TTTM.I_Term_ID    
        INNER JOIN dbo.T_Module_Master AS TMM ON TMM.I_module_ID = TTTM.I_module_ID    
        INNER JOIN dbo.T_Room_Master AS TRM ON TRM.I_Room_ID = TTTM.I_Room_ID    
        INNER JOIN dbo.T_Center_Timeslot_Master AS TCTM ON TCTM.I_TimeSlot_ID = TTTM.I_TimeSlot_ID    
        
        LEFT OUTER JOIN dbo.T_TimeTable_Faculty_Map AS TTTFM ON TTTFM.I_TimeTable_ID = TTTM.I_TimeTable_ID
        AND ISNULL(TTTFM.B_Is_Actual,0) = 0    
        LEFT OUTER JOIN dbo.T_Employee_Dtls AS TED ON TED.I_Employee_ID = TTTFM.I_Employee_ID  
          
        LEFT OUTER JOIN dbo.T_TimeTable_Faculty_Map AS TTTFM2 ON TTTFM2.I_TimeTable_ID = TTTM.I_TimeTable_ID
        AND ISNULL(TTTFM2.B_Is_Actual,0) = 1
        LEFT OUTER JOIN dbo.T_Employee_Dtls AS TED2 ON TED2.I_Employee_ID = TTTFM2.I_Employee_ID 
        LEFT OUTER JOIN dbo.T_Student_Sub_Batch_Master AS tsbm ON tsbm.I_Sub_Batch_ID=TTTM.I_Sub_Batch_ID 
             
        WHERE TTTM.I_Center_ID=@ICenterID     
        AND TTTM.I_Batch_ID=@iBatchID  
        AND isnull(TTTM.I_Sub_Batch_ID,0)=ISNULL(@I_Sub_Batch_ID,isnull(TTTM.I_Sub_Batch_ID,0))  
        AND TTTM.I_Status=1     
        AND TTM.I_Status=1    
        AND TMM.I_Status=1    
        AND TRM.I_Status=1    
        AND TCTM.I_Status=1          
            
        SELECT  I_TimeTable_ID ,    
    I_Center_ID ,     
                I_Batch_ID ,    
                I_Term_ID ,    
                S_Term_Name ,    
                I_Module_ID ,     
                S_Module_Name ,    
                I_Session_ID ,             
                S_Session_Name ,    
                S_Session_Topic ,                  
                I_Room_ID ,    
                S_Building_Name ,    
                S_Block_Name ,    
                S_Floor_Name ,    
                S_Room_No ,      
                I_TimeSlot_ID ,    
                Dt_Start_Time ,    
                Dt_End_Time ,                     
                Dt_Schedule_Date ,    
                Dt_Actual_Date ,    
                STUFF(( SELECT  distinct ', ' + CAST(I_Employee_ID AS VARCHAR(500))    
                        FROM    #temp    
                        WHERE   ( I_TimeTable_ID = Results.I_TimeTable_ID )    
                      FOR    
                        XML PATH('')    
                      ), 1, 2, '') AS EmployeeIDs ,    
                STUFF(( SELECT  distinct ', ' + CAST(S_Employee_Details AS VARCHAR(5000))    
                        FROM    #temp    
                        WHERE   ( I_TimeTable_ID = Results.I_TimeTable_ID )    
                      FOR    
                        XML PATH('')    
                      ), 1, 2, '') AS EmployeeDetails ,    
                STUFF(( SELECT  distinct ', ' + CAST(I_Actual_Employee_ID AS VARCHAR(500))    
                        FROM    #temp    
                        WHERE   ( I_TimeTable_ID = Results.I_TimeTable_ID )    
                      FOR    
                        XML PATH('')    
                      ), 1, 2, '') AS ActualEmployeeIDs ,    
                STUFF(( SELECT  distinct ', ' + CAST(S_Actual_Employee_Details AS VARCHAR(5000))    
                        FROM    #temp    
                        WHERE   ( I_TimeTable_ID = Results.I_TimeTable_ID )    
                      FOR    
                        XML PATH('')    
                      ), 1, 2, '') AS ActualEmployeeDetails ,    
                I_Is_Complete,    
                S_Remarks,
                S_Sub_Batch_Code,
                S_Sub_Batch_Name ,
                I_Sub_Batch_ID,    
                I_SessionTopic_Completed_Status_ID ,
                I_ClassTest_Status_ID,
				0 AS IsMarkAttendanceBlocked
        FROM    #temp Results    
        GROUP BY I_TimeTable_ID ,    
				I_Center_ID ,     
                I_Batch_ID ,    
                I_Term_ID ,    
                S_Term_Name ,    
                I_Module_ID ,     
                S_Module_Name ,    
                I_Session_ID ,             
                S_Session_Name ,    
				S_Session_Topic ,                  
                I_Room_ID ,    
                S_Building_Name ,    
                S_Block_Name ,    
                S_Floor_Name ,    
                S_Room_No ,      
				I_TimeSlot_ID ,    
                Dt_Start_Time ,    
                Dt_End_Time ,                     
                Dt_Schedule_Date ,    
                Dt_Actual_Date ,     
				I_Is_Complete,    
				S_Remarks ,
				S_Sub_Batch_Code,
                S_Sub_Batch_Name ,
                I_Sub_Batch_ID ,
                I_SessionTopic_Completed_Status_ID,
                I_ClassTest_Status_ID           
        DROP TABLE #temp    
            
    END
