CREATE PROCEDURE [ACADEMICS].[uspGetStudentCompletedStatus]
AS 
    BEGIN
        CREATE TABLE #temp
            (
              id INT IDENTITY(1, 1) ,
              StudentID INT
            )

        INSERT  INTO #temp
                ( StudentID 
                )
                SELECT  DISTINCT
                        TSSD.I_Student_Detail_ID
                FROM    dbo.T_Student_Status_Details TSSD
                        INNER JOIN dbo.T_Student_Status_Master TSSM ON TSSD.I_Student_Status_ID = TSSM.I_Student_Status_ID
                WHERE   TSSD.I_Status = 1
                        AND TSSM.I_Status = 1
                        AND TSSD.IsEditable <> 0
                        --AND TSSM.I_Student_Status_ID = 2
                        
                        
        DECLARE @i INT= 1
        DECLARE @std INT
        DECLARE @BatchID INT
        
        
        
        
        WHILE ( @i <= ( SELECT  COUNT(*)
                        FROM    #temp
                      ) ) 
            BEGIN
            
                SELECT  @std = StudentID
                FROM    #temp
                WHERE   id = @i
                
                
                SELECT  @BatchID = TSBD.I_Batch_ID
                FROM    dbo.T_Student_Batch_Details TSBD
                        INNER JOIN ( SELECT T1.StudentID ,
                                            MIN(TSBD.I_Student_Batch_ID) AS MinBatchID
                                     FROM   dbo.T_Student_Batch_Details TSBD
                                            INNER JOIN #temp T1 ON T1.StudentID = TSBD.I_Student_ID
                                     WHERE  T1.StudentID = @std
                                     GROUP BY T1.StudentID
                                   ) TT ON TT.StudentID = TSBD.I_Student_ID
                                           AND TT.MinBatchID = TSBD.I_Student_Batch_ID
                WHERE   TSBD.I_Student_ID = @std
        
        
                IF EXISTS ( SELECT  *
                            FROM    dbo.T_Student_Status_Details TSSD
                                    INNER JOIN dbo.T_Student_Status_Master TSSM ON TSSD.I_Student_Status_ID = TSSM.I_Student_Status_ID
                            WHERE   TSSD.I_Status = 1
                                    AND TSSM.I_Status = 1
                                    AND TSSD.IsEditable <> 0
                                    AND TSSM.I_Student_Status_ID = 5
                                    AND TSSD.I_Student_Detail_ID = @std ) 
                    BEGIN
                        IF ( DATEDIFF(d,
                                      ( SELECT  Dt_BatchStartDate
                                        FROM    dbo.T_Student_Batch_Master
                                        WHERE   I_Batch_ID = @BatchID
                                      ), GETDATE()) >= 1095 ) 
                            BEGIN
                                EXEC ACADEMICS.uspInsertIntoStudentStatusArchive @StudentStatusID = 5, -- int
                                    @StudentID = @std -- int
                                    
                                UPDATE  dbo.T_Student_Status_Details
                                SET     Dt_Crtd_On = GETDATE() ,
                                        S_Crtd_By = 'dba'
                                WHERE   I_Student_Detail_ID = @std
                                        AND I_Status = 1
                                        AND IsEditable = 1
                                        AND I_Student_Status_ID = 5
                            END
        	
                        ELSE 
                            BEGIN
                                EXEC ACADEMICS.uspInsertIntoStudentStatusArchive @StudentStatusID = 5, -- int
                                    @StudentID = @std -- int
                         
                                UPDATE  dbo.T_Student_Status_Details
                        SET     I_Status = 0 ,
                                        Dt_Upd_On = GETDATE() ,
                                        S_Upd_By = 'dba'
                                WHERE   I_Student_Detail_ID = @std
                                        AND I_Status = 1
                                        AND IsEditable = 1
                                        AND I_Student_Status_ID = 5
                            END
                    END 
                    
                ELSE 
                    BEGIN
                    
                        IF ( DATEDIFF(d,
                                      ( SELECT  Dt_BatchStartDate
                                        FROM    dbo.T_Student_Batch_Master
                                        WHERE   I_Batch_ID = @BatchID
                                      ), GETDATE()) >= 1095 ) 
                            BEGIN              
                                INSERT  INTO dbo.T_Student_Status_Details
                                        ( I_Student_Detail_ID ,
                                          I_Student_Status_ID ,
                                          I_Status ,
                                          N_Due ,
                                          Dt_Crtd_On ,
                                          S_Crtd_By ,
                                          IsEditable
        		                      
                                        )
                                VALUES  ( @std , -- I_Student_Detail_ID - int
                                          5 , -- I_Student_Status_ID - int
                                          1 , -- I_Status - int
                                          NULL , -- N_Due - decimal
                                          GETDATE() , -- Dt_Crtd_On - datetime
                                          'dba' , -- S_Crtd_By - varchar(50)
                                          1  -- IsEditable - bit
        		                      
                                        )
                            END         
                    END 
                    
                SET @i = @i + 1                                  
                
            END    
    END
