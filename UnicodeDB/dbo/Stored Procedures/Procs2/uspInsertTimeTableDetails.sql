
CREATE PROCEDURE [dbo].[uspInsertTimeTableDetails]
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
              Dt_Crtd_On DATETIME ,
              I_Replan INT ,
              I_Sub_Batch_ID INT NULL
            )    
     
   -- Insert Values into Temporary Table              
        INSERT  INTO #tempTimeTable
                SELECT  T.c.value('@I_TimeTableId', 'int') ,
                        T.c.value('@I_CenterId', 'int') ,
                        T.c.value('@DT_ScheduleDate', 'datetime') ,
                        T.c.value('@T_TimeSlotId', 'int') ,
                        CASE WHEN T.c.value('@I_BatchID', 'INT') = ''
                             THEN NULL
                             ELSE T.c.value('@I_BatchID', 'INT')
                        END ,
                        T.c.value('@I_RoomID', 'int') ,
                        CASE WHEN T.c.value('@I_SkillID', 'INT') = 0 THEN NULL
                             ELSE T.c.value('@I_SkillID', 'INT')
                        END ,
                        CASE WHEN T.c.value('@S_EmployeeId', 'nvarchar(max)') = ''
                             THEN NULL
                             ELSE T.c.value('@S_EmployeeId', 'nvarchar(max)')
                        END ,
                        CASE WHEN T.c.value('@S_Remarks', 'nvarchar(max)') = ''
                             THEN NULL
                             ELSE T.c.value('@S_Remarks', 'nvarchar(max)')
                        END ,
                        CASE WHEN T.c.value('@S_SessionFullName',
                                            'nvarchar(max)') = '' THEN NULL
                             ELSE T.c.value('@S_SessionFullName',
                                            'nvarchar(max)')
                        END ,
                        CASE WHEN T.c.value('@I_SessionID', 'INT') = ''
                             THEN NULL
                             ELSE T.c.value('@I_SessionID', 'INT')
                        END ,
                        CASE WHEN T.c.value('@S_SessionName', 'nvarchar(max)') = ''
                             THEN NULL
                             ELSE T.c.value('@S_SessionName', 'nvarchar(max)')
                        END ,
                        CASE WHEN T.c.value('@S_SessionTopic', 'nvarchar(max)') = ''
                             THEN NULL
                             ELSE T.c.value('@S_SessionTopic', 'nvarchar(max)')
                        END ,
                        CASE WHEN T.c.value('@I_ModuleId', 'INT') = ''
                             THEN NULL
                             ELSE T.c.value('@I_ModuleId', 'INT')
                        END ,
                        CASE WHEN T.c.value('@I_TermId', 'INT') = '' THEN NULL
                             ELSE T.c.value('@I_TermId', 'INT')
                        END ,
                        CASE WHEN T.c.value('@Dt_ActualDate', 'datetime') = ''
                             THEN NULL
                             ELSE T.c.value('@Dt_ActualDate', 'datetime')
                        END ,
                        CASE WHEN T.c.value('@I_Is_Complete', 'int') = 0
                             THEN 0
                             ELSE T.c.value('@I_Is_Complete', 'int')
                        END ,
                        T.c.value('@S_Status', 'int') ,
                        T.c.value('@S_CrtdBy', 'nvarchar(max)') ,
                        T.c.value('@Dt_CrtdOn', 'datetime') ,
                        T.c.value('@I_Replan', 'int') ,
                        CASE WHEN T.c.value('@I_Sub_Batch_ID', 'nvarchar(max)') = ''
                             THEN NULL
                             ELSE T.c.value('@I_Sub_Batch_ID', 'INT')
                        END
                FROM    @sTimeTableXML.nodes('/Root/TimeTable') T ( c )  
        
        
        IF EXISTS ( SELECT  T.Dt_Schedule_Date ,
                            T.I_Center_ID ,
                            T.I_TimeSlot_ID ,
                            fm.I_Employee_ID
                    FROM    #tempTimeTable T
                            INNER JOIN dbo.T_TimeTable_Master TM WITH ( NOLOCK ) ON T.Dt_Schedule_Date = TM.Dt_Schedule_Date
                                                              AND T.I_Center_ID = TM.I_Center_ID
                                                              --AND T.I_Room_ID = TM.I_Room_ID
                                                              AND T.I_TimeSlot_ID = TM.I_TimeSlot_ID
                            INNER JOIN dbo.T_TimeTable_Faculty_Map FM ON FM.I_TimeTable_ID = TM.I_TimeTable_ID
                                                              AND FM.B_Is_Actual = 0
                                                              AND fm.I_Employee_ID IN (
                                                              SELECT
                                                              CAST(VAL AS INT)
                                                              FROM
                                                              fnString2Rows(T.S_EmployeeId,
                                                              ',') )
                            INNER JOIN dbo.T_Room_Master R WITH ( NOLOCK ) ON TM.I_Room_ID = R.I_Room_ID
                            LEFT JOIN #tempTimeTable TT ON tt.I_TimeTable_ID = TM.I_TimeTable_ID
                    WHERE   TM.I_Status = 1
                            AND tt.I_TimeTable_ID IS NULL
                    GROUP BY T.Dt_Schedule_Date ,
                            T.I_Center_ID ,
                            T.I_TimeSlot_ID ,
                            fm.I_Employee_ID
                    HAVING  COUNT(DISTINCT T.I_Room_ID) > 1 )
            OR EXISTS ( SELECT  
								--T.I_Room_ID ,
                                T.I_Center_ID ,
                                T.I_TimeSlot_ID ,
                                T.Dt_Schedule_Date ,
                                T.S_EmployeeId
                        FROM    #tempTimeTable T
                                INNER JOIN dbo.T_Room_Master R WITH ( NOLOCK ) ON T.I_Room_ID = R.I_Room_ID
                        GROUP BY 
								--T.I_Room_ID ,
                                T.I_Center_ID ,
                                T.I_TimeSlot_ID ,
                                T.Dt_Schedule_Date ,
                                T.S_EmployeeId
                        HAVING  COUNT(DISTINCT T.I_Room_ID) > 1 ) 
            BEGIN
                DECLARE @Duproomno nvarchar(max)
                        
                SET @Duproomno = SUBSTRING(( SELECT ','
                                                    + Dup_room.EmployeeName
                                                    + ' ('
                                                    + CONVERT(VARCHAR, Dup_room.S_EmployeeId)
                                                    + ')'
                                             FROM   ( SELECT DISTINCT
                                                              vw.EmployeeName ,
                                                              vw.S_EmployeeId
                                                      FROM    ( SELECT
                                                              T.Dt_Schedule_Date ,
                                                              T.I_Center_ID ,
                                                              T.I_TimeSlot_ID ,
                                                              fm.I_Employee_ID S_EmployeeId ,
                                                              ISNULL(TED.S_First_Name,
                                                              '') + ' '
                                                              + ISNULL(TED.S_Middle_Name,
                                                              '') + ' '
                                                              + ISNULL(TED.S_Last_Name,
                                                              '') AS EmployeeName
                                                              FROM
                                                              #tempTimeTable T
                                                              INNER JOIN dbo.T_TimeTable_Master TM
                                                              WITH ( NOLOCK ) ON T.Dt_Schedule_Date = TM.Dt_Schedule_Date
                                                              AND T.I_Center_ID = TM.I_Center_ID
                                                              --AND T.I_Room_ID = TM.I_Room_ID
                                                              AND T.I_TimeSlot_ID = TM.I_TimeSlot_ID
                                                              INNER JOIN dbo.T_TimeTable_Faculty_Map FM ON FM.I_TimeTable_ID = TM.I_TimeTable_ID
                                                              AND FM.B_Is_Actual = 0
                                                              AND fm.I_Employee_ID IN (
                                                              SELECT
                                                              CAST(VAL AS INT)
                                                              FROM
                                                              fnString2Rows(T.S_EmployeeId,
                                                              ',') )
                                                              INNER JOIN T_Employee_Dtls TED ON TED.I_Employee_ID = FM.I_Employee_ID
                                                              INNER JOIN dbo.T_Room_Master R
                                                              WITH ( NOLOCK ) ON TM.I_Room_ID = R.I_Room_ID
                                                              LEFT JOIN #tempTimeTable TT ON tt.I_TimeTable_ID = TM.I_TimeTable_ID
                                                              WHERE
                                                              TM.I_Status = 1
                                                              AND tt.I_TimeTable_ID IS NULL
                                                              GROUP BY T.Dt_Schedule_Date ,
                                                              T.I_Center_ID ,
                                                              T.I_TimeSlot_ID ,
                                                              fm.I_Employee_ID ,
                                                              ISNULL(TED.S_First_Name,
                                                              '') + ' '
                                                              + ISNULL(TED.S_Middle_Name,
                                                              '') + ' '
                                                              + ISNULL(TED.S_Last_Name,
                                                              '')
                                                              HAVING
                                                              COUNT(DISTINCT T.I_Room_ID) > 1
                                                              ) VW
                                                      UNION
                                                      SELECT DISTINCT
                                                              vw.EmployeeName ,
                                                              vw.S_EmployeeId
                                                      FROM    ( SELECT
                                                              T.I_Center_ID ,
                                                              T.I_TimeSlot_ID ,
                                                              T.Dt_Schedule_Date ,
                                                              TED.I_Employee_ID S_EmployeeId ,
                                                              ISNULL(TED.S_First_Name,
                                                              '') + ' '
                                                              + ISNULL(TED.S_Middle_Name,
                                                              '') + ' '
                                                              + ISNULL(TED.S_Last_Name,
                                                              '') AS EmployeeName
                                                              FROM
                                                              #tempTimeTable T
                                                              INNER JOIN dbo.T_Room_Master R
                                                              WITH ( NOLOCK ) ON T.I_Room_ID = R.I_Room_ID
                                                              INNER JOIN T_Employee_Dtls TED ON TED.I_Employee_ID IN (
                                                              SELECT
                                                              CAST(VAL AS INT)
                                                              FROM
                                                              fnString2Rows(T.S_EmployeeId,
                                                              ',') )
                                                              GROUP BY T.I_Center_ID ,
                                                              T.I_TimeSlot_ID ,
                                                              T.Dt_Schedule_Date ,
                                                              TED.I_Employee_ID ,
                                                              ISNULL(TED.S_First_Name,
                                                              '') + ' '
                                                              + ISNULL(TED.S_Middle_Name,
                                                              '') + ' '
                                                              + ISNULL(TED.S_Last_Name,
                                                              '')
                                                              HAVING
                                                              COUNT(DISTINCT T.I_Room_ID) > 1
                                                              ) VW
                                                    ) Dup_room
                                             ORDER BY Dup_room.S_EmployeeId
                                           FOR
                                             XML PATH('')
                                           ), 2, 200000)                 
                                   
                RAISERROR('Employees %s are already allocated to different room for the scheduled date and time slot',11,1,@Duproomno)                              
        	
            END    
        ELSE 
            IF EXISTS ( SELECT  T.Dt_Schedule_Date ,
                                T.I_Center_ID ,
                                T.I_TimeSlot_ID ,
                                T.I_Room_ID
                        FROM    #tempTimeTable T
                                INNER JOIN dbo.T_TimeTable_Master TM WITH ( NOLOCK ) ON T.Dt_Schedule_Date = TM.Dt_Schedule_Date
                                                              AND T.I_Center_ID = TM.I_Center_ID
                                                              AND T.I_Room_ID = TM.I_Room_ID
                                                              AND T.I_TimeSlot_ID = TM.I_TimeSlot_ID
                                INNER JOIN dbo.T_Room_Master R WITH ( NOLOCK ) ON TM.I_Room_ID = R.I_Room_ID
                                LEFT JOIN #tempTimeTable TT ON tt.I_TimeTable_ID = TM.I_TimeTable_ID
                        WHERE   TM.I_Status = 1
                                AND tt.I_TimeTable_ID IS NULL
                        GROUP BY T.Dt_Schedule_Date ,
                                T.I_Center_ID ,
                                T.I_TimeSlot_ID ,
                                T.I_Room_ID
                        HAVING  COUNT(DISTINCT T.S_EmployeeId) > 1 )
                OR EXISTS ( SELECT  T.I_Room_ID ,
                                    T.I_Center_ID ,
                                    T.I_TimeSlot_ID ,
                                    T.Dt_Schedule_Date
                            FROM    #tempTimeTable T
                                    INNER JOIN dbo.T_Room_Master R WITH ( NOLOCK ) ON T.I_Room_ID = R.I_Room_ID
                            GROUP BY T.I_Room_ID ,
                                    T.I_Center_ID ,
                                    T.I_TimeSlot_ID ,
                                    T.Dt_Schedule_Date
                            HAVING  COUNT(DISTINCT T.S_EmployeeId) > 1 ) 
                BEGIN
                    DECLARE @Duproomno1 nvarchar(max)
                    SET @Duproomno1 = SUBSTRING(( SELECT    ','
                                                            + Dup_room.ROOM_Number
                                                  FROM      ( SELECT
                                                              R.S_Building_Name
                                                              + '-'
                                                              + R.S_Block_Name
                                                              + '-'
                                                              + R.S_Floor_Name
                                                              + '-'
                                                              + R.S_Room_No AS ROOM_Number
                                                              FROM
                                                              dbo.T_Room_Master R
                                                              INNER JOIN ( SELECT
                                                              T.Dt_Schedule_Date ,
                                                              T.I_Center_ID ,
                                                              T.I_TimeSlot_ID ,
                                                              T.I_Room_ID
                                                              FROM
                                                              #tempTimeTable T
                                                              INNER JOIN dbo.T_TimeTable_Master TM
                                                              WITH ( NOLOCK ) ON T.Dt_Schedule_Date = TM.Dt_Schedule_Date
                                                              AND T.I_Center_ID = TM.I_Center_ID
                                                              AND T.I_Room_ID = TM.I_Room_ID
                                                              AND T.I_TimeSlot_ID = TM.I_TimeSlot_ID
                                                              INNER JOIN dbo.T_Room_Master R
                                                              WITH ( NOLOCK ) ON TM.I_Room_ID = R.I_Room_ID
                                                              LEFT JOIN #tempTimeTable TT ON tt.I_TimeTable_ID = TM.I_TimeTable_ID
                                                              WHERE
                                                              TM.I_Status = 1
                                                              AND tt.I_TimeTable_ID IS NULL
                                                              GROUP BY T.Dt_Schedule_Date ,
                                                              T.I_Center_ID ,
                                                              T.I_TimeSlot_ID ,
                                                              T.I_Room_ID
                                                              HAVING
                                                              COUNT(DISTINCT T.S_EmployeeId) > 1
                                                              ) VW ON R.I_Room_ID = VW.I_Room_ID
                                                              UNION
                                                              SELECT
                                                              R.S_Building_Name
                                                              + '-'
                                                              + R.S_Block_Name
                                                              + '-'
                                                              + R.S_Floor_Name
                                                              + '-'
                                                              + R.S_Room_No AS ROOM_Number
                                                              FROM
                                                              dbo.T_Room_Master R
                                                              INNER JOIN ( SELECT
                                                              T.I_Room_ID ,
                                                              T.I_Center_ID ,
                                                              T.I_TimeSlot_ID ,
                                                              T.Dt_Schedule_Date
                                                              FROM
                                                              #tempTimeTable T
                                                              INNER JOIN dbo.T_Room_Master R
                                                              WITH ( NOLOCK ) ON T.I_Room_ID = R.I_Room_ID
                                                              GROUP BY T.I_Room_ID ,
                                                              T.I_Center_ID ,
                                                              T.I_TimeSlot_ID ,
                                                              T.Dt_Schedule_Date
                                                              HAVING
                                                              COUNT(DISTINCT T.S_EmployeeId) > 1
                                                              ) VW ON R.I_Room_ID = VW.I_Room_ID
                                                            ) Dup_room
                                                  ORDER BY  ROOM_Number
                                                FOR
                                                  XML PATH('')
                                                ), 2, 200000)                 
                                   
                    RAISERROR('Rooms %s are already allocated for the scheduled date and time slot to another faculty',11,1,@Duproomno1)                               
        	
                END   
            ELSE 
                BEGIN    
      --added by sudipta
      
        --CREATE TABLE #tempTimeTabledeletesameskill
        --    (
        --      I_TimeTable_ID INT ,
        --      I_Session_ID INT ,
        --      I_Session_ID_OLD INT ,
        --      I_TimeTable_ID_ref INT
        --    )
      
                    CREATE TABLE #tempTimeTableReplan
                        (
                          I_ID INT IDENTITY(1, 1) ,
                          I_TimeTable_ID INT ,
                          I_Center_ID INT ,
                          Dt_Schedule_Date DATETIME ,
                          I_TimeSlot_ID INT ,
                          I_Batch_ID INT ,
                          I_Sub_Batch_ID INT NULL ,
                          I_Room_ID INT ,
                          I_Skill_ID INT ,
                          I_Skill_ID_Session INT ,
                          I_Skill_ID_Module INT ,
                          S_SessionFullName nvarchar(max) ,
                          I_Session_ID INT ,
                          S_SessionName nvarchar(max) ,
                          S_SessionTopic nvarchar(max) ,
                          I_ModuleId INT ,
                          I_TermId INT ,
                          I_Skill_ID_OLD INT ,
                          I_Skill_ID_Session_OLD INT ,
                          I_Skill_ID_Module_OLD INT ,
                          I_Session_ID_OLD INT ,
                          S_SessionName_OLD nvarchar(max) ,
                          S_SessionTopic_OLD nvarchar(max) ,
                          I_ModuleId_OLD INT ,
                          I_TermId_OLD INT ,
                          I_Batch_ID_OLD INT ,
                          I_Sub_Batch_ID_OLD INT NULL ,
                          I_Room_ID_OLD INT
                        )  
                    INSERT  INTO #tempTimeTableReplan
                            ( I_TimeTable_ID ,
                              I_Center_ID ,
                              Dt_Schedule_Date ,
                              I_TimeSlot_ID ,
                              I_Batch_ID ,
                              I_Sub_Batch_ID ,
                              I_Room_ID ,
                              I_Skill_ID ,
                              I_Skill_ID_Session ,
                              I_Skill_ID_Module ,
                              S_SessionFullName ,
                              I_Session_ID ,
                              S_SessionName ,
                              S_SessionTopic ,
                              I_ModuleId ,
                              I_TermId ,
                              I_Skill_ID_OLD ,
                              I_Skill_ID_Session_OLD ,
                              I_Skill_ID_Module_OLD ,
                              I_Session_ID_OLD ,
                              S_SessionName_OLD ,
                              S_SessionTopic_OLD ,
                              I_ModuleId_OLD ,
                              I_TermId_OLD ,
                              I_Batch_ID_OLD ,
                              I_Sub_Batch_ID_OLD ,
                              I_Room_ID_OLD 
                    
                            )
                            SELECT  N.I_TimeTable_ID ,
                                    N.I_Center_ID ,
                                    N.Dt_Schedule_Date ,
                                    N.I_TimeSlot_ID ,
                                    N.I_Batch_ID ,
                                    N.I_Sub_Batch_ID ,
                                    N.I_Room_ID ,
                                    ISNULL(B.I_Skill_ID,
                                           ISNULL(C.I_Skill_ID, 0)) ,
                                    ISNULL(B.I_Skill_ID, 0) ,
                                    ISNULL(C.I_Skill_ID, 0) ,
                                    N.S_SessionFullName ,
                                    N.I_Session_ID ,
                                    N.S_SessionName ,
                                    N.S_SessionTopic ,
                                    N.I_ModuleId ,
                                    N.I_TermId ,
                                    ISNULL(BO.I_Skill_ID,
                                           ISNULL(CO.I_Skill_ID, 0)) ,
                                    ISNULL(BO.I_Skill_ID, 0) ,
                                    ISNULL(CO.I_Skill_ID, 0) ,
                                    O.I_Session_ID ,
                                    O.S_Session_Name ,
                                    O.S_Session_Topic ,
                                    O.I_Module_Id ,
                                    O.I_Term_Id ,
                                    O.I_Batch_ID ,
                                    O.I_Sub_Batch_ID ,
                                    O.I_Room_ID
                            FROM    #tempTimeTable N
                                    INNER JOIN dbo.T_TimeTable_Master O WITH ( NOLOCK ) ON N.I_TimeTable_ID = O.I_TimeTable_ID
                                                              AND N.I_Replan = 1
                                                              AND N.I_Session_ID <> O.I_Session_ID
                                                              AND O.I_Is_Complete <> 1
                                                              AND N.I_Is_Complete <> 1
                                    INNER JOIN dbo.T_Session_Master B WITH ( NOLOCK ) ON N.I_Session_ID = B.I_Session_ID
                                    INNER JOIN dbo.T_Module_Master C WITH ( NOLOCK ) ON N.I_ModuleID = C.I_Module_ID
                                    INNER JOIN dbo.T_Session_Master BO WITH ( NOLOCK ) ON O.I_Session_ID = BO.I_Session_ID
                                    INNER JOIN dbo.T_Module_Master CO WITH ( NOLOCK ) ON O.I_Module_ID = CO.I_Module_ID
                        
        
        --INSERT  INTO #tempTimeTabledeletesameskill
        --        ( I_TimeTable_ID ,
        --          I_Session_ID ,
        --          I_Session_ID_old ,
        --          I_TimeTable_ID_ref
        --        )
        --        SELECT  T.I_TimeTable_ID ,
        --                R.I_Session_ID ,
        --                R.I_Session_ID_Old ,
        --                R.I_TimeTable_ID
        --        FROM    dbo.T_TimeTable_Master T
        --                INNER JOIN #tempTimeTableReplan R ON T.I_Batch_ID = R.I_Batch_ID
        --                                                     AND T.I_Module_ID = R.I_ModuleId
        --                                                     AND T.I_Term_ID = R.I_TermId
        --                                                     AND T.I_Session_ID = R.I_Session_ID
        --                                                     AND T.I_Center_ID = R.I_Center_ID
        --                                                     AND T.I_Status = 1
        --                                                     AND T.I_Is_Complete = 0
        --                                                     AND CONVERT(DATE, T.Dt_Schedule_Date) >= CONVERT(DATE, R.Dt_Schedule_Date)
        --                                                     AND R.I_Skill_ID = I_Skill_ID_OLD	
                    UPDATE  T
                    SET     I_Status = 0,Dt_Updt_On=GETDATE()
                    FROM    dbo.T_TimeTable_Master T
                            INNER JOIN #tempTimeTableReplan R ON T.I_Batch_ID = R.I_Batch_ID
                                                              AND T.I_Module_ID = R.I_ModuleId
                                                              AND T.I_Term_ID = R.I_TermId
                                                              AND T.I_Session_ID = R.I_Session_ID
                                                              AND T.I_Center_ID = R.I_Center_ID
                                                              AND ISNULL(T.I_Sub_Batch_ID,
                                                              0) = ISNULL(R.I_Sub_Batch_ID,
                                                              0)
                                                              AND T.I_Status = 1
                                                              AND T.I_Is_Complete = 0
                                                              AND CONVERT(DATE, T.Dt_Schedule_Date) >= CONVERT(DATE, R.Dt_Schedule_Date)
                                                                                                                
      
      --end addition sudipta            
     
   -- defination of the variables of the TimeTable parent              
                    DECLARE @ipI_TimeTableId INT   
                    DECLARE @ipI_Center_ID INT              
                    DECLARE @ipDt_Schedule_Date DATETIME              
                    DECLARE @ipI_TimeSlot_ID INT              
                    DECLARE @ipI_Batch_ID INT 
                    DECLARE @ipI_Sub_Batch_ID INT             
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
                    DECLARE @DetailsFaculty nvarchar(max)           
                       
   -- declare cursor for TimeTable details              
                    DECLARE UPLOADTIMETABLEPARENT_CURSOR CURSOR FOR               
                    SELECT   
                    I_TimeTable_ID,             
                    I_Center_ID,    
                    Dt_Schedule_Date,    
                    I_TimeSlot_ID,    
                    I_Batch_ID,  
                    I_Sub_Batch_ID,  
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
   @ipI_Sub_Batch_ID,              
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
       
                            IF ( SELECT COUNT(*)
                                 FROM   T_TimeTable_Master
                                 WHERE  I_Center_ID = @ipI_Center_ID
                                        AND I_Batch_ID = @ipI_Batch_ID
                                        --AND ISNULL(I_Sub_Batch_ID, 0) = ISNULL(@ipI_Sub_Batch_ID,
                                        --                      0)
                                        AND ISNULL(I_Sub_Batch_ID,
                                                   ISNULL(@ipI_Sub_Batch_ID, 0)) = ISNULL(@ipI_Sub_Batch_ID,
                                                              ISNULL(I_Sub_Batch_ID,
                                                              0))
                                        AND I_Session_ID = @ipI_Session_ID
                                        AND I_Status = 1
                                        AND I_TimeTable_ID NOT IN (
                                        @ipI_TimeTableId )
                               ) = 0 
                                BEGIN   
                                    IF ( SELECT COUNT(*)
                                         FROM   T_TimeTable_Master
                                         WHERE  I_TimeTable_ID = @ipI_TimeTableId
                                       ) > 0 
                                        BEGIN    
                                            DELETE  FROM dbo.T_TimeTable_Faculty_Map
                                            WHERE   I_TimeTable_ID = @ipI_TimeTableId  
         
                                            SELECT  @Dt_StartTime = Dt_Start_Time ,
                                                    @Dt_EndTime = Dt_End_Time
                                            FROM    T_Center_Timeslot_Master
                                            WHERE   I_TimeSlot_ID = @ipI_TimeSlot_ID  
         
                                            IF ( SELECT COUNT(DISTINCT TTM.I_Room_ID)
                                                 FROM   dbo.T_TimeTable_Master
                                                        AS TTM
                                                        INNER JOIN dbo.T_TimeTable_Faculty_Map
                                                        AS TTFM ON TTM.I_TimeTable_ID = TTFM.I_TimeTable_ID
                                                 WHERE  TTM.I_TimeSlot_ID = @ipI_TimeSlot_ID
                                                        AND TTM.I_Center_ID = @ipI_Center_ID
                                                        AND TTM.Dt_Schedule_Date = @ipDt_Schedule_Date
                                                        AND TTM.I_Room_ID <> @ipI_Room_ID
                                                        AND TTM.I_Status = 1
                                                        AND TTFM.I_Employee_ID IN (
                                                        SELECT
                                                              CAST(VAL AS INT)
                                                        FROM  fnString2Rows(@ipS_EmployeeId,
                                                              ',') )
                                               ) > 0 
                                                BEGIN   
                                                
                                                    SET @DetailsFaculty = SUBSTRING(( SELECT
                                                              ',' + vw.Details
                                                              FROM
                                                              ( SELECT
                                                              ISNULL(TED.S_First_Name,
                                                              '') + ' '
                                                              + ISNULL(TED.S_Middle_Name,
                                                              '') + ' '
                                                              + ISNULL(TED.S_Last_Name,
                                                              '')
                                                              + ' for session '
                                                              + TTM.S_Session_Name AS Details
                                                              FROM
                                                              dbo.T_TimeTable_Master
                                                              AS TTM
                                                              INNER JOIN dbo.T_TimeTable_Faculty_Map
                                                              AS TTFM ON TTM.I_TimeTable_ID = TTFM.I_TimeTable_ID
                                                              INNER JOIN T_Employee_Dtls TED ON TED.I_Employee_ID = TTFM.I_Employee_ID
                                                              WHERE
                                                              TTM.I_TimeSlot_ID = @ipI_TimeSlot_ID
                                                              AND TTM.I_Center_ID = @ipI_Center_ID
                                                              AND TTM.Dt_Schedule_Date = @ipDt_Schedule_Date
                                                              AND TTM.I_Status = 1
                                                              AND TTM.I_Room_ID <> @ipI_Room_ID
                                                              AND TTFM.I_Employee_ID IN (
                                                              SELECT
                                                              CAST(VAL AS INT)
                                                              FROM
                                                              fnString2Rows(@ipS_EmployeeId,
                                                              ',') )
                                                              ) vw
                                                              ORDER BY vw.Details
                                                              FOR
                                                              XML
                                                              PATH('')
                                                              ), 2, 200000)
                                                              
                                                    RAISERROR('The faculties have already been assigned for this time slot in another room. %s',11,1,@DetailsFaculty)    
                                                END    
                                            ELSE 
                                                IF ( SELECT COUNT(*)
                                                     FROM   dbo.T_TimeTable_Master
                                                            AS TTM
                                                            INNER JOIN T_TimeTable_Faculty_Map
                                                            AS TTFM ON TTFM.I_TimeTable_ID = TTM.I_TimeTable_ID
                                                              AND TTM.I_Status = 1
                                                              AND TTM.I_Room_ID <> @ipI_Room_ID
                                                            INNER JOIN T_Center_Timeslot_Master TCTM ON TCTM.I_TimeSlot_ID = TTM.I_TimeSlot_ID
                                                            INNER JOIN T_Employee_Dtls TED ON TED.I_Employee_ID = TTFM.I_Employee_ID
                                                     WHERE  TTFM.I_Employee_ID IN (
                                                            SELECT
                                                              CAST(VAL AS INT)
                                                            FROM
                                                              fnString2Rows(@ipS_EmployeeId,
                                                              ',') )
                                                            AND TED.B_IsRoamingFaculty = 1
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
                                                     
                                                        SET @DetailsFaculty = SUBSTRING(( SELECT
                                                              ',' + vw.Details
                                                              FROM
                                                              ( SELECT
                                                              ISNULL(TED.S_First_Name,
                                                              '') + ' '
                                                              + ISNULL(TED.S_Middle_Name,
                                                              '') + ' '
                                                              + ISNULL(TED.S_Last_Name,
                                                              '')
                                                              + ' for session '
                                                              + TTM.S_Session_Name AS Details
                                                              FROM
                                                              dbo.T_TimeTable_Master
                                                              AS TTM
                                                              INNER JOIN T_TimeTable_Faculty_Map
                                                              AS TTFM ON TTFM.I_TimeTable_ID = TTM.I_TimeTable_ID
                                                              AND TTM.I_Status = 1
                                                              AND TTM.I_Room_ID <> @ipI_Room_ID
                                                              INNER JOIN T_Center_Timeslot_Master TCTM ON TCTM.I_TimeSlot_ID = TTM.I_TimeSlot_ID
                                                              INNER JOIN T_Employee_Dtls TED ON TED.I_Employee_ID = TTFM.I_Employee_ID
                                                              WHERE
                                                              TTFM.I_Employee_ID IN (
                                                              SELECT
                                                              CAST(VAL AS INT)
                                                              FROM
                                                              fnString2Rows(@ipS_EmployeeId,
                                                              ',') )
                                                              AND TED.B_IsRoamingFaculty = 1
                                                              AND ( TCTM.Dt_Start_Time BETWEEN @Dt_StartTime
                                                              AND
                                                              @Dt_EndTime
                                                              OR TCTM.Dt_End_Time BETWEEN @Dt_StartTime
                                                              AND
                                                              @Dt_EndTime
                                                              )
                                                              AND TTM.Dt_Schedule_Date = @ipDt_Schedule_Date
                                                              ) vw
                                                              ORDER BY vw.Details
                                                              FOR
                                                              XML
                                                              PATH('')
                                                              ), 2, 200000)
                                                              
                                                        RAISERROR('The faculties have already been assigned for this time slot. %s',11,1,@DetailsFaculty)    
                                                    END  
                                                ELSE 
                                                    BEGIN    
         
                                                        UPDATE
                                                              dbo.T_TimeTable_Master
                                                        SET   I_Batch_ID = @ipI_Batch_ID ,
                                                              I_Sub_Batch_ID = @ipI_Sub_Batch_ID ,
                                                              I_Skill_ID = @ipI_Skill_ID ,
                                                              S_Remarks = @ipS_Remarks ,
                                                              I_Session_ID = @ipI_Session_ID ,
                                                              I_Term_ID = @ipI_TermId ,
                                                              I_Module_ID = @ipI_ModuleId ,
                                                              S_Session_Name = @ipS_SessionName ,
                                                              S_Session_Topic = @ipS_SessionTopic ,
                                                              Dt_Actual_Date = @ipDt_ActualDate ,
                                                              I_Is_Complete = @ipI_Is_Complete ,
                                                              I_Status = @ipI_Status ,
                                                              I_Room_ID = ISNULL(NULLIF(@ipI_Room_ID,
                                                              0), I_Room_ID),
                                                              Dt_Updt_On=GETDATE()
                                                        WHERE I_TimeTable_ID = @ipI_TimeTableId  
                                   
                                                        IF ( @ipS_EmployeeId IS NOT NULL ) 
                                                            BEGIN  
                                                              INSERT
                                                              INTO dbo.T_TimeTable_Faculty_Map
                                                              ( 
                                                              I_TimeTable_ID ,
                                                              I_Employee_ID ,
                                                              B_Is_Actual   
                                                              )
                                                              SELECT
                                                              @ipI_TimeTableId ,
                                                              CAST(Val AS INT) ,
                                                              0
                                                              FROM
                                                              dbo.fnString2Rows(@ipS_EmployeeId,
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
                                                      I_Sub_Batch_ID ,
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
                                                      @ipI_Sub_Batch_ID ,
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
                                                      NULL ,
                                                      0  
                                                    )              
                  
                                            SET @iTimeTableID = SCOPE_IDENTITY()     
         
                                            SELECT  @Dt_StartTime = Dt_Start_Time ,
                                                    @Dt_EndTime = Dt_End_Time
                                            FROM    T_Center_Timeslot_Master
                                            WHERE   I_TimeSlot_ID = @ipI_TimeSlot_ID  
         
                                            IF ( SELECT COUNT(DISTINCT ttm.I_Room_ID)
                                                 FROM   dbo.T_TimeTable_Master
                                                        AS TTM
                                                        INNER JOIN dbo.T_TimeTable_Faculty_Map
                                                        AS TTFM ON TTM.I_TimeTable_ID = TTFM.I_TimeTable_ID
                                                              AND I_Status = 1
                                                 WHERE  TTM.I_TimeSlot_ID = @ipI_TimeSlot_ID
                                                        AND TTM.I_Center_ID = @ipI_Center_ID
                                                        AND ttm.I_Room_ID <> @ipI_room_ID
                                                        AND TTM.Dt_Schedule_Date = @ipDt_Schedule_Date
                                                        AND TTFM.I_Employee_ID IN (
                                                        SELECT
                                                              CAST(VAL AS INT)
                                                        FROM  fnString2Rows(@ipS_EmployeeId,
                                                              ',') )
                                               ) > 0 
                                                BEGIN  
                                                
                                                    SET @DetailsFaculty = SUBSTRING(( SELECT
                                                              ',' + vw.Details
                                                              FROM
                                                              ( SELECT
                                                              ISNULL(TED.S_First_Name,
                                                              '') + ' '
                                                              + ISNULL(TED.S_Middle_Name,
                                                              '') + ' '
                                                              + ISNULL(TED.S_Last_Name,
                                                              '')
                                                              + ' for session '
                                                              + TTM.S_Session_Name AS Details
                                                              FROM
                                                              dbo.T_TimeTable_Master
                                                              AS TTM
                                                              INNER JOIN dbo.T_TimeTable_Faculty_Map
                                                              AS TTFM ON TTM.I_TimeTable_ID = TTFM.I_TimeTable_ID
                                                              AND I_Status = 1
                                                              INNER JOIN T_Employee_Dtls TED ON TED.I_Employee_ID = TTFM.I_Employee_ID
                                                              WHERE
                                                              TTM.I_TimeSlot_ID = @ipI_TimeSlot_ID
                                                              AND TTM.I_Center_ID = @ipI_Center_ID
                                                              AND ttm.I_Room_ID <> @ipI_room_ID
                                                              AND TTM.Dt_Schedule_Date = @ipDt_Schedule_Date
                                                              AND TTFM.I_Employee_ID IN (
                                                              SELECT
                                                              CAST(VAL AS INT)
                                                              FROM
                                                              fnString2Rows(@ipS_EmployeeId,
                                                              ',') )
                                                              ) vw
                                                              ORDER BY vw.Details
                                                              FOR
                                                              XML
                                                              PATH('')
                                                              ), 2, 200000)
                                                              
                                                    RAISERROR('The faculties have already been assigned for this time slot in another room. %s',11,1,@DetailsFaculty)   
                                                END  
                                            ELSE 
                                                IF ( SELECT COUNT(*)
                                                     FROM   dbo.T_TimeTable_Master
                                                            AS TTM
                                                            INNER JOIN T_TimeTable_Faculty_Map
                                                            AS TTFM ON TTFM.I_TimeTable_ID = TTM.I_TimeTable_ID
                                                              AND TTM.I_Status = 1
                                                              AND TTM.I_Room_ID <> @ipI_Room_ID
                                                            INNER JOIN T_Center_Timeslot_Master TCTM ON TCTM.I_TimeSlot_ID = TTM.I_TimeSlot_ID
                                                            INNER JOIN T_Employee_Dtls TED ON TED.I_Employee_ID = TTFM.I_Employee_ID
                                                     WHERE  TTFM.I_Employee_ID IN (
                                                            SELECT
                                                              CAST(VAL AS INT)
                                                            FROM
                                                              fnString2Rows(@ipS_EmployeeId,
                                                              ',') )
                                                            AND TED.B_IsRoamingFaculty = 1
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
                                                    
                                                        SET @DetailsFaculty = SUBSTRING(( SELECT
                                                              ',' + vw.Details
                                                              FROM
                                                              ( SELECT
                                                              ISNULL(TED.S_First_Name,
                                                              '') + ' '
                                                              + ISNULL(TED.S_Middle_Name,
                                                              '') + ' '
                                                              + ISNULL(TED.S_Last_Name,
                                                              '')
                                                              + ' for session '
                                                              + TTM.S_Session_Name AS Details
                                                              FROM
                                                              dbo.T_TimeTable_Master
                                                              AS TTM
                                                              INNER JOIN T_TimeTable_Faculty_Map
                                                              AS TTFM ON TTFM.I_TimeTable_ID = TTM.I_TimeTable_ID
                                                              AND TTM.I_Status = 1
                                                              AND TTM.I_Room_ID <> @ipI_Room_ID
                                                              INNER JOIN T_Center_Timeslot_Master TCTM ON TCTM.I_TimeSlot_ID = TTM.I_TimeSlot_ID
                                                              INNER JOIN T_Employee_Dtls TED ON TED.I_Employee_ID = TTFM.I_Employee_ID
                                                              WHERE
                                                              TTFM.I_Employee_ID IN (
                                                              SELECT
                                                              CAST(VAL AS INT)
                                                              FROM
                                                              fnString2Rows(@ipS_EmployeeId,
                                                              ',') )
                                                              AND TED.B_IsRoamingFaculty = 1
                                                              AND ( TCTM.Dt_Start_Time BETWEEN @Dt_StartTime
                                                              AND
                                                              @Dt_EndTime
                                                              OR TCTM.Dt_End_Time BETWEEN @Dt_StartTime
                                                              AND
                                                              @Dt_EndTime
                                                              )
                                                              AND TTM.Dt_Schedule_Date = @ipDt_Schedule_Date
                                                              ) vw
                                                              ORDER BY vw.Details
                                                              FOR
                                                              XML
                                                              PATH('')
                                                              ), 2, 200000)
                                                              
                                                        RAISERROR('The faculties have already been assigned for this time slot. %s',11,1,@DetailsFaculty)
                                                    END  
                                                ELSE 
                                                    BEGIN  
                                                        INSERT
                                                              INTO dbo.T_TimeTable_Faculty_Map
                                                              ( 
                                                              I_TimeTable_ID ,
                                                              I_Employee_ID ,
                                                              B_Is_Actual   
                                                              )
                                                              SELECT
                                                              @iTimeTableID ,
                                                              CAST(Val AS INT) ,
                                                              0
                                                              FROM
                                                              dbo.fnString2Rows(@ipS_EmployeeId,
                                                              ',') AS FSR    
                                                    END  
                                        END    
                                END  
                            ELSE 
                                BEGIN  
                                    SELECT  @S_Batch_Name = S_Batch_Name
                                    FROM    dbo.T_Student_Batch_master
                                    WHERE   I_Batch_ID = @ipI_Batch_ID  
                                    SELECT TOP 1 @Dt_DateTime = Dt_Schedule_Date ,
                                            @I_timeSlot_id = I_TimeSlot_ID
                                    FROM    T_TimeTable_Master
                                    WHERE   I_Center_ID = @ipI_Center_ID
                                            AND I_Batch_ID = @ipI_Batch_ID
                                            --AND ISNULL(I_Sub_Batch_ID, 0) = ISNULL(@ipI_Sub_Batch_ID,
                                            --                  0)
                                            AND ISNULL(I_Sub_Batch_ID,
                                                       ISNULL(@ipI_Sub_Batch_ID,
                                                              0)) = ISNULL(@ipI_Sub_Batch_ID,
                                                              ISNULL(I_Sub_Batch_ID,
                                                              0))
                                            AND I_Session_ID = @ipI_Session_ID
                                            AND I_Status = 1
                                            AND I_TimeTable_ID NOT IN (
                                            @ipI_TimeTableId ) 
                                    ORDER BY I_TimeTable_ID DESC
                                             
                                    SELECT  @S_DateTime = LEFT(CONVERT(VARCHAR, @Dt_DateTime, 120),
                                                              10)  
                                    SELECT  @Dt_StartTime = Dt_Start_Time ,
                                            @Dt_EndTime = Dt_End_Time
                                    FROM    T_Center_Timeslot_Master
                                    WHERE   I_TimeSlot_ID = @I_timeSlot_id  
                                    SELECT  @S_StartTime = RIGHT(CONVERT(VARCHAR, @Dt_StartTime, 120),
                                                              8)  
                                    SELECT  @S_EndTime = RIGHT(CONVERT(VARCHAR, @Dt_EndTime, 120),
                                                              8)  
                                    RAISERROR('The session %s for batch %s is already allocated on %s at timeslot %s to %s.',11,1,@ipS_SessionFullName,@S_Batch_Name,@S_DateTime,@S_StartTime,@S_EndTime)   
                                END  
         
     -- FETCH NEXT FOR INVOICE PARENT CURSOR              
                            FETCH NEXT FROM UPLOADTIMETABLEPARENT_CURSOR               
    INTO @ipI_TimeTableId,  
    @ipI_Center_ID,              
    @ipDt_Schedule_Date,              
    @ipI_TimeSlot_ID,              
    @ipI_Batch_ID, 
    @ipI_Sub_Batch_ID,              
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
        
        --code added by sudipta
        
                    CREATE TABLE #tmproutinesequence
                        (
                          ROW INT ,
                          I_Session_Module_ID INT ,
                          I_Session_ID INT ,
                          S_Session_Code nvarchar(max) ,
                          S_Session_Name nvarchar(max) NULL ,
                          I_Skill_ID INT ,
                          S_Skill_Desc nvarchar(max) ,
                          I_Module_ID INT ,
                          I_Sequence INT ,
                          N_Session_Duration NUMERIC(18, 2) NULL ,
                          Module_Term_Seq INT ,
                          Term_Course_Seq INT ,
                          I_Term_ID INT ,
                          S_Session_Topic nvarchar(max) NULL ,
                          S_Term_Name nvarchar(max)
                        )
            
        --CREATE TABLE #tmproutinesequenceAll
        --    (
        --      ROW INT ,
        --      I_Session_Module_ID INT ,
        --      I_Session_ID INT ,
        --      S_Session_Code VARCHAR(50) ,
        --      S_Session_Name VARCHAR(250) NULL ,
        --      I_Skill_ID INT ,
        --      S_Skill_Desc VARCHAR(250) ,
        --      I_Module_ID INT ,
        --      I_Sequence INT ,
        --      N_Session_Duration NUMERIC(18, 2) NULL ,
        --      Module_Term_Seq INT ,
        --      Term_Course_Seq INT ,
        --      I_Term_ID INT ,
        --      S_Session_Topic VARCHAR(1000) NULL ,
        --      S_Term_Name VARCHAR(250)
        --    )
                
                    DECLARE @totalcount INT
                    DECLARE @iCount INT
                    DECLARE @oldModuleID INT ,
                        @oldTermId INT ,
                        @OldSesionID INT ,
                        @oldBatchID INT ,
                        @oldSubBatchID INT ,
                        @TimeTableID INT ,
                        @dtScheduleDate DATETIME ,
                        @TimeSlotID INT ,
                        @oldSkillID INT ,
                        @newSessionID INT ,
                        @NewtermId INT ,
                        @NewModuleID INT ,
                        @NewSkillId INT ,
                        @centerID INT ,
                        @OldSessionRowSeq INT
                    SET @iCount = 1
                    SELECT  @totalcount = COUNT(1)
                    FROM    #tempTimeTableReplan
        
                    WHILE @iCount <= ISNULL(@totalcount, 0) 
                        BEGIN
                            SELECT  @OldSesionID = I_Session_ID_OLD ,
                                    @oldModuleID = I_ModuleId_OLD ,
                                    @oldTermId = I_TermId_OLD ,
                                    @oldBatchID = I_Batch_ID_OLD ,
                                    @oldSubBatchID = I_Sub_Batch_ID_OLD ,
                                    @TimeTableID = I_TimeTable_ID ,
                                    @dtScheduleDate = Dt_Schedule_Date ,
                                    @TimeSlotID = I_TimeSlot_ID ,
                                    @oldSkillID = I_Skill_ID_OLD ,
                                    @newSessionID = I_Session_ID ,
                                    @NewModuleID = I_ModuleId ,
                                    @NewtermId = I_TermId ,
                                    @NewSkillId = I_Skill_ID ,
                                    @centerID = I_Center_ID
                            FROM    #tempTimeTableReplan
                            WHERE   i_id = @iCount
               
                
                            DELETE  FROM #tmproutinesequence
                --DELETE  FROM #tmproutinesequenceAll
                
                            INSERT  INTO #tmproutinesequence
                                    ( ROW ,
                                      I_Session_Module_ID ,
                                      I_Session_ID ,
                                      S_Session_Code ,
                                      S_Session_Name ,
                                      I_Skill_ID ,
                                      S_Skill_Desc ,
                                      I_Module_ID ,
                                      I_Sequence ,
                                      N_Session_Duration ,
                                      Module_Term_Seq ,
                                      Term_Course_Seq ,
                                      I_Term_ID ,
                                      S_Session_Topic ,
                                      S_Term_Name
                                    )
                                    SELECT DISTINCT
                                            ROW_NUMBER() OVER ( ORDER BY D.I_Sequence, C.I_Sequence, A.I_Sequence ) AS Row ,
                                            A.I_Session_Module_ID ,
                                            A.I_Session_ID ,
                                            B.S_Session_Code ,
                                            B.S_Session_Name ,
                                            ISNULL(B.I_Skill_ID,
                                                   ISNULL(G.I_Skill_ID, 0)) AS I_Skill_ID ,
                                            CASE WHEN B.I_Skill_ID IS NOT NULL
                                                 THEN E.S_Skill_Desc
                                                 ELSE ISNULL(G.S_Skill_Desc,
                                                             'Others')
                                            END AS S_Skill_Desc ,
                                            A.I_Module_ID ,
                                            A.I_Sequence ,
                                            B.N_Session_Duration ,
                                            C.I_Sequence AS Module_Term_Seq ,
                                            D.I_Sequence AS Term_Course_Seq ,
                                            C.I_Term_ID ,
                                            B.S_Session_Topic ,
                                            H.S_Term_Name
                                    FROM    dbo.T_Session_Module_Map A WITH ( NOLOCK )
                                            INNER JOIN dbo.T_Session_Master B
                                            WITH ( NOLOCK ) ON A.I_Session_ID = B.I_Session_ID
                                            LEFT OUTER JOIN T_EOS_Skill_Master E
                                            WITH ( NOLOCK ) ON B.I_Skill_ID = E.I_Skill_ID
                                            INNER JOIN dbo.T_Module_Term_Map C
                                            WITH ( NOLOCK ) ON A.I_Module_ID = C.I_Module_ID
                                            INNER JOIN T_Module_Master F WITH ( NOLOCK ) ON C.I_Module_ID = F.I_Module_ID
                                            LEFT OUTER JOIN T_EOS_Skill_Master G
                                            WITH ( NOLOCK ) ON F.I_Skill_ID = G.I_Skill_ID
                                            INNER JOIN dbo.T_Term_Course_Map D
                                            WITH ( NOLOCK ) ON C.I_Term_ID = D.I_Term_ID
                                            INNER JOIN T_Student_Batch_master SBM
                                            WITH ( NOLOCK ) ON SBM.I_Course_ID = D.I_Course_ID
                                                              AND SBM.I_Batch_ID = @oldBatchID
                                            INNER JOIN dbo.T_Term_Master H
                                            WITH ( NOLOCK ) ON C.I_Term_ID = H.I_Term_ID
                                                              AND GETDATE() >= ISNULL(A.Dt_Valid_From,
                                                              GETDATE())
                                                              AND GETDATE() <= ISNULL(A.Dt_Valid_To,
                                                              GETDATE())
                                                              AND A.I_Status <> 0
                                                              AND B.I_Status <> 0
                                                              AND C.I_Status <> 0
                                                              AND D.I_Status <> 0
                                                              AND C.I_Term_ID = @oldTermId
                                                              AND ISNULL(B.I_Skill_ID,
                                                              ISNULL(G.I_Skill_ID,
                                                              0)) = @oldSkillID
                                                              AND ( ( @NewSkillId = @oldSkillID
                                                              AND B.I_Session_ID <> @newSessionID
                                                              )
                                                              OR ( @NewSkillId <> @oldSkillID )
                                                              )
                                                              
                --INSERT  INTO #tmproutinesequenceAll
                --        ( ROW ,
                --          I_Session_Module_ID ,
                --          I_Session_ID ,
                --          S_Session_Code ,
                --          S_Session_Name ,
                --          I_Skill_ID ,
                --          S_Skill_Desc ,
                --          I_Module_ID ,
                --          I_Sequence ,
                --          N_Session_Duration ,
                --          Module_Term_Seq ,
                --          Term_Course_Seq ,
                --          I_Term_ID ,
                --          S_Session_Topic ,
                --          S_Term_Name
                --        )
                --        SELECT DISTINCT
                --                ROW_NUMBER() OVER ( ORDER BY D.I_Sequence, C.I_Sequence, A.I_Sequence ) AS Row ,
                --                A.I_Session_Module_ID ,
                --                A.I_Session_ID ,
                --                B.S_Session_Code ,
                --                B.S_Session_Name ,
                --                ISNULL(B.I_Skill_ID, ISNULL(G.I_Skill_ID, 0)) AS I_Skill_ID ,
                --                CASE WHEN B.I_Skill_ID IS NOT NULL
                --                     THEN E.S_Skill_Desc
                --                     ELSE ISNULL(G.S_Skill_Desc, 'Others')
                --                END AS S_Skill_Desc ,
                --                A.I_Module_ID ,
                --                A.I_Sequence ,
                --                B.N_Session_Duration ,
                --                C.I_Sequence AS Module_Term_Seq ,
                --                D.I_Sequence AS Term_Course_Seq ,
                --                C.I_Term_ID ,
                --                B.S_Session_Topic ,
                --                H.S_Term_Name
                --        FROM    dbo.T_Session_Module_Map A WITH ( NOLOCK )
                --                INNER JOIN dbo.T_Session_Master B WITH ( NOLOCK ) ON A.I_Session_ID = B.I_Session_ID
                --                LEFT OUTER JOIN T_EOS_Skill_Master E WITH ( NOLOCK ) ON B.I_Skill_ID = E.I_Skill_ID
                --                INNER JOIN dbo.T_Module_Term_Map C WITH ( NOLOCK ) ON A.I_Module_ID = C.I_Module_ID
                --                INNER JOIN T_Module_Master F WITH ( NOLOCK ) ON C.I_Module_ID = F.I_Module_ID
                --                LEFT OUTER JOIN T_EOS_Skill_Master G WITH ( NOLOCK ) ON F.I_Skill_ID = G.I_Skill_ID
                --                INNER JOIN dbo.T_Term_Course_Map D WITH ( NOLOCK ) ON C.I_Term_ID = D.I_Term_ID
                --                INNER JOIN T_Student_Batch_master SBM WITH ( NOLOCK ) ON SBM.I_Course_ID = D.I_Course_ID
                --                                              AND SBM.I_Batch_ID = @oldBatchID
                --                INNER JOIN dbo.T_Term_Master H WITH ( NOLOCK ) ON C.I_Term_ID = H.I_Term_ID
                --                                              AND GETDATE() >= ISNULL(A.Dt_Valid_From,
                --                                              GETDATE())
                --                                              AND GETDATE() <= ISNULL(A.Dt_Valid_To,
                --                                              GETDATE())
                --                                              AND A.I_Status <> 0
                --                                              AND B.I_Status <> 0
                --                                              AND C.I_Status <> 0
                --                                              AND D.I_Status <> 0
                --                                              AND C.I_Term_ID = @oldTermId
                --                                              AND ISNULL(B.I_Skill_ID,
                --                                              ISNULL(G.I_Skill_ID,
                --                                              0)) = @oldSkillID
                --                                              AND @NewSkillId = @oldSkillID
                                                                                                          
                
                            SELECT  @OldSessionRowSeq = ROW
                            FROM    #tmproutinesequence
                            WHERE   I_Session_ID = @OldSesionID
                
                --IF EXISTS ( SELECT  1
                --            FROM    #tempTimeTabledeletesameskill
                --            WHERE   @TimeTableID = I_TimeTable_ID_Ref ) 
                --    BEGIN
                --        UPDATE  T
                --        SET     I_Session_ID = O.I_Session_ID ,
                --                I_Module_ID = o.I_Module_Id ,
                --                S_Session_Name = O.S_Session_Name ,
                --                S_Session_Topic = O.S_Session_Topic ,
                --                I_Status = 1
                --        FROM    dbo.T_TimeTable_Master T
                --                INNER JOIN #tempTimeTabledeletesameskill S
                --                INNER JOIN #tmproutinesequenceAll O ON O.i_session_id = S.I_Session_ID_OLD
                --                INNER JOIN #tmproutinesequenceAll N ON N.i_session_id = S.I_Session_ID ON T.I_TimeTable_ID = s.I_TimeTable_ID
                --        WHERE   S.I_TimeTable_ID_Ref = @TimeTableID
                --                AND O.row < N.row
                          
                --        IF ( @@ROWCOUNT = 0 ) 
                --            BEGIN  
                        
                --                SELECT  @OldSessionRowSeq = ROW
                --                FROM    #tmproutinesequenceAll
                --                WHERE   I_Session_ID = @OldSesionID
                      
                --                UPDATE  T
                --                SET     I_Session_ID = TRN.I_Session_ID ,
                --                        I_Module_ID = TRN.I_Module_Id ,
                --                        S_Session_Name = TRN.S_Session_Name ,
                --                        S_Session_Topic = TRN.S_Session_Topic
                --                FROM    dbo.T_TimeTable_Master T
                --                        INNER JOIN #tmproutinesequenceAll TR ON T.I_Module_ID = TR.I_Module_ID
                --                                              AND T.I_Term_ID = TR.I_Term_ID
                --                                              AND T.I_Session_ID = TR.I_Session_ID
                --                                              AND TR.row > @OldSessionRowSeq
                --                        INNER JOIN dbo.T_Session_Master B WITH ( NOLOCK ) ON T.I_Session_ID = B.I_Session_ID
                --                        INNER JOIN dbo.T_Module_Master C WITH ( NOLOCK ) ON T.I_Module_ID = C.I_Module_ID
                --                        INNER JOIN #tmproutinesequenceAll TRN ON TR.row = trn.row
                --                                              + 1
                --                WHERE   T.I_Center_ID = @centerID
                --                        AND T.I_Batch_ID = @oldBatchID
                --                        AND T.I_Term_ID = @oldTermId
                --                        AND T.I_Is_Complete = 0
                --                        AND T.I_Status = 1
                --                        AND CONVERT(DATE, T.Dt_Schedule_Date) >= @dtScheduleDate
                --                        AND ISNULL(B.I_Skill_ID,
                --                                   ISNULL(C.I_Skill_ID, 0)) = @oldSkillID     
                --            END   
                --    END
                --ELSE 
                --    BEGIN            
                            UPDATE  T
                            SET     I_Session_ID = TRN.I_Session_ID ,
                                    I_Module_ID = TRN.I_Module_Id ,
                                    S_Session_Name = TRN.S_Session_Name ,
                                    S_Session_Topic = TRN.S_Session_Topic,
                                    Dt_Updt_On=GETDATE()
                            FROM    dbo.T_TimeTable_Master T
                                    INNER JOIN #tmproutinesequence TR ON T.I_Module_ID = TR.I_Module_ID
                                                              AND T.I_Term_ID = TR.I_Term_ID
                                                              AND T.I_Session_ID = TR.I_Session_ID
                                                              AND TR.row > @OldSessionRowSeq
                                    INNER JOIN dbo.T_Session_Master B WITH ( NOLOCK ) ON T.I_Session_ID = B.I_Session_ID
                                    INNER JOIN dbo.T_Module_Master C WITH ( NOLOCK ) ON T.I_Module_ID = C.I_Module_ID
                                    INNER JOIN #tmproutinesequence TRN ON TR.row = trn.row
                                                              + 1
                            WHERE   T.I_Center_ID = @centerID
                                    AND T.I_Batch_ID = @oldBatchID
                                    AND ISNULL(T.I_Sub_Batch_ID, 0) = ISNULL(@oldSubBatchID,
                                                              0)
                                    AND T.I_Term_ID = @oldTermId
                                    AND T.I_Is_Complete = 0
                                    AND T.I_Status = 1
                                    AND CONVERT(DATE, T.Dt_Schedule_Date) >= @dtScheduleDate
                                    AND ISNULL(B.I_Skill_ID,
                                               ISNULL(C.I_Skill_ID, 0)) = @oldSkillID
                        
                    --END
                
                            SET @iCount = @iCount + 1
                        END
        
        -- end addition sudipta  
                END	
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
