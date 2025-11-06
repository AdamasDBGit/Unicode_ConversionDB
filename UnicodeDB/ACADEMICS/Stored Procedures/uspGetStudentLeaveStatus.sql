
CREATE PROCEDURE [ACADEMICS].[uspGetStudentLeaveStatus]

AS 
    BEGIN
    
    DECLARE @dtDate DATE=GETDATE()
    
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
        
        
        
        WHILE ( @i <= ( SELECT  COUNT(*)
                        FROM    #temp
                      ) ) 
            BEGIN
            
                SELECT  @std = StudentID
                FROM    #temp
                WHERE   id = @i
                
                IF EXISTS ( SELECT  *
                            FROM    dbo.T_Student_Status_Details TSSD
                                    INNER JOIN dbo.T_Student_Status_Master TSSM ON TSSD.I_Student_Status_ID = TSSM.I_Student_Status_ID
                            WHERE   TSSD.I_Status = 1
                                    AND TSSM.I_Status = 1
                                    AND TSSD.IsEditable <> 0
                                    AND TSSM.I_Student_Status_ID = 6
                                    AND TSSD.I_Student_Detail_ID = @std ) 
                    BEGIN
                        IF EXISTS ( SELECT  *
                                    FROM    dbo.T_Student_Leave_Request TSLR
                                    WHERE   I_Student_Detail_ID = @std
                                            AND TSLR.I_Status = 1
                                            AND @dtDate BETWEEN TSLR.Dt_From_Date
                                                          AND TSLR.Dt_To_Date ) 
                            BEGIN
                                EXEC ACADEMICS.uspInsertIntoStudentStatusArchive @StudentStatusID = 6, -- int
                                    @StudentID = @std -- int
                                    
                                UPDATE  dbo.T_Student_Status_Details
                                SET     Dt_Crtd_On = GETDATE() ,
                                        S_Crtd_By = 'dba'
                                WHERE   I_Student_Detail_ID = @std
                                        AND I_Status = 1
                                        AND IsEditable = 1
                                        AND I_Student_Status_ID = 6
                            END
					
                        ELSE 
                            BEGIN
                                EXEC ACADEMICS.uspInsertIntoStudentStatusArchive @StudentStatusID = 6, -- int
                                    @StudentID = @std -- int
                         
                                UPDATE  dbo.T_Student_Status_Details
                                SET     I_Status = 0 ,
                                        Dt_Upd_On = GETDATE() ,
                                        S_Upd_By = 'dba'
                                WHERE   I_Student_Detail_ID = @std
                                        AND I_Status = 1
                                        AND IsEditable = 1
                                        AND I_Student_Status_ID = 6
                            END
                    END
                    
                ELSE 
                    BEGIN
                        IF EXISTS ( SELECT  *
                                    FROM    dbo.T_Student_Leave_Request TSLR
                                    WHERE   I_Student_Detail_ID = @std
                                            AND TSLR.I_Status = 1
                                            AND @dtDate BETWEEN TSLR.Dt_From_Date
                                                          AND TSLR.Dt_To_Date ) 
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
                                          6 , -- I_Student_Status_ID - int
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
