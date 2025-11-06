
CREATE PROCEDURE [STUDENTFEATURES].[uspGetStudentFeedbackRecord]
    (
      @iStudentID INT ,
      @iCourseID INT ,
      @iTermID INT = NULL ,
      @iModuleID INT = NULL,
      @iFacultyID INT=NULL  
    )
AS
    BEGIN TRY  
  
        SET NOCOUNT ON
        --akash
        DECLARE @count INT
        SET @count = 1
        DECLARE @examdate DATE
        DECLARE @duration INT
                
        SET @examdate = '2021-04-15'
        SET @duration = DATEDIFF(d, '2021-04-01', '2021-04-15') + 1
                
        IF ( GETDATE() >= DATEADD(d, -@duration, @examdate)
             AND GETDATE() < @examdate
           )
            BEGIN
                --akash   
                IF @iModuleID IS NOT NULL
                    AND @iTermID IS NOT NULL
                    AND @iFacultyID IS NOT NULL
                    BEGIN
                        DECLARE @iStudentModuleID INT 
                
  
 -- Select the Student Module Detail ID  
                        SELECT  @iStudentModuleID = I_Student_Module_Detail_ID
                        FROM    dbo.T_Student_Module_Detail
                        WHERE   I_Student_Detail_ID = @iStudentID
                                AND I_Course_ID = @iCourseID
                                AND I_Term_ID = @iTermID
                                AND I_Module_ID = @iModuleID
                 --akash
                        DECLARE @dtDate1 DATETIME;
                        SELECT  @dtDate1 = MAX(Dt_Crtd_On)
                        FROM    STUDENTFEATURES.T_Student_Feedback
                        WHERE   I_Student_Module_Detail_ID = @iStudentModuleID 
                
                --akash       
                          
   
                        SELECT  COUNT(*)
                        FROM    STUDENTFEATURES.T_Student_Feedback
                        WHERE   I_Student_Module_Detail_ID = @iStudentModuleID
								AND I_Employee_ID=@iFacultyID 
                --AND DATEDIFF(d,@dtDate1,GETDATE())<60--akash 
                                AND @dtDate1 BETWEEN DATEADD(d, -@duration,
                                                             @examdate)
                                             AND     @examdate--akash
                    END
                ELSE
                    BEGIN 
                        DECLARE @S_Student_ID VARCHAR(255)  
                        SELECT  @S_Student_ID = S_Student_ID
                        FROM    dbo.T_Student_Detail
                        WHERE   I_Student_Detail_ID = @iStudentID
                
                --akash
                        DECLARE @dtDate DATETIME;
                        SELECT  @dtDate = MAX(Dt_Crtd_On)
                        FROM    STUDENTFEATURES.T_Student_Feedback
                        WHERE   I_Course_ID = @iCourseID
                                AND S_Crtd_By = @S_Student_ID
                --akash        
                        
                        SELECT  COUNT(*)
                        FROM    STUDENTFEATURES.T_Student_Feedback
                        WHERE   I_Course_ID = @iCourseID
                                AND S_Crtd_By = @S_Student_ID
                        --AND DATEDIFF(d,@dtDate,GETDATE())<60--akash
                                AND @dtDate1 BETWEEN DATEADD(d, -@duration,
                                                             @examdate)
                                             AND     @examdate--akash
                    END
            END
        ELSE
            BEGIN
                SELECT  @count
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
