CREATE PROCEDURE [dbo].[uspSaveTimeTableBatchSchedule]
    (
      @sTimeTableXML XML = NULL       
    )
AS 
    BEGIN TRY                    
        SET NOCOUNT OFF ;                    
     
        DECLARE @iTimeTableID INT    
        DECLARE @Dt_StartTime DATETIME  
        DECLARE @Dt_EndTime DATETIME  
    
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
              I_Session_ID INT ,
              S_SessionName nvarchar(max) ,
              S_SessionTopic nvarchar(max) ,
              I_ModuleId INT ,
              I_TermId INT ,
              Dt_ActualDate DATETIME ,
              I_Is_Complete INT ,
              I_Status INT ,
              S_Crtd_By nvarchar(max) ,
              Dt_Crtd_On DATETIME ,
              I_SessionTopic_Completed_Status_ID INT,
              I_ClassTest_Status_ID INT,
              I_Sub_Batch_ID INT
              
            )    
     
   -- Insert Values into Temporary Table              
        INSERT  INTO #tempTimeTable
                SELECT  T.c.value('@I_TimeTableId', 'int') ,
                        T.c.value('@I_CenterId', 'int') ,
                        T.c.value('@DT_ScheduleDate', 'datetime') , 
                     --   CONVERT(DATETIME, T.c.value('@DT_ScheduleDate','varchar(50)'), 103) , 
                        T.c.value('@T_TimeSlotId', 'int') ,
                        T.c.value('@I_BatchID', 'int') ,
                        T.c.value('@I_RoomID', 'int') ,
                        CASE WHEN T.c.value('@I_SkillID', 'INT') = 0 THEN NULL
                             ELSE T.c.value('@I_SkillID', 'INT')
                        END ,
                        T.c.value('@S_EmployeeId', 'nvarchar(max)') ,
                        CASE WHEN T.c.value('@S_Remarks', 'nvarchar(max)') = ''
                             THEN NULL
                             ELSE T.c.value('@S_Remarks', 'nvarchar(max)')
                        END ,
                        CASE WHEN T.c.value('@I_SessionID', 'int') = '0'
                             THEN NULL
                             ELSE T.c.value('@I_SessionID', 'int')
                        END ,
                        T.c.value('@S_SessionName', 'nvarchar(max)') ,
                        CASE WHEN T.c.value('@S_SessionTopic', 'nvarchar(max)') = ''
                             THEN NULL
                             ELSE T.c.value('@S_SessionTopic', 'nvarchar(max)')
                        END ,
                        T.c.value('@I_ModuleId', 'INT') ,
                        T.c.value('@I_TermId', 'INT') ,
                        CASE WHEN T.c.value('@Dt_ActualDate', 'datetime') = ''
                             THEN NULL
                             ELSE T.c.value('@Dt_ActualDate', 'datetime')
                        END ,  
                      --  CASE WHEN  CONVERT(DATETIME, T.c.value('@Dt_ActualDate','varchar(50)'), 103)='' THEN NULL ELSE    CONVERT(DATETIME, T.c.value('@Dt_ActualDate', 'varchar(50)'), 103) END,
                        CASE WHEN T.c.value('@I_Is_Complete', 'int') = ''
                             THEN 0
                             ELSE T.c.value('@I_Is_Complete', 'int')
                        END ,
                        T.c.value('@S_Status', 'int') ,
                        T.c.value('@S_CrtdBy', 'nvarchar(max)') ,
                        T.c.value('@Dt_CrtdOn', 'datetime') ,
                        T.c.value('@I_SessionTopic_Completed_Status_ID','INT'),
                        T.c.value('@I_ClassTest_Status_ID','INT'),
                       -- CONVERT(DATETIME, T.c.value('@Dt_Crtd_On','varchar(50)'), 103) ,
                        CASE WHEN T.c.value('@I_Sub_Batch_ID', 'int') = ''
                             THEN NULL
                             ELSE T.c.value('@I_Sub_Batch_ID', 'int')
                        END
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
        DECLARE @ipS_SessionName nvarchar(max)  
        DECLARE @ipS_SessionTopic nvarchar(max)  
        DECLARE @ipI_ModuleId INT  
        DECLARE @ipI_TermId INT  
        DECLARE @ipDt_ActualDate DATETIME  
        DECLARE @ipI_Is_Complete INT           
        DECLARE @ipI_Status INT                        
        DECLARE @ipS_Crtd_By nvarchar(max)              
        DECLARE @ipDt_Crtd_On DATETIME   
        DECLARE @ipI_Sub_Batch_ID INT 
        DECLARE @ipI_SessionTopic_Completed_Status_ID INT 
        DECLARE @ipI_ClassTest_Status_ID INT      
                       
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
        S_SessionName,  
        S_SessionTopic,  
        I_ModuleId,  
        I_TermId,  
        Dt_ActualDate,  
        I_Is_Complete,  
        I_Status,    
        S_Crtd_By,    
        Dt_Crtd_On,
        I_Sub_Batch_ID,
        I_SessionTopic_Completed_Status_ID,
        I_ClassTest_Status_ID           
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
   @ipS_SessionName,  
   @ipS_SessionTopic,  
   @ipI_ModuleId,  
   @ipI_TermId,  
   @ipDt_ActualDate,  
   @ipI_Is_Complete,        
   @ipI_Status,                        
   @ipS_Crtd_By,              
   @ipDt_Crtd_On,
   @ipI_Sub_Batch_ID,
   @ipI_SessionTopic_Completed_Status_ID,
   @ipI_ClassTest_Status_ID    
     
        WHILE @@FETCH_STATUS = 0 
            BEGIN               
       
                IF ( SELECT COUNT(*)
                     FROM   T_TimeTable_Master T
                     WHERE  I_Center_ID = @ipI_Center_ID
                            AND I_TimeSlot_ID = @ipI_TimeSlot_ID
                            AND Dt_Schedule_Date = @ipDt_Schedule_Date
                            AND I_Room_ID = @ipI_Room_ID
                            AND I_Batch_ID=@ipI_Batch_ID
                            AND ISNULL(I_Sub_Batch_ID,0)=ISNULL(@ipI_Sub_Batch_ID,0)
                            AND I_Status = 1
                            AND I_TimeTable_ID NOT IN ( @ipI_TimeTableId )
                   ) = 0 
                    BEGIN   
                        IF ( SELECT COUNT(*)
                             FROM   T_TimeTable_Master
                             WHERE  I_TimeTable_ID = @ipI_TimeTableId
                           ) > 0 
                            BEGIN    
                                DELETE  FROM dbo.T_TimeTable_Faculty_Map
                                WHERE   I_TimeTable_ID = @ipI_TimeTableId
                                        AND B_Is_Actual = 1
         
                                SELECT  @Dt_StartTime = Dt_Start_Time ,
                                        @Dt_EndTime = Dt_End_Time
                                FROM    T_Center_Timeslot_Master
                                WHERE   I_TimeSlot_ID = @ipI_TimeSlot_ID  
         
                                IF ( SELECT COUNT(*)
                                     FROM   dbo.T_TimeTable_Master AS TTM
                                            INNER JOIN dbo.T_TimeTable_Faculty_Map
                                            AS TTFM ON TTM.I_TimeTable_ID = TTFM.I_TimeTable_ID
                                                       AND TTM.I_Status = 1
                                     WHERE  TTM.I_TimeSlot_ID = @ipI_TimeSlot_ID
                                            AND TTM.I_Center_ID = @ipI_Center_ID
                                            AND TTM.Dt_Schedule_Date = @ipDt_Schedule_Date
                                            AND TTFM.B_Is_Actual = 1
                                            AND TTM.I_Room_ID<>@ipI_Room_ID
                                            AND TTFM.I_Employee_ID IN (
                                            SELECT  CAST(VAL AS INT)
                                            FROM    fnString2Rows(@ipS_EmployeeId,
                                                              ',') )
                                   ) > 0 
                                    BEGIN    
                                        RAISERROR('The faculty has already been assigned for this time slot in different room.',11,1)    
                                    END    
                                ELSE 
                                    IF ( SELECT COUNT(*)
                                         FROM   dbo.T_TimeTable_Master AS TTM
                                                INNER JOIN T_TimeTable_Faculty_Map
                                                AS TTFM ON TTFM.I_TimeTable_ID = TTM.I_TimeTable_ID
                                                           AND TTM.I_Status = 1
                                                INNER JOIN T_Center_Timeslot_Master TCTM ON TCTM.I_TimeSlot_ID = TTM.I_TimeSlot_ID
                                                INNER JOIN T_Employee_Dtls TED ON TED.I_Employee_ID = TTFM.I_Employee_ID
                                         WHERE  TTFM.I_Employee_ID IN (
                                                SELECT  CAST(VAL AS INT)
                                                FROM    fnString2Rows(@ipS_EmployeeId,
                                                              ',') )
                                                AND TED.B_IsRoamingFaculty = 1
                                                AND TTFM.B_Is_Actual = 1
                                                AND TTM.I_Room_ID<>@ipI_Room_ID
                                                AND ( TCTM.Dt_Start_Time BETWEEN @Dt_StartTime
                                                              AND
                                                              @Dt_EndTime
                                                      OR TCTM.Dt_End_Time BETWEEN @Dt_StartTime
                                                              AND
                                                              @Dt_EndTime
                                                    )
                                                AND TTM.Dt_Schedule_Date = @ipDt_Schedule_Date
                                       ) > 0 
                                        BEGIN  
                                            RAISERROR('The faculty has already been assigned for this time slot in different room.',11,1)    
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
                                                    I_Is_Complete = @ipI_Is_Complete,
                                                    I_Sub_Batch_ID=@ipI_Sub_Batch_ID,
                                                    I_SessionTopic_Completed_Status_ID=@ipI_SessionTopic_Completed_Status_ID,
                                                    I_ClassType=@ipI_ClassTest_Status_ID
           -- ,										
          -- I_Sub_Batch_ID=@ipI_Sub_Batch_ID 
                                            WHERE   I_TimeTable_ID = @ipI_TimeTableId  
         
         --DELETE FROM dbo.T_TimeTable_Faculty_Map WHERE I_TimeTable_ID = @ipI_TimeTableId AND B_Is_Actual = 1
                                   
                                            INSERT  INTO dbo.T_TimeTable_Faculty_Map
                                                    ( I_TimeTable_ID ,
                                                      I_Employee_ID ,
                                                      B_Is_Actual   
                                                    )
                                                    SELECT  @ipI_TimeTableId ,
                                                            CAST(Val AS INT) ,
                                                            1
                                                    FROM    dbo.fnString2Rows(@ipS_EmployeeId,
                                                              ',') AS FSR  
                                        END  
                                SET @iTimeTableID = @ipI_TimeTableId                              
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
                                          I_Is_Complete ,
                                          I_Sub_Batch_ID,
                                          I_SessionTopic_Completed_Status_ID,
                                          I_ClassType        
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
           --@ipDt_Crtd_On, 
                                          @ipS_Remarks ,
                                          @ipI_Session_ID ,
                                          @ipI_TermId ,
                                          @ipI_ModuleId ,
                                          @ipS_SessionName ,
                                          @ipS_SessionTopic ,
                                          NULL ,
                                          0 ,
                                          @ipI_Sub_Batch_ID,
                                          @ipI_SessionTopic_Completed_Status_ID,
                                          @ipI_ClassTest_Status_ID  
                                        )              
                  
                                SET @iTimeTableID = SCOPE_IDENTITY()     
         
                                SELECT  @Dt_StartTime = Dt_Start_Time ,
                                        @Dt_EndTime = Dt_End_Time
                                FROM    T_Center_Timeslot_Master
                                WHERE   I_TimeSlot_ID = @ipI_TimeSlot_ID  
         
                                IF ( SELECT COUNT(*)
                                     FROM   dbo.T_TimeTable_Master AS TTM
                                            INNER JOIN dbo.T_TimeTable_Faculty_Map
                                            AS TTFM ON TTM.I_TimeTable_ID = TTFM.I_TimeTable_ID
                                                       AND TTM.I_Status = 1
                                     WHERE  TTM.I_TimeSlot_ID = @ipI_TimeSlot_ID
                                            AND TTM.I_Center_ID = @ipI_Center_ID
                                            AND TTM.Dt_Schedule_Date = @ipDt_Schedule_Date
                                            AND TTFM.B_Is_Actual = 1
                                            AND TTM.I_Room_ID<>@ipI_Room_ID
                                            AND TTFM.I_Employee_ID IN (
                                            SELECT  CAST(VAL AS INT)
                                            FROM    fnString2Rows(@ipS_EmployeeId,
                                                              ',') )
                                   ) > 0 
                                    BEGIN  
                                        RAISERROR('The faculty has already been assigned for this time slot in different room.',11,1)    
                                    END  
                                ELSE 
                                    IF ( SELECT COUNT(*)
                                         FROM   dbo.T_TimeTable_Master AS TTM
                                                INNER JOIN T_TimeTable_Faculty_Map
                                                AS TTFM ON TTFM.I_TimeTable_ID = TTM.I_TimeTable_ID
                                                           AND TTM.I_Status = 1
                                                INNER JOIN T_Center_Timeslot_Master TCTM ON TCTM.I_TimeSlot_ID = TTM.I_TimeSlot_ID
                                                INNER JOIN T_Employee_Dtls TED ON TED.I_Employee_ID = TTFM.I_Employee_ID
                                         WHERE  TTFM.I_Employee_ID IN (
                                                SELECT  CAST(VAL AS INT)
                                                FROM    fnString2Rows(@ipS_EmployeeId,
                                                              ',') )
                                                AND TED.B_IsRoamingFaculty = 1
                                                AND TTFM.B_Is_Actual = 1
                                                AND TTM.I_Room_ID<>@ipI_Room_ID
                                                AND ( TCTM.Dt_Start_Time BETWEEN @Dt_StartTime
                                                              AND
                                                              @Dt_EndTime
                                                      OR TCTM.Dt_End_Time BETWEEN @Dt_StartTime
                                                              AND
                                                              @Dt_EndTime
                                                    )
                                                AND TTM.Dt_Schedule_Date = @ipDt_Schedule_Date
                                       ) > 0 
                                        BEGIN  
                                            RAISERROR('The faculty has already been assigned for this time slot in different room.',11,1)    
                                        END  
                                    ELSE 
                                        BEGIN  
                                            INSERT  INTO dbo.T_TimeTable_Faculty_Map
                                                    ( I_TimeTable_ID ,
                                                      I_Employee_ID ,
                                                      B_Is_Actual   
                                                    )
                                                    SELECT  @iTimeTableID ,
                                                            CAST(Val AS INT) ,
                                                            1
                                                    FROM    dbo.fnString2Rows(@ipS_EmployeeId,
                                                              ',') AS FSR    
                                        END  
                            END    
                    END  
                ELSE 
                    BEGIN  
                        RAISERROR('The room has already been assigned for this time slot for different batch and sub batch.',11,1)    
                    END  
                SELECT  @iTimeTableID  
         
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
    @ipS_SessionName,  
    @ipS_SessionTopic,  
    @ipI_ModuleId,  
    @ipI_TermId,  
    @ipDt_ActualDate,  
    @ipI_Is_Complete,                      
    @ipI_Status,                        
    @ipS_Crtd_By,              
    @ipDt_Crtd_On,
    @ipI_Sub_Batch_ID,
    @ipI_SessionTopic_Completed_Status_ID,
    @ipI_ClassTest_Status_ID
                 
            END      
        CLOSE UPLOADTIMETABLEPARENT_CURSOR               
        DEALLOCATE UPLOADTIMETABLEPARENT_CURSOR     
        
        COMMIT TRANSACTION    
                
    END TRY                    
    BEGIN CATCH                    
 --Error occurred:                      
        ROLLBACK TRANSACTION                     
        DECLARE @ErrMsg NVARCHAR(max) ,
            @ErrSeverity INT                    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()                    
                    
        RAISERROR(@ErrMsg, @ErrSeverity, 1)                    
    END CATCH

