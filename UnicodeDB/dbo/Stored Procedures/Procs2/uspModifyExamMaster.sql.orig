CREATE PROCEDURE [dbo].[uspModifyExamMaster]
    @iExamID INT ,
    @sExamName VARCHAR(50) ,
    @sExamType VARCHAR(10) ,
    @iExamTypeMaster INT = NULL ,
    @sExamBy VARCHAR(20) ,
    @dExamOn DATETIME ,
    @iFlag INT ,
    @iBrandID INT = NULL ,
    @iCourseId INT = NULL ,
    @IsSubject BIT =NULL,
    @iAdmissionTestOn DATETIME = NULL ,
    @nCutOffPercentage decimal(18, 2)= NULL,
    @iWeightage INT = NULL
AS 
    BEGIN TRY     
        SET NOCOUNT OFF ;    
   
    -- Insert statements for procedure here    
        IF @iFlag = 1 
            BEGIN    
                INSERT  INTO dbo.T_Exam_Component_Master
                        ( S_Component_Name ,
                          S_Component_Type ,
                          I_Exam_Type_Master_ID ,
                          Dt_Admission_Test ,
                          S_Crtd_By ,
                          Dt_Crtd_On ,
                          I_Status ,
                          I_Brand_ID ,
                          I_Course_ID ,
                          B_Is_Subject,
                          N_CutOffPercentage ,
                          I_Weightage     
                        )
                VALUES  ( @sExamName ,
                          @sExamType ,
                          @iExamTypeMaster ,
                          @iAdmissionTestOn ,
                          @sExamBy ,
                          @dExamOn ,
                          1 ,
                          @iBrandID ,
                          @iCourseId ,
                          @IsSubject ,
                          @nCutOffPercentage ,
                          @iWeightage   
                        )        
            END    
        ELSE 
            IF @iFlag = 2 
                BEGIN    
                    UPDATE  dbo.T_Exam_Component_Master
                    SET     S_Component_Name = @sExamName ,
                            S_Component_Type = @sExamType ,
                            I_Exam_Type_Master_ID = @iExamTypeMaster ,
                            S_Upd_By = @sExamBy ,
                            Dt_Upd_On = @dExamOn ,
                            I_Brand_ID = @iBrandID ,
                            I_Course_ID = @iCourseId ,
                            Dt_Admission_Test = @iAdmissionTestOn ,
                            N_CutOffPercentage = @nCutOffPercentage ,
                            I_Weightage = @iWeightage
                    WHERE   I_Exam_Component_ID = @iExamID    
                END    
            ELSE 
                IF @iFlag = 3 
                    BEGIN    
                        UPDATE  dbo.T_Exam_Component_Master
                        SET     I_Status = 0 ,
                                S_Upd_By = @sExamBy ,
                                Dt_Upd_On = @dExamOn
                        WHERE   I_Exam_Component_ID = @iExamID    
                    END   
                ELSE 
                    IF @iFlag = 4 
                        BEGIN    
                            UPDATE  dbo.T_Exam_Component_Master
                            SET     I_Status = 0 ,
                                    S_Upd_By = @sExamBy ,
                                    Dt_Upd_On = @dExamOn
                            WHERE   I_Exam_Component_ID = @iExamID    
                        END   
    END TRY    
    BEGIN CATCH    
 --Error occurred:      
    
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()    
    
        RAISERROR(@ErrMsg, @ErrSeverity, 1)    
    END CATCH
