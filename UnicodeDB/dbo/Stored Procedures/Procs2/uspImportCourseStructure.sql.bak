CREATE PROCEDURE [dbo].[uspImportCourseStructure] ( @iBrandID INT )
AS 
    BEGIN
        DECLARE @Course VARCHAR(MAX) ,
            @CourseID INT ,
            @Term VARCHAR(MAX) ,
            @TermID INT ,
            @TotalSessionCount INT ,
            @Module VARCHAR(MAX) ,
            @ModuleID INT ,
            @Session VARCHAR(MAX) ,
            @SessionID INT ,
            @SkillID INT ,
            @SessionDuration INT ,
            @SessionTypeID INT ,
            @Cid INT ,
            @Tid INT ,
            @Mid INT ,
            @Sid INT
	
	
        DECLARE @MaxTermSeq INT ,
            @MaxModuleSeq INT ,
            @MaxSessionSeq INT
	
	
        DECLARE DataPopulator1 CURSOR
        FOR
        SELECT * FROM dbo.T_Import_Course_Structure TICS WHERE Course IS NOT NULL
	
        OPEN DataPopulator1
	
        FETCH NEXT FROM DataPopulator1
		INTO
		@Course,
		@CourseID,
		@Term,
		@TermID,
		@TotalSessionCount,
		@Module,
		@ModuleID,
		@Session,
		@SessionID,
		@SkillID,
		@SessionDuration,
		@SessionTypeID
	
        WHILE @@FETCH_STATUS = 0 
            BEGIN
                IF ( @CourseID IS NOT NULL ) 
                    BEGIN
                        IF ( @TermID IS NULL ) 
                            BEGIN
                                INSERT  INTO dbo.T_Term_Master
                                        ( I_Brand_ID ,
                                          S_Term_Code ,
                                          S_Term_Name ,
                                          S_Crtd_By ,
                                          Dt_Crtd_On ,
                                          I_Is_Editable ,
                                          I_Status ,
                                          I_Total_Session_Count
				                )
                                VALUES  ( @iBrandID , -- I_Brand_ID - int
                                          @Term , -- S_Term_Code - varchar(50)
                                          @Term , -- S_Term_Name - varchar(250)
                                          'dba' , -- S_Crtd_By - varchar(20)
                                          GETDATE() , -- Dt_Crtd_On - datetime
                                          1 , -- I_Is_Editable - int
                                          1 , -- I_Status - int
                                          @SessionDuration  -- I_Total_Session_Count - int
				                )
				        
                                SET @Tid = SCOPE_IDENTITY()
				        
                                UPDATE  dbo.T_Import_Course_Structure
                                SET     TermID = @Tid
                                WHERE   Term = @Term
				        
                                SELECT  @MaxTermSeq = ISNULL(MAX(TTCM.I_Sequence),
                                                             0)
                                FROM    dbo.T_Term_Course_Map TTCM
                                WHERE   I_Course_ID = @CourseID
				        
                                INSERT  INTO dbo.T_Term_Course_Map
                                        ( I_Course_ID ,
                                          I_Term_ID ,
                                          I_Sequence ,
                                          C_Examinable ,
                                          S_Crtd_By ,
                                          Dt_Crtd_On ,
                                          Dt_Valid_From ,
                                          I_Status
				                )
                                VALUES  ( @CourseID , -- I_Course_ID - int
                                          @Tid , -- I_Term_ID - int
                                          @MaxTermSeq + 1 , -- I_Sequence - int
                                          'Y' , -- C_Examinable - char(1)
                                          'dba' , -- S_Crtd_By - varchar(20)
                                          GETDATE() , -- Dt_Crtd_On - datetime
                                          GETDATE() , -- Dt_Valid_From - datetime
                                          1  -- I_Status - int
				                )
				               
                                IF ( @ModuleID IS NULL ) 
                                    BEGIN
                                        INSERT  INTO dbo.T_Module_Master
                                                ( I_Brand_ID ,
                                                  S_Module_Code ,
                                                  S_Module_Name ,
                                                  S_Crtd_By ,
                                                  Dt_Crtd_On ,
                                                  I_Is_Editable ,
                                                  I_Status
				                	        
                                                )
                                        VALUES  ( @iBrandID , -- I_Brand_ID - int
                                                  SUBSTRING(@Module,0,50) , -- S_Module_Code - varchar(50)
                                                  @Module , -- S_Module_Name - varchar(250)
                                                  'dba' , -- S_Crtd_By - varchar(20)
                                                  GETDATE() , -- Dt_Crtd_On - datetime
                                                  1 , -- I_Is_Editable - int
                                                  1  -- I_Status - int
				                	        
                                                )
				                	        
                                        SET @Mid = SCOPE_IDENTITY()
				                	        
                                        UPDATE  dbo.T_Import_Course_Structure
                                        SET     ModuleID = @Mid
                                        WHERE   Module = @Module
				                	        
                                        SELECT  @MaxModuleSeq = ISNULL(MAX(TMTM.I_Sequence),
                                                              0)
                                        FROM    dbo.T_Module_Term_Map TMTM
                                        WHERE   TMTM.I_Term_ID = @Tid
				                	        
                                        INSERT  INTO dbo.T_Module_Term_Map
                                                ( I_Term_ID ,
                                                  I_Module_ID ,
                                                  I_Sequence ,
                                                  C_Examinable ,
                                                  S_Crtd_By ,
                                                  Dt_Valid_From ,
                                                  Dt_Crtd_On ,
                                                  I_Status
				                	                
                                                )
                                        VALUES  ( @Tid , -- I_Term_ID - int
                                                  @Mid , -- I_Module_ID - int
                                                  @MaxModuleSeq + 1 , -- I_Sequence - int
                                                  'Y' , -- C_Examinable - char(1)
                                                  'dba' , -- S_Crtd_By - varchar(20)
                                                  GETDATE() , -- Dt_Valid_From - datetime
                                                  GETDATE() , -- Dt_Crtd_On - datetime
                                                  1  -- I_Status - int
				                	                
                                                )
				                	                
                                        IF ( @SessionID IS NULL ) 
                                            BEGIN
                                                INSERT  INTO dbo.T_Session_Master
                                                        ( I_Session_Type_ID ,
                                                          I_Brand_ID ,
                                                          S_Session_Code ,
                                                          S_Session_Name ,
                                                          N_Session_Duration ,
                                                          S_Crtd_By ,
                                                          S_Session_Topic ,
                                                          Dt_Crtd_On ,
                                                          I_Is_Editable ,
                                                          I_Status ,
                                                          I_Skill_ID
				                	                	        
                                                        )
                                                VALUES  ( @SessionTypeID , -- I_Session_Type_ID - int
                                                          @iBrandID , -- I_Brand_ID - int
                                                          SUBSTRING(@Session,0,10) , -- S_Session_Code - varchar(50)
                                                          @Session , -- S_Session_Name - varchar(250)
                                                          @SessionDuration , -- N_Session_Duration - numeric
                                                          'dba' , -- S_Crtd_By - varchar(20)
                                                          @Session , -- S_Session_Topic - varchar(1000)
                                                          GETDATE() , -- Dt_Crtd_On - datetime
                                                          1 , -- I_Is_Editable - int
                                                          1 , -- I_Status - int
                                                          @SkillID  -- I_Skill_ID - int
				                	                	        
                                                        )
				                	                	        
                                                SET @Sid = SCOPE_IDENTITY()
				                	                	        
                                                UPDATE  dbo.T_Import_Course_Structure
                                                SET     SessionID = @Sid
                                                WHERE   [Session] = @Session
				                	                	        
                                                SELECT  @MaxSessionSeq = ISNULL(MAX(TSMM.I_Sequence),
                                                              0)
                                                FROM    dbo.T_Session_Module_Map TSMM
                                                WHERE   I_Module_ID = @Mid
				                	                	        
                                                INSERT  INTO dbo.T_Session_Module_Map
                                                        ( I_Module_ID ,
                                                          I_Session_ID ,
                                                          I_Sequence ,
                                                          S_Crtd_By ,
                                                          Dt_Valid_From ,
                                                          Dt_Crtd_On ,
                                                          I_Status
				                	                	                
                                                        )
                                                VALUES  ( @Mid , -- I_Module_ID - int
                                                          @Sid , -- I_Session_ID - int
                                                          @MaxSessionSeq + 1 , -- I_Sequence - int
                                                          'dba' , -- S_Crtd_By - varchar(20)
                                                          GETDATE() , -- Dt_Valid_From - datetime
                                                          GETDATE() , -- Dt_Crtd_On - datetime
                                                          1  -- I_Status - int
				                	                	                
                                                        )
                                            END
                                    END
                                    
                                ELSE 
                                    IF ( @ModuleID IS NOT NULL ) 
                                        BEGIN
                                            SELECT  @MaxModuleSeq = ISNULL(MAX(TMTM.I_Sequence),
                                                              0)
                                            FROM    dbo.T_Module_Term_Map TMTM
                                            WHERE   TMTM.I_Term_ID = @Tid
                                            
                                            IF NOT EXISTS ( SELECT
                                                              *
                                                            FROM
                                                              dbo.T_Module_Term_Map TMTM
                                                            WHERE
                                                              TMTM.I_Module_ID = @ModuleID
                                                              AND TMTM.I_Term_ID = @Tid
                                                              AND TMTM.I_Status = 1 ) 
                                                BEGIN
                                                    INSERT  INTO dbo.T_Module_Term_Map
                                                            ( I_Term_ID ,
                                                              I_Module_ID ,
                                                              I_Sequence ,
                                                              C_Examinable ,
                                                              S_Crtd_By ,
                                                              Dt_Valid_From ,
                                                              Dt_Crtd_On ,
                                                              I_Status
				                	                
                                                            )
                                                    VALUES  ( @Tid , -- I_Term_ID - int
                                                              @ModuleID , -- I_Module_ID - int
                                                              @MaxModuleSeq
                                                              + 1 , -- I_Sequence - int
                                                              'Y' , -- C_Examinable - char(1)
                                                              'dba' , -- S_Crtd_By - varchar(20)
                                                              GETDATE() , -- Dt_Valid_From - datetime
                                                              GETDATE() , -- Dt_Crtd_On - datetime
                                                              1  -- I_Status - int
				                	                
                                                            )
                                                END
                                                
                                            IF ( @SessionID IS NULL ) 
                                                BEGIN
                                                    INSERT  INTO dbo.T_Session_Master
                                                            ( I_Session_Type_ID ,
                                                              I_Brand_ID ,
                                                              S_Session_Code ,
                                                              S_Session_Name ,
                                                              N_Session_Duration ,
                                                              S_Crtd_By ,
                                                              S_Session_Topic ,
                                                              Dt_Crtd_On ,
                                                              I_Is_Editable ,
                                                              I_Status ,
                                                              I_Skill_ID
				                	                	        
                                                            )
                                                    VALUES  ( @SessionTypeID , -- I_Session_Type_ID - int
                                                              @iBrandID , -- I_Brand_ID - int
                                                              SUBSTRING(@Session,0,10) , -- S_Session_Code - varchar(50)
                                                              @Session , -- S_Session_Name - varchar(250)
                                                              @SessionDuration , -- N_Session_Duration - numeric
                                                              'dba' , -- S_Crtd_By - varchar(20)
                                                              @Session , -- S_Session_Topic - varchar(1000)
                                                              GETDATE() , -- Dt_Crtd_On - datetime
                                                              1 , -- I_Is_Editable - int
                                                              1 , -- I_Status - int
                                                              @SkillID  -- I_Skill_ID - int
				                	                	        
                                                            )
				                	                	        
                                                    SET @Sid = SCOPE_IDENTITY()
				                	                	        
                                                    UPDATE  dbo.T_Import_Course_Structure
                                                    SET     SessionID = @Sid
                                                    WHERE   [Session] = @Session
				                	                	        
                                                    SELECT  @MaxSessionSeq = ISNULL(MAX(TSMM.I_Sequence),
                                                              0)
                                                    FROM    dbo.T_Session_Module_Map TSMM
                                                    WHERE   I_Module_ID = @ModuleID
				                	                	        
                                                    INSERT  INTO dbo.T_Session_Module_Map
                                                            ( I_Module_ID ,
                                                              I_Session_ID ,
                                                              I_Sequence ,
                                                              S_Crtd_By ,
                                                              Dt_Valid_From ,
                                                              Dt_Crtd_On ,
                                                              I_Status
				                	                	                
                                                            )
                                                    VALUES  ( @ModuleID , -- I_Module_ID - int
                                                              @Sid , -- I_Session_ID - int
                                                              @MaxSessionSeq
                                                              + 1 , -- I_Sequence - int
                                                              'dba' , -- S_Crtd_By - varchar(20)
                                                              GETDATE() , -- Dt_Valid_From - datetime
                                                              GETDATE() , -- Dt_Crtd_On - datetime
                                                              1  -- I_Status - int
				                	                	                
                                                            )
                                                END
                                        
                                        
                                        END
				                
				                
				                
				                
                            END
                            
                        ELSE 
                            IF ( @TermID IS NOT NULL ) 
                                BEGIN
                                    SELECT  @MaxTermSeq = ISNULL(MAX(TTCM.I_Sequence),0)
                                    FROM    dbo.T_Term_Course_Map TTCM
                                    WHERE   I_Course_ID = @CourseID
                                    
                                    IF NOT EXISTS(SELECT * FROM dbo.T_Term_Course_Map TTCM WHERE TTCM.I_Course_ID=@CourseID AND TTCM.I_Term_ID=@TermID AND TTCM.I_Status=1)
									BEGIN
                                    INSERT  INTO dbo.T_Term_Course_Map
                                            ( I_Course_ID ,
                                              I_Term_ID ,
                                              I_Sequence ,
                                              C_Examinable ,
                                              S_Crtd_By ,
                                              Dt_Crtd_On ,
                                              Dt_Valid_From ,
                                              I_Status
				                    )
                                    VALUES  ( @CourseID , -- I_Course_ID - int
                                              @TermID , -- I_Term_ID - int
                                              @MaxTermSeq + 1 , -- I_Sequence - int
                                              'Y' , -- C_Examinable - char(1)
                                              'dba' , -- S_Crtd_By - varchar(20)
                                              GETDATE() , -- Dt_Crtd_On - datetime
                                              GETDATE() , -- Dt_Valid_From - datetime
                                              1  -- I_Status - int
				                    )
				                    END
				                
                                    IF ( @ModuleID IS NULL ) 
                                        BEGIN
                                            INSERT  INTO dbo.T_Module_Master
                                                    ( I_Brand_ID ,
                                                      S_Module_Code ,
                                                      S_Module_Name ,
                                                      S_Crtd_By ,
                                                      Dt_Crtd_On ,
                                                      I_Is_Editable ,
                                                      I_Status
				                	        
                                                    )
                                            VALUES  ( @iBrandID , -- I_Brand_ID - int
                                                      SUBSTRING(@Module,0,50) , -- S_Module_Code - varchar(50)
                                                      @Module , -- S_Module_Name - varchar(250)
                                                      'dba' , -- S_Crtd_By - varchar(20)
                                                      GETDATE() , -- Dt_Crtd_On - datetime
                                                      1 , -- I_Is_Editable - int
                                                      1  -- I_Status - int
				                	        
                                                    )
				                	        
                                            SET @Mid = SCOPE_IDENTITY()
				                	        
                                            UPDATE  dbo.T_Import_Course_Structure
                                            SET     ModuleID = @Mid
                                            WHERE   Module = @Module
				                	        
                                            SELECT  @MaxModuleSeq = ISNULL(MAX(TMTM.I_Sequence),0)
                                            FROM    dbo.T_Module_Term_Map TMTM
                                            WHERE   TMTM.I_Term_ID = @TermID
				                	        
                                            INSERT  INTO dbo.T_Module_Term_Map
                                                    ( I_Term_ID ,
                                                      I_Module_ID ,
                                                      I_Sequence ,
                                                      C_Examinable ,
                                                      S_Crtd_By ,
                                                      Dt_Valid_From ,
                                                      Dt_Crtd_On ,
                                                      I_Status
				                	                
                                                    )
                                            VALUES  ( @TermID , -- I_Term_ID - int
                                                      @Mid , -- I_Module_ID - int
                                                      @MaxModuleSeq + 1 , -- I_Sequence - int
                                                      'Y' , -- C_Examinable - char(1)
                                                      'dba' , -- S_Crtd_By - varchar(20)
                                                      GETDATE() , -- Dt_Valid_From - datetime
                                                      GETDATE() , -- Dt_Crtd_On - datetime
                                                      1  -- I_Status - int
				                	                
                                                    )
				                	                
                                            IF ( @SessionID IS NULL ) 
                                                BEGIN
                                                    INSERT  INTO dbo.T_Session_Master
                                                            ( I_Session_Type_ID ,
                                                              I_Brand_ID ,
                                                              S_Session_Code ,
                                                              S_Session_Name ,
                                                              N_Session_Duration ,
                                                              S_Crtd_By ,
                                                              S_Session_Topic ,
                                                              Dt_Crtd_On ,
                                                              I_Is_Editable ,
                                                              I_Status ,
                                                              I_Skill_ID
				                	                	        
                                                            )
                                                    VALUES  ( @SessionTypeID , -- I_Session_Type_ID - int
                                                              @iBrandID , -- I_Brand_ID - int
                                                              SUBSTRING(@Session,0,10) , -- S_Session_Code - varchar(50)
                                                              @Session , -- S_Session_Name - varchar(250)
                                                              @SessionDuration , -- N_Session_Duration - numeric
                                                              'dba' , -- S_Crtd_By - varchar(20)
                                                              @Session , -- S_Session_Topic - varchar(1000)
                                                              GETDATE() , -- Dt_Crtd_On - datetime
                                                              1 , -- I_Is_Editable - int
                                                              1 , -- I_Status - int
                                                              @SkillID  -- I_Skill_ID - int
				                	                	        
                                                            )
				                	                	        
                                                    SET @Sid = SCOPE_IDENTITY()
				                	                	        
                                                    UPDATE  dbo.T_Import_Course_Structure
                                                    SET     SessionID = @Sid
                                                    WHERE   [Session] = @Session
				                	                	        
                                                    SELECT  @MaxSessionSeq = ISNULL(MAX(TSMM.I_Sequence),
                                                              0)
                                                    FROM    dbo.T_Session_Module_Map TSMM
                                                    WHERE   I_Module_ID = @Mid
				                	                	        
                                                    INSERT  INTO dbo.T_Session_Module_Map
                                                            ( I_Module_ID ,
                                                              I_Session_ID ,
                                                              I_Sequence ,
                                                              S_Crtd_By ,
                                                              Dt_Valid_From ,
                                                              Dt_Crtd_On ,
                                                              I_Status
				                	                	                
                                                            )
                                                    VALUES  ( @Mid , -- I_Module_ID - int
                                                              @Sid , -- I_Session_ID - int
                                                              @MaxSessionSeq
                                                              + 1 , -- I_Sequence - int
                                                              'dba' , -- S_Crtd_By - varchar(20)
                                                              GETDATE() , -- Dt_Valid_From - datetime
                                                              GETDATE() , -- Dt_Crtd_On - datetime
                                                              1  -- I_Status - int
				                	                	                
                                                            )
                                                END
                                        END
                                    
                                    ELSE 
                                        IF ( @ModuleID IS NOT NULL ) 
                                            BEGIN
                                                SELECT  @MaxModuleSeq = MAX(TMTM.I_Sequence)
                                                FROM    dbo.T_Module_Term_Map TMTM
                                                WHERE   TMTM.I_Term_ID = @TermID
                                                
                                                IF NOT EXISTS ( SELECT
                                                              *
                                                            FROM
                                                              dbo.T_Module_Term_Map TMTM
                                                            WHERE
                                                              TMTM.I_Module_ID = @ModuleID
                                                              AND TMTM.I_Term_ID = @TermID
                                                              AND TMTM.I_Status = 1 )
                                                               
												BEGIN
                                                INSERT  INTO dbo.T_Module_Term_Map
                                                        ( I_Term_ID ,
                                                          I_Module_ID ,
                                                          I_Sequence ,
                                                          C_Examinable ,
                                                          S_Crtd_By ,
                                                          Dt_Valid_From ,
                                                          Dt_Crtd_On ,
                                                          I_Status
				                	                
                                                        )
                                                VALUES  ( @TermID , -- I_Term_ID - int
                                                          @ModuleID , -- I_Module_ID - int
                                                          @MaxModuleSeq + 1 , -- I_Sequence - int
                                                          'Y' , -- C_Examinable - char(1)
                                                          'dba' , -- S_Crtd_By - varchar(20)
                                                          GETDATE() , -- Dt_Valid_From - datetime
                                                          GETDATE() , -- Dt_Crtd_On - datetime
                                                          1  -- I_Status - int
				                	                
                                                        )
                                                END
                                                IF ( @SessionID IS NULL ) 
                                                    BEGIN
                                                        INSERT
                                                              INTO dbo.T_Session_Master
                                                              ( 
                                                              I_Session_Type_ID ,
                                                              I_Brand_ID ,
                                                              S_Session_Code ,
                                                              S_Session_Name ,
                                                              N_Session_Duration ,
                                                              S_Crtd_By ,
                                                              S_Session_Topic ,
                                                              Dt_Crtd_On ,
                                                              I_Is_Editable ,
                                                              I_Status ,
                                                              I_Skill_ID
				                	                	        
                                                              )
                                                        VALUES
                                                              ( 
                                                              @SessionTypeID , -- I_Session_Type_ID - int
                                                              @iBrandID , -- I_Brand_ID - int
                                                              SUBSTRING(@Session,0,10) , -- S_Session_Code - varchar(50)
                                                              @Session , -- S_Session_Name - varchar(250)
                                                              @SessionDuration , -- N_Session_Duration - numeric
                                                              'dba' , -- S_Crtd_By - varchar(20)
                                                              @Session , -- S_Session_Topic - varchar(1000)
                                                              GETDATE() , -- Dt_Crtd_On - datetime
                                                              1 , -- I_Is_Editable - int
                                                              1 , -- I_Status - int
                                                              @SkillID  -- I_Skill_ID - int
				                	                	        
                                                              )
				                	                	        
                                                        SET @Sid = SCOPE_IDENTITY()
				                	                	        
                                                        UPDATE
                                                              dbo.T_Import_Course_Structure
                                                        SET   SessionID = @Sid
                                                        WHERE [Session] = @Session
				                	                	        
                                                        SELECT
                                                              @MaxSessionSeq = ISNULL(MAX(TSMM.I_Sequence),
                                                              0)
                                                        FROM  dbo.T_Session_Module_Map TSMM
                                                        WHERE I_Module_ID = @ModuleID
				                	                	        
                                                        INSERT
                                                              INTO dbo.T_Session_Module_Map
                                                              ( 
                                                              I_Module_ID ,
                                                              I_Session_ID ,
                                                              I_Sequence ,
                                                              S_Crtd_By ,
                                                              Dt_Valid_From ,
                                                              Dt_Crtd_On ,
                                                              I_Status
				                	                	                
                                                              )
                                                        VALUES
                                                              ( 
                                                              @ModuleID , -- I_Module_ID - int
                                                              @Sid , -- I_Session_ID - int
                                                              @MaxSessionSeq
                                                              + 1 , -- I_Sequence - int
                                                              'dba' , -- S_Crtd_By - varchar(20)
                                                              GETDATE() , -- Dt_Valid_From - datetime
                                                              GETDATE() , -- Dt_Crtd_On - datetime
                                                              1  -- I_Status - int
				                	                	                
                                                              )
                                                    END
                                        
                                        
                                            END
				                
                                
                                END
                    END
                    
                FETCH NEXT FROM DataPopulator1
				INTO
				@Course,
				@CourseID,
				@Term,
				@TermID,
				@TotalSessionCount,
				@Module,
				@ModuleID,
				@Session,
				@SessionID,
				@SkillID,
				@SessionDuration,
				@SessionTypeID
	 
            END
            
        CLOSE DataPopulator1 ;
        DEALLOCATE DataPopulator1;
            
             UPDATE  T1
        SET     T1.I_No_Of_Session = T2.NoofSession
        FROM    dbo.T_Module_Master T1
                INNER JOIN ( SELECT TSMM.I_Module_ID ,
                                    COUNT(DISTINCT TSMM.I_Session_ID) AS NoofSession
                             FROM   dbo.T_Import_Course_Structure TICS
                                    INNER JOIN dbo.T_Session_Module_Map TSMM ON TICS.ModuleID = TSMM.I_Module_ID
                             WHERE  TICS.ModuleID IS NOT NULL
                                    AND TSMM.I_Status = 1
                             GROUP BY TSMM.I_Module_ID
                           ) T2 ON T1.I_Module_ID = T2.I_Module_ID
	
	
 
	
       
	
	
	
    END
