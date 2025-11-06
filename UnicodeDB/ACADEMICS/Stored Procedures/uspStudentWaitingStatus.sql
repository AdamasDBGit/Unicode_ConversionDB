
CREATE PROCEDURE [ACADEMICS].[uspStudentWaitingStatus]
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
                SELECT  TSSD.I_Student_Detail_ID
                FROM    dbo.T_Student_Status_Details TSSD WITH (NOLOCK)
                        INNER JOIN dbo.T_Student_Status_Master TSSM WITH (NOLOCK) ON TSSD.I_Student_Status_ID = TSSM.I_Student_Status_ID
                WHERE   TSSD.I_Status = 1
                        AND TSSM.I_Status = 1
                        AND TSSD.IsEditable <> 0
                        AND TSSM.I_Student_Status_ID = 2
	
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
                            FROM    dbo.T_Student_Attendance TSA
                            WHERE   I_Student_Detail_ID = @std ) 
                    BEGIN
                        EXEC ACADEMICS.uspInsertIntoStudentStatusArchive @StudentStatusID = 2, -- int
                            @StudentID = @std -- int
                        
			
			
                        UPDATE  dbo.T_Student_Status_Details
                        SET     I_Status = 0 ,
                                Dt_Upd_On = GETDATE() ,
                                S_Upd_By = 'dba'
                        WHERE   I_Student_Detail_ID = @std
                                AND I_Status = 1
                                AND IsEditable = 1
                                AND I_Student_Status_ID = 2
                                       
			
			
                    END
                    
                ELSE 
                    BEGIN
                        EXEC ACADEMICS.uspInsertIntoStudentStatusArchive @StudentStatusID = 2, -- int
                            @StudentID = @std -- int
                            
                        UPDATE  dbo.T_Student_Status_Details
                        SET     Dt_Crtd_On = GETDATE() ,
                                S_Crtd_By = 'dba'
                        WHERE   I_Student_Detail_ID = @std
                                AND I_Status = 1
                                AND IsEditable = 1
                                AND I_Student_Status_ID = 2  
                    END
                SET @i = @i + 1
            END
    END
