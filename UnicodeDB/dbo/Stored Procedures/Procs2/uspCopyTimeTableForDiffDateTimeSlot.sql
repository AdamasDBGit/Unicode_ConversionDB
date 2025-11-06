-- exec uspCopyTimeTableForTimeSlot @ICenterID=19,@DtSelected='2014-07-20 00:00:00',@SCopyTimeTableForTimeSlotXML=N'<Root><TimeTableCopy I_TimeSlot_ID="0" I_Batch_ID="1398" I_Room_ID="21" S_Remarks="" I_Session_ID="452" Dt_DestDate="8/10/2014" S_SessionName="CompoundInterest-2" S_SessionTopic="CompoundInterest" I_ModuleId="419" I_TermId="37" /><TimeTableCopy I_TimeSlot_ID="0" I_Batch_ID="1422" I_Room_ID="16" S_Remarks="" I_Session_ID="449" Dt_DestDate="8/10/2014" S_SessionName="India&amp;WorldFamousSites_InternationalAirports_Airlines_IndianArchitechture_PenName" S_SessionTopic="India&amp;WorldFamousSites_InternationalAirports_Airlines_IndianArchitechture_PenName" I_ModuleId="417" I_TermId="37" /><TimeTableCopy I_TimeSlot_ID="0" I_Batch_ID="1510" I_Room_ID="2" S_Remarks="" I_Session_ID="462" Dt_DestDate="8/10/2014" S_SessionName="Essay,Writing,Comprehension,Letter Writing" S_SessionTopic="Essay,Writing,Comprehension,Letter Writing" I_ModuleId="430" I_TermId="37" /><TimeTableCopy I_TimeSlot_ID="0" I_Batch_ID="1580" I_Room_ID="17" S_Remarks="" I_Session_ID="168" Dt_DestDate="8/10/2014" S_SessionName="Extremist Phase" S_SessionTopic="Extremist Phase" I_ModuleId="146" I_TermId="26" /><TimeTableCopy I_TimeSlot_ID="0" I_Batch_ID="1605" I_Room_ID="27" S_Remarks="" I_Session_ID="118" Dt_DestDate="8/10/2014" S_SessionName="Hormone" S_SessionTopic="Hormone" I_ModuleId="320" I_TermId="33" /><TimeTableCopy I_TimeSlot_ID="0" I_Batch_ID="1865" I_Room_ID="9" S_Remarks="" I_Session_ID="185" Dt_DestDate="8/10/2014" S_SessionName="Sitting arrangment" S_SessionTopic="Sitting arrangment" I_ModuleId="336" I_TermId="33" /><TimeTableCopy I_TimeSlot_ID="0" I_Batch_ID="2040" I_Room_ID="26" S_Remarks="" I_Session_ID="22" Dt_DestDate="8/10/2014" S_SessionName="Periodic Table" S_SessionTopic="Periodic Table" I_ModuleId="273" I_TermId="31" /><TimeTableCopy I_TimeSlot_ID="0" I_Batch_ID="2061" I_Room_ID="34" S_Remarks="" I_Session_ID="59" Dt_DestDate="8/10/2014" S_SessionName="Preposition, Conjunction, Interjection" S_SessionTopic="Preposition, Conjunction, Interjection" I_ModuleId="73" I_TermId="23" /><TimeTableCopy I_TimeSlot_ID="0" I_Batch_ID="2250" I_Room_ID="18" S_Remarks="" I_Session_ID="81256" Dt_DestDate="8/10/2014" S_SessionName="Heat and Temperature, Electromagnetic Spectrum" S_SessionTopic="Heat and Temperature, Electromagnetic Spectrum" I_ModuleId="3039" I_TermId="618" /></Root>',@ISrcTimeSlotID=11,@sCrtdBy=N'sa',@DtCrtdOn='2014-09-05 15:19:09.990'
CREATE PROCEDURE [dbo].[uspCopyTimeTableForDiffDateTimeSlot]   
    (      
      @ICenterID INT ,      
      @DtSelected DATETIME ,     
      @SCopyTimeTableForTimeSlotXML XML = NULL ,     
      @ISrcTimeSlotID INT ,      
      @sCrtdBy NVARCHAR(MAX) ,      
      @DtCrtdOn DATETIME            
    )      
