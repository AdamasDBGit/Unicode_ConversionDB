
CREATE PROCEDURE [dbo].[uspInsertTimeTableDetails_bkp] 
    (  
      @sTimeTableXML XML = NULL       
    )  
AS   
    BEGIN TRY                    
        SET NOCOUNT OFF ;                    
     
        DECLARE @iTimeTableID INT    
        DECLARE @S_Batch_Name nvarchar(max)  
        DECLARE @S_DateTime nvarchar(max)  
        DECLARE @Dt_DateTime DATETIME  
        DECLARE @I_timeSlot_id INT  
        DECLARE @Dt_StartTime DATETIME  
  DECLARE @Dt_EndTime DATETIME  
  DECLARE @S_StartTime nvarchar(max)  
  DECLARE @S_EndTime nvarchar(max)  
    
        BEGIN TRANSACTION                    
           
         -- Create Temporary Table To TimeTable Parent Information              
        CREATE TABLE #tempTimeTable  
            (  
              I_TimeTable_ID INT ,  
              I_Center_ID INT ,  
              Dt_Schedule_Date DATETIME ,  
              I_TimeSlot_ID INT ,  
              I_Batch_ID INT ,  
              I_Room_ID INT ,  
              I_Skill_ID INT ,  
              S_EmployeeId nvarchar(max) ,  
              S_Remarks nvarchar(max) ,  
              S_SessionFullName nvarchar(max) ,  
              I_Session_ID INT ,  
              S_SessionName nvarchar(max) ,  
              S_SessionTopic nvarchar(max) ,  
              I_ModuleId INT ,  
              I_TermId INT ,  
              Dt_ActualDate DATETIME ,  
              I_Is_Complete INT ,  
              I_Status INT ,  
              S_Crtd_By nvarchar(max) ,  
              Dt_Crtd_On DATETIME  
            )    
     
   -- Insert Values into Temporary Table              
        INSERT  INTO #tempTimeTable  
                SELECT  T.c.value('@I_TimeTableId', 'int') ,  
                        T.c.value('@I_CenterId', 'int') ,  
                        T.c.value('@DT_ScheduleDate', 'datetime') ,  
                        T.c.value('@T_TimeSlotId', 'int') ,  
                        CASE WHEN T.c.value('@I_BatchID', 'INT') = '' THEN NULL ELSE T.c.value('@I_BatchID', 'INT') END,  
                        T.c.value('@I_RoomID', 'int') ,  
                        CASE WHEN T.c.value('@I_SkillID', 'INT') = 0 THEN NULL ELSE T.c.value('@I_SkillID', 'INT') END,  
                        CASE WHEN T.c.value('@S_EmployeeId', 'nvarchar(max)') = '' THEN NULL ELSE T.c.value('@S_EmployeeId', 'nvarchar(max)') END,                          
                        CASE WHEN T.c.value('@S_Remarks', 'nvarchar(max)') = '' THEN NULL ELSE T.c.value('@S_Remarks', 'nvarchar(max)') END,  
                        CASE WHEN T.c.value('@S_SessionFullName', 'nvarchar(max)') = '' THEN NULL ELSE T.c.value('@S_SessionFullName', 'nvarchar(max)') END,                         
                        CASE WHEN T.c.value('@I_SessionID', 'INT') = '' THEN NULL ELSE T.c.value('@I_SessionID', 'INT') END,  
                        CASE WHEN T.c.value('@S_SessionName', 'nvarchar(max)') = '' THEN NULL ELSE T.c.value('@S_SessionName', 'nvarchar(max)') END,  
                        CASE WHEN T.c.value('@S_SessionTopic', 'nvarchar(max)') = '' THEN NULL ELSE T.c.value('@S_SessionTopic', 'nvarchar(max)') END,   
                        CASE WHEN T.c.value('@I_ModuleId', 'INT') = '' THEN NULL ELSE T.c.value('@I_ModuleId', 'INT') END,   
                        CASE WHEN T.c.value('@I_TermId', 'INT') = '' THEN NULL ELSE T.c.value('@I_TermId', 'INT') END,  
                        CASE WHEN T.c.value('@Dt_ActualDate', 'datetime') = '' THEN NULL ELSE T.c.value('@Dt_ActualDate', 'datetime') END,  
                        CASE WHEN T.c.value('@I_Is_Complete', 'int') = 0 THEN 0 ELSE T.c.value('@I_Is_Complete', 'int') END,  
                        T.c.value('@S_Status', 'int') ,  
                        T.c.value('@S_CrtdBy', 'nvarchar(max)') ,  
                        T.c.value('@Dt_CrtdOn', 'datetime')  
                FROM    @sTimeTableXML.nodes('/Root/TimeTable') T ( c )    
     
   -- defination of the variables of the TimeTable parent              
        DECLARE @ipI_TimeTableId INT   
        DECLARE @ipI_Center_ID INT              
        DECLARE @ipDt_Schedule_Date DATETIME              
        DECLARE @ipI_TimeSlot_ID INT              
        DECLARE @ipI_Batch_ID INT              
        DECLARE @ipI_Room_ID INT              
        DECLARE @ipI_Skill_ID INT              
        DECLARE @ipS_EmployeeId nvarchar(max)    
        DECLARE @ipS_Remarks nvarchar(max)   
        DECLARE @ipI_Session_ID INT   
        DECLARE @ipS_SessionFullName nvarchar(max)  
        DECLARE @ipS_SessionName nvarchar(max)  
        DECLARE @ipS_SessionTopic nvarchar(max)  
        DECLARE @ipI_ModuleId INT  
        DECLARE @ipI_TermId INT  
        DECLARE @ipDt_ActualDate DATETIME  
        DECLARE @ipI_Is_Complete INT           
        DECLARE @ipI_Status INT                        
        DECLARE @ipS_Crtd_By nvarchar(max)              
        DECLARE @ipDt_Crtd_On DATETIME           
                       
   -- declare cursor for TimeTable details              
        DECLARE UPLOADTIMETABLEPARENT_CURSOR CURSOR FOR               
        SELECT   
        I_TimeTable_ID,             
        I_Center_ID,    
        Dt_Schedule_Date,    
        I_TimeSlot_ID,    
        I_Batch_ID,    
        I_Room_ID,    
        I_Skill_ID,    
        S_EmployeeId,  
        S_Remarks,   
        I_Session_ID,   
        S_SessionFullName,  
        S_SessionName,  
        S_SessionTopic,  
        I_ModuleId,  
        I_TermId,  
        Dt_ActualDate,  
        I_Is_Complete,  
        I_Status,    
        S_Crtd_By,    
        Dt_Crtd_On             
        FROM #tempTimeTable              
              
        OPEN UPLOADTIMETABLEPARENT_CURSOR               
        FETCH NEXT FROM UPLOADTIMETABLEPARENT_CURSOR               
   INTO @ipI_TimeTableId,  
   @ipI_Center_ID,              
   @ipDt_Schedule_Date,              
   @ipI_TimeSlot_ID,              
   @ipI_Batch_ID,              
   @ipI_Room_ID,              
   @ipI_Skill_ID,              
   @ipS_EmployeeId,   
   @ipS_Remarks,  
   @ipI_Session_ID,  
   @ipS_SessionFullName,  
   @ipS_SessionName,  
   @ipS_SessionTopic,  
   @ipI_ModuleId,  
   @ipI_TermId,  
   @ipDt_ActualDate,  
   @ipI_Is_Complete,        
   @ipI_Status,                        
   @ipS_Crtd_By,              
   @ipDt_Crtd_On     
     
        WHILE @@FETCH_STATUS = 0   
            BEGIN               
       
                IF(SELECT COUNT(*) FROM T_TimeTable_Master WHERE I_Center_ID=@ipI_Center_ID and I_Batch_ID=@ipI_Batch_ID and I_Session_ID=@ipI_Session_ID and I_Status=1 and  I_TimeTable_ID not in(@ipI_TimeTableId)) = 0  
                BEGIN   
     IF ( SELECT COUNT(*)  
       FROM   T_TimeTable_Master  
       WHERE  I_TimeTable_ID = @ipI_TimeTableId  
        ) > 0   
      BEGIN    
       DELETE  FROM dbo.T_TimeTable_Faculty_Map  
       WHERE   I_TimeTable_ID = @ipI_TimeTableId  
         
       SELECT @Dt_StartTime = Dt_Start_Time,@Dt_EndTime=Dt_End_Time FROM T_Center_Timeslot_Master          WHERE I_TimeSlot_ID=@ipI_TimeSlot_ID  
         
       IF ( SELECT COUNT(*)  
         FROM   dbo.T_TimeTable_Master AS TTM  
          INNER JOIN dbo.T_TimeTable_Faculty_Map AS TTFM ON TTM.I_TimeTable_ID = TTFM.I_TimeTable_ID  
         WHERE  TTM.I_TimeSlot_ID = @ipI_TimeSlot_ID  
          AND TTM.I_Center_ID = @ipI_Center_ID  
          AND TTM.Dt_Schedule_Date = @ipDt_Schedule_Date 
          AND TTM.I_Status=1 
          AND TTFM.I_Employee_ID IN (  
          SELECT  CAST(VAL AS INT)  
          FROM    fnString2Rows(@ipS_EmployeeId, ',') )  
          ) > 0   
       BEGIN    
        RAISERROR('The faculty has already been assigned for this time slot.',11,1)    
       END    
       ELSE IF (SELECT count(*) FROM dbo.T_TimeTable_Master AS TTM   
        inner join T_TimeTable_Faculty_Map AS TTFM on TTFM.I_TimeTable_ID = TTM.I_TimeTable_ID AND TTM.I_Status=1   
        inner join T_Center_Timeslot_Master TCTM on TCTM.I_TimeSlot_ID = TTM.I_TimeSlot_ID  
        inner join T_Employee_Dtls TED on TED.I_Employee_ID = TTFM.I_Employee_ID  
        WHERE  TTFM.I_Employee_ID IN (  
        SELECT  CAST(VAL AS INT)  
        FROM    fnString2Rows(@ipS_EmployeeId, ',') )  
        AND TED.B_IsRoamingFaculty = 1  
        and(TCTM.Dt_Start_Time between  @Dt_StartTime and @Dt_EndTime  
        or TCTM.Dt_End_Time between  @Dt_StartTime and @Dt_EndTime)  
        and TTM.Dt_Schedule_Date = @ipDt_Schedule_Date  
       ) > 0  
       BEGIN  
        RAISERROR('The faculty has already been assigned for this time slot.',11,1)    
       END  
       ELSE   
        BEGIN    
         
         UPDATE  dbo.T_TimeTable_Master  
         SET     I_Batch_ID = @ipI_Batch_ID ,  
           I_Skill_ID = @ipI_Skill_ID ,  
           S_Remarks = @ipS_Remarks ,  
           I_Session_ID = @ipI_Session_ID ,  
           I_Term_ID = @ipI_TermId ,   
           I_Module_ID = @ipI_ModuleId ,  
           S_Session_Name = @ipS_SessionName ,  
           S_Session_Topic = @ipS_SessionTopic ,  
           Dt_Actual_Date = @ipDt_ActualDate ,  
           I_Is_Complete = @ipI_Is_Complete ,  
           I_Status =@ipI_Status   
         WHERE   I_TimeTable_ID = @ipI_TimeTableId  
                                   
         IF(@ipS_EmployeeId is not null)  
         BEGIN  
          INSERT  INTO dbo.T_TimeTable_Faculty_Map  
            ( I_TimeTable_ID ,  
              I_Employee_ID,
              B_Is_Actual   
            )  
            SELECT  @ipI_TimeTableId ,  
              CAST(Val AS INT),0  
            FROM    dbo.fnString2Rows(@ipS_EmployeeId,  
                   ',') AS FSR  
         END  
        END                               
      END    
     ELSE   
      BEGIN                                 
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
       VALUES  ( @ipI_Center_ID ,  
           @ipDt_Schedule_Date ,  
           @ipI_TimeSlot_ID ,  
           @ipI_Batch_ID ,  
           @ipI_Room_ID ,  
           @ipI_Skill_ID ,  
           @ipI_Status ,  
           @ipS_Crtd_By ,  
           @ipDt_Crtd_On ,  
           @ipS_Remarks ,  
           @ipI_Session_ID ,   
           @ipI_TermId ,   
           @ipI_ModuleId ,  
           @ipS_SessionName ,  
           @ipS_SessionTopic ,  
           null ,  
           0  
         )              
                  
       SET @iTimeTableID = SCOPE_IDENTITY()     
         
       SELECT @Dt_StartTime = Dt_Start_Time,@Dt_EndTime=Dt_End_Time FROM T_Center_Timeslot_Master   
       WHERE I_TimeSlot_ID=@ipI_TimeSlot_ID  
         
       IF ( SELECT COUNT(*)  
         FROM   dbo.T_TimeTable_Master AS TTM  
          INNER JOIN dbo.T_TimeTable_Faculty_Map AS TTFM ON TTM.I_TimeTable_ID = TTFM.I_TimeTable_ID AND I_Status=1 
         WHERE  TTM.I_TimeSlot_ID = @ipI_TimeSlot_ID  
          AND TTM.I_Center_ID = @ipI_Center_ID  
          AND TTM.Dt_Schedule_Date = @ipDt_Schedule_Date  
          AND TTFM.I_Employee_ID IN (  
          SELECT  CAST(VAL AS INT)  
          FROM    fnString2Rows(@ipS_EmployeeId, ',') )  
          ) > 0   
       BEGIN  
        RAISERROR('The faculty has already been assigned for this time slot.',11,1)    
       END  
       ELSE IF (SELECT count(*) FROM dbo.T_TimeTable_Master AS TTM   
        inner join T_TimeTable_Faculty_Map AS TTFM on TTFM.I_TimeTable_ID = TTM.I_TimeTable_ID AND TTM.I_Status=1  
        inner join T_Center_Timeslot_Master TCTM on TCTM.I_TimeSlot_ID = TTM.I_TimeSlot_ID  
        inner join T_Employee_Dtls TED on TED.I_Employee_ID = TTFM.I_Employee_ID  
        WHERE  TTFM.I_Employee_ID IN (  
        SELECT  CAST(VAL AS INT)  
        FROM    fnString2Rows(@ipS_EmployeeId, ',') )  
        AND TED.B_IsRoamingFaculty = 1  
        and(TCTM.Dt_Start_Time between  @Dt_StartTime and @Dt_EndTime  
        or TCTM.Dt_End_Time between  @Dt_StartTime and @Dt_EndTime)  
        and TTM.Dt_Schedule_Date = @ipDt_Schedule_Date  
       ) > 0  
       BEGIN  
        RAISERROR('The faculty has already been assigned for this time slot.',11,1)    
       END  
       ELSE   
        BEGIN  
         INSERT  INTO dbo.T_TimeTable_Faculty_Map  
           ( I_TimeTable_ID ,  
             I_Employee_ID,
             B_Is_Actual   
           )  
           SELECT  @iTimeTableID ,  
             CAST(Val AS INT),0  
           FROM    dbo.fnString2Rows(@ipS_EmployeeId,  
                  ',') AS FSR    
        END  
     END    
                 END  
                 ELSE  
                 BEGIN  
      SELECT  @S_Batch_Name = S_Batch_Name FROM dbo.T_Student_Batch_master  
      WHERE   I_Batch_ID = @ipI_Batch_ID  
      SELECT  @Dt_DateTime = Dt_Schedule_Date,@I_timeSlot_id=I_TimeSlot_ID FROM T_TimeTable_Master   
      WHERE I_Center_ID=@ipI_Center_ID and I_Batch_ID=@ipI_Batch_ID and I_Session_ID=@ipI_Session_ID and I_Status=1 and I_TimeTable_ID not in(@ipI_TimeTableId)  
      SELECT @S_DateTime =  left(CONVERT(VARCHAR, @Dt_DateTime, 120), 10)  
      SELECT @Dt_StartTime = Dt_Start_Time,@Dt_EndTime=Dt_End_Time FROM T_Center_Timeslot_Master   
      WHERE I_TimeSlot_ID=@I_timeSlot_id  
      SELECT @S_StartTime =  right(CONVERT(VARCHAR, @Dt_StartTime, 120), 8)  
      SELECT @S_EndTime =  right(CONVERT(VARCHAR, @Dt_EndTime, 120), 8)  
      RAISERROR('The session %s for batch %s is already allocated on %s at timeslot %s to %s.',11,1,@ipS_SessionFullName,@S_Batch_Name,@S_DateTime,@S_StartTime,@S_EndTime)   
    END  
         
     -- FETCH NEXT FOR INVOICE PARENT CURSOR              
    FETCH NEXT FROM UPLOADTIMETABLEPARENT_CURSOR               
    INTO @ipI_TimeTableId,  
    @ipI_Center_ID,              
    @ipDt_Schedule_Date,              
    @ipI_TimeSlot_ID,              
    @ipI_Batch_ID,              
    @ipI_Room_ID,              
    @ipI_Skill_ID,              
    @ipS_EmployeeId,    
    @ipS_Remarks,   
    @ipI_Session_ID,  
    @ipS_SessionFullName,   
    @ipS_SessionName,  
    @ipS_SessionTopic,  
    @ipI_ModuleId,  
    @ipI_TermId,  
    @ipDt_ActualDate,  
    @ipI_Is_Complete,                      
    @ipI_Status,                        
    @ipS_Crtd_By,              
    @ipDt_Crtd_On             
            END      
        CLOSE UPLOADTIMETABLEPARENT_CURSOR               
        DEALLOCATE UPLOADTIMETABLEPARENT_CURSOR     
        
        COMMIT TRANSACTION    
                
    END TRY                    
    BEGIN CATCH                    
 --Error occurred:                      
        ROLLBACK TRANSACTION                     
        DECLARE @ErrMsg Nnvarchar(max) ,  
            @ErrSeverity INT                    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()                    
                    
        RAISERROR(@ErrMsg, @ErrSeverity, 1)                    
    END CATCH
