CREATE PROCEDURE [dbo].[uspCopyTimeTableForWeek]     
    (      
      @ICenterID INT ,      
      @SCopyTimeTableForDateXML XML = NULL ,            
      @sCrtdBy Nnvarchar(max) ,        
      @DtCrtdOn DATETIME               
    )      
AS       
    BEGIN TRY                              
        BEGIN TRANSACTION T1      
    print '#1'          
        -- Create Temporary Table To TimeTable source Information                  
        CREATE TABLE #tempTimeTable      
            (      
     I_TimeSlot_ID int ,      
     I_Batch_ID int ,      
     I_Room_ID int ,      
     S_Remarks nvarchar(max) ,      
     I_Session_ID int ,      
     Dt_DestDate DATETIME ,  
     DtSelected DATETIME ,     
     S_SessionName nvarchar(max) ,      
     S_SessionTopic nvarchar(max) ,      
     I_ModuleId INT ,      
     I_TermId INT      
            )        
         
   -- Insert Values into Temporary Table                  
        INSERT  INTO #tempTimeTable      
                SELECT  T.c.value('@I_TimeSlot_ID', 'int') ,      
      T.c.value('@I_Batch_ID', 'int') ,      
                        T.c.value('@I_Room_ID', 'int') ,                             
                        CASE WHEN T.c.value('@S_Remarks','nvarchar(max)') = '' THEN NULL ELSE T.c.value('@S_Remarks','nvarchar(max)') END,      
                        T.c.value('@I_Session_ID', 'int'),      
                        T.c.value('@Dt_DestDate', 'DATETIME') , 
                        T.c.value('@DtSelected', 'DATETIME') ,     
                        T.c.value('@S_SessionName', 'nvarchar(max)') ,      
                        CASE WHEN T.c.value('@S_SessionTopic', 'nvarchar(max)') = '' THEN NULL ELSE T.c.value('@S_SessionTopic', 'nvarchar(max)') END,      
                        T.c.value('@I_ModuleId', 'INT') ,                              
                        T.c.value('@I_TermId', 'INT')                               
                FROM    @SCopyTimeTableForDateXML.nodes('/Root/MonthWiseCopy') T ( c )      
        print '#2'              
        IF ( SELECT COUNT(*)      
             FROM   T_TimeTable_Master      
             WHERE I_Center_ID = @ICenterID      
                    AND Dt_Schedule_Date IN (SELECT  DtSelected FROM #tempTimeTable )   
                    AND I_Status = 1      
           ) > 0       
            BEGIN              
                  print '#3'  
                        DELETE  FROM dbo.T_TimeTable_Faculty_Map      
                        WHERE   I_TimeTable_ID IN (      
                                SELECT  I_TimeTable_ID      
                                FROM    dbo.T_TimeTable_Master AS TTTM      
                                WHERE   Dt_Schedule_Date IN (SELECT  Dt_DestDate FROM #tempTimeTable )      
                                        AND I_Center_ID = @ICenterID )          
             
                        UPDATE  dbo.T_TimeTable_Master      
                        SET     I_Status = 0 ,      
                                S_Updt_By = @sCrtdBy ,      
                                Dt_Updt_On = @DtCrtdOn      
                        WHERE   Dt_Schedule_Date IN (SELECT  Dt_DestDate FROM #tempTimeTable )      
                                AND I_Center_ID = @ICenterID      
                              
                        INSERT  INTO dbo.T_TimeTable_Master      
                                ( I_Center_ID ,      
                                  Dt_Schedule_Date ,      
                                  I_TimeSlot_ID ,      
                                  I_Batch_ID ,      
                                  I_Room_ID ,      
                                  I_Skill_ID ,      
                                  I_Status ,      
                                  S_Crtd_By ,      
                                  Dt_Crtd_On ,      
                                  S_Remarks ,      
                                  I_Session_ID ,      
                                  I_Term_ID ,       
								  I_Module_ID ,      
								  S_Session_Name ,      
								  S_Session_Topic ,      
								  Dt_Actual_Date ,      
								  I_Is_Complete            
                     
                                )      
                                SELECT  @ICenterID ,      
                                        Dt_DestDate ,      
                                    I_TimeSlot_ID ,      
                                        I_Batch_ID ,      
                                        I_Room_ID ,      
                                        NULL ,      
                                        1 ,      
                                        @sCrtdBy ,      
                                        @DtCrtdOn ,      
                                        S_Remarks ,      
                                        I_Session_ID ,      
                                        I_TermId ,      
										I_ModuleId ,      
										S_SessionName ,      
										S_SessionTopic ,      
										null ,      
										0      
                                FROM    #tempTimeTable           
             print '#4'  
                        INSERT  INTO dbo.T_TimeTable_Faculty_Map      
                                ( I_TimeTable_ID ,      
                                  I_Employee_ID,    
                                  B_Is_Actual           
                                )      
                                SELECT distinct I_TimeTable_ID ,      
                                        I_Employee_ID,    
                                        0      
                                FROM    ( SELECT    I_Employee_ID ,      
                                                    TTTM.I_Center_ID ,      
                                                    TTTM.I_Batch_ID ,      
                                                    TTTM.I_Room_ID ,                                                          
                                                    TTTM.I_TimeSlot_ID      
                                          FROM      dbo.T_TimeTable_Faculty_Map      
                                                    AS TTTFM      
                                                    INNER JOIN dbo.T_TimeTable_Master      
                                                    AS TTTM ON TTTFM.I_TimeTable_ID = TTTM.I_TimeTable_ID      
                                          WHERE     I_Center_ID = @ICenterID      
                                                    AND Dt_Schedule_Date IN (SELECT distinct DtSelected FROM #tempTimeTable )      
                                                    AND TTTM.I_Status = 1     
                                                    --added by sudipta  
                                                    AND TTTFM.B_Is_Actual=0   
                                                      
                                                    -- end adition  
										) T1      
                                        INNER JOIN ( SELECT TTTM.I_TimeTable_ID ,      
                                                            TTTM.I_Center_ID ,      
                                                            TTTM.I_TimeSlot_ID ,      
                                                            TTTM.I_Batch_ID ,      
                                                            TTTM.I_Room_ID                                                                   
                                                     FROM   dbo.T_TimeTable_Master      
                                                            AS TTTM      
                                                     WHERE  Dt_Schedule_Date IN ( SELECT distinct Dt_DestDate FROM #tempTimeTable )      
                                                            AND I_Center_ID = @ICenterID      
                                                            AND TTTM.I_Status = 1      
                                                   ) T2 ON T1.I_Center_ID = T2.I_Center_ID      
                                                           AND T1.I_Batch_ID = T2.I_Batch_ID      
                                                           AND T1.I_Room_ID = T2.I_Room_ID                                                  
                                                           AND T1.I_TimeSlot_ID = T2.I_TimeSlot_ID      
                                                               
               print '#5'                 
            END            
        ELSE       
            BEGIN            
                RAISERROR('No classes are scheduled for the selected date.',11,1)              
            END                  
                        
        COMMIT TRANSACTION T1                
    END TRY                              
    BEGIN CATCH                              
 --Error occurred:                                
        ROLLBACK TRANSACTION T1                             
        DECLARE @ErrMsg Nnvarchar(max) ,      
            @ErrSeverity INT                              
        SELECT  @ErrMsg = ERROR_MESSAGE() ,      
                @ErrSeverity = ERROR_SEVERITY()                              
                              
        RAISERROR(@ErrMsg, @ErrSeverity, 1)                              
    END CATCH