AS       
    BEGIN TRY                          
  BEGIN TRANSACTION T1    
            
        -- Create Temporary Table To TimeTable source Information                
        CREATE TABLE #tempTimeTable    
            (    
				 I_TimeSlot_ID int ,    
				 I_Batch_ID int ,    
				 I_Room_ID int ,    
				 S_Remarks varchar(500) ,    
				 I_Session_ID int ,  
				 Dt_DestDate DATETIME ,   
				 S_SessionName VARCHAR(500) ,    
				 S_SessionTopic VARCHAR(500) ,    
				 I_ModuleId INT ,    
				 I_TermId INT          
            )      
       print 'A'
   -- Insert Values into Temporary Table                
        INSERT  INTO #tempTimeTable    
                SELECT  T.c.value('@I_TimeSlot_ID', 'int') ,    
						T.c.value('@I_Batch_ID', 'int') ,    
                        T.c.value('@I_Room_ID', 'int') ,                           
                        CASE WHEN T.c.value('@S_Remarks','varchar(500)') = '' THEN NULL ELSE T.c.value('@S_Remarks','varchar(500)') END,    
                        T.c.value('@I_Session_ID', 'int') , 
                        T.c.value('@Dt_DestDate', 'DATETIME') ,     
                        T.c.value('@S_SessionName', 'VARCHAR(500)') ,    
                        CASE WHEN T.c.value('@S_SessionTopic', 'varchar(500)') = '' THEN NULL ELSE T.c.value('@S_SessionTopic', 'varchar(500)') END,    
                        T.c.value('@I_ModuleId', 'INT') ,                            
                        T.c.value('@I_TermId', 'INT')    
                FROM    @SCopyTimeTableForTimeSlotXML.nodes('/Root/TimeTableCopy') T ( c )                   
                    
         print '1'   
                 
        IF ( SELECT COUNT(*)      
             FROM   T_TimeTable_Master      
             WHERE  I_Center_ID = @ICenterID      
                    AND Dt_Schedule_Date = @DtSelected      
                    AND I_TimeSlot_ID = @ISrcTimeSlotID      
                    AND I_Status = 1    
           ) > 0       
            BEGIN          
    print '2' 
                DELETE  FROM dbo.T_TimeTable_Faculty_Map      
                WHERE   I_TimeTable_ID IN (      
                        SELECT  I_TimeTable_ID      
                        FROM    dbo.T_TimeTable_Master AS TTTM      
                        WHERE    
                        I_TimeSlot_ID IN (  SELECT  I_TimeSlot_ID FROM #tempTimeTable )    
                        AND I_Center_ID = @ICenterID      
                        AND Dt_Schedule_Date IN (SELECT  Dt_DestDate FROM #tempTimeTable )  )      
         print '3' 
                UPDATE  dbo.T_TimeTable_Master      
                SET     I_Status = 0 ,      
                        S_Updt_By = @sCrtdBy ,      
                        Dt_Updt_On = @DtCrtdOn      
                WHERE      
                        I_TimeSlot_ID IN (  SELECT  I_TimeSlot_ID FROM #tempTimeTable )     
                        AND I_Center_ID = @ICenterID      
                        AND Dt_Schedule_Date IN (SELECT  Dt_DestDate FROM #tempTimeTable )      
             print '4'                
                            
                --DELETE  FROM dbo.T_TimeTable_Faculty_Map      
                --WHERE   I_TimeTable_ID IN (      
                --        SELECT  I_TimeTable_ID      
                --      FROM    dbo.T_TimeTable_Master AS TTTM      
                --        WHERE    
                --        I_Batch_ID IN (  SELECT  I_Batch_ID FROM #tempTimeTable )     
                --        AND I_Session_ID IN (  SELECT  I_Session_ID FROM #tempTimeTable )     
                --        AND I_Center_ID = @ICenterID      
                --        AND Dt_Schedule_Date = @DtSelected     
                --        AND I_TimeSlot_ID <> @ISrcTimeSlotID )    
                            
                --UPDATE  dbo.T_TimeTable_Master      
                --SET     I_Status = 0 ,      
                --        S_Updt_By = @sCrtdBy ,      
                --        Dt_Updt_On = @DtCrtdOn      
                --WHERE      
                --        I_Batch_ID IN (  SELECT  I_Batch_ID FROM #tempTimeTable )     
                --        AND I_Session_ID IN (  SELECT  I_Session_ID FROM #tempTimeTable )     
                --        AND I_Center_ID = @ICenterID      
                --        AND Dt_Schedule_Date = @DtSelected    
                --        AND I_TimeSlot_ID <> @ISrcTimeSlotID     
                            
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
                            
           print '5' 
                INSERT  INTO dbo.T_TimeTable_Faculty_Map      
                        ( I_TimeTable_ID ,      
                          I_Employee_ID,  
                          B_Is_Actual       
                        )      
                        SELECT  I_TimeTable_ID ,      
                                I_Employee_ID,  
                                0      
                        FROM    ( SELECT    I_Employee_ID ,      
                                            TTTM.I_Center_ID ,      
                                            TTTM.Dt_Schedule_Date ,      
                                            TTTM.I_Batch_ID ,      
                                            TTTM.I_Room_ID,
                                            TTTM.I_TimeSlot_ID   
                                  FROM      dbo.T_TimeTable_Faculty_Map AS TTTFM      
                                            INNER JOIN dbo.T_TimeTable_Master      
                                            AS TTTM ON TTTFM.I_TimeTable_ID = TTTM.I_TimeTable_ID      
                                  WHERE     I_TimeSlot_ID = @ISrcTimeSlotID      
                                            AND I_Center_ID = @ICenterID      
                                            AND Dt_Schedule_Date = @DtSelected      
                                            AND TTTM.I_Status = 1
                                            AND TTTFM.B_Is_Actual=0         
                                ) T1      
                                INNER JOIN ( SELECT TTTM.I_TimeTable_ID ,      
                                                    TTTM.I_Center_ID ,      
                                                    TTTM.Dt_Schedule_Date ,      
                                                    TTTM.I_Batch_ID ,      
                                                    TTTM.I_Room_ID,
                                                    TTTM.I_TimeSlot_ID      
                                             FROM   dbo.T_TimeTable_Master AS TTTM      
                                             WHERE      
             I_TimeSlot_ID IN (  SELECT  I_TimeSlot_ID FROM #tempTimeTable )    
                                                    AND I_Center_ID = @ICenterID      
                                                    AND Dt_Schedule_Date IN ( SELECT  Dt_DestDate FROM #tempTimeTable )       
                                                    AND TTTM.I_Status = 1      
                                           ) T2 ON T1.I_Center_ID = T2.I_Center_ID      
                                                   --AND T1.Dt_Schedule_Date = T2.Dt_Schedule_Date      
                                                   AND T1.I_Batch_ID = T2.I_Batch_ID      
                                                   AND T1.I_Room_ID = T2.I_Room_ID  
                                                   AND T1.I_TimeSlot_ID = T2.I_TimeSlot_ID    
                                                   
                                                   print '6' 
            END        
        ELSE       
            BEGIN        
                RAISERROR('No classes are scheduled on this time slot for this date.',11,1)          
            END              
            COMMIT TRANSACTION T1          
    END TRY                          
    BEGIN CATCH                          
 --Error occurred:                            
        ROLLBACK TRANSACTION T1                         
        DECLARE @ErrMsg NVARCHAR(4000) ,      
            @ErrSeverity INT                          
        SELECT  @ErrMsg = ERROR_MESSAGE() ,      
                @ErrSeverity = ERROR_SEVERITY()                          
                          
        RAISERROR(@ErrMsg, @ErrSeverity, 1)                          
    END CATCH

