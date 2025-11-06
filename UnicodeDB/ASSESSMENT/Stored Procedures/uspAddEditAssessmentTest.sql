CREATE PROCEDURE [ASSESSMENT].[uspAddEditAssessmentTest]          
(          
    @iAssessmentTestID INT = null,          
    @sAssessmentTestCode varchar(50),        
    @sAssessmentTestName varchar(200),        
    @iStatus int,        
    @iBrandId int,        
    @sCrtdBy varchar(20) = null,        
    @dtCrtdOn datetime = NULL,        
    @sUpdtBy varchar(20) = NULL,        
    @dtUpdtOn datetime = null         
)          
AS          
BEGIN         
BEGIN TRY      
 IF(@iAssessmentTestID IS NULL)        
  BEGIN        
   INSERT INTO ASSESSMENT.T_PreAssessment_Master        
           ( I_Brand_ID ,        
             S_PreAssessment_Code ,        
             S_PreAssessment_Name ,        
             I_Status ,        
             S_Crtd_By ,        
             S_Upd_By ,        
             Dt_Crtd_On ,        
             Dt_Upd_On        
           )        
   VALUES  ( @iBrandId , -- I_Brand_ID - int        
             @sAssessmentTestCode , -- S_PreAssessment_Code - varchar(50)        
             @sAssessmentTestName , -- S_PreAssessment_Name - varchar(200)        
             @iStatus , -- I_Status - int        
             @sCrtdBy , -- S_Crtd_By - varchar(20)        
             NULL , -- S_Upd_By - varchar(20)        
             @dtCrtdOn , -- Dt_Crtd_On - datetime        
             NULL  -- Dt_Upd_On - datetime        
           )        
   SELECT @@IDENTITY        
  END        
 ELSE IF(@iStatus = 0)        
  BEGIN        
  IF EXISTS (SELECT I_PreAssessment_ID FROM ASSESSMENT.T_Assessment_Rule_Workflow AS tarw WHERE tarw.I_PreAssessment_ID = @iAssessmentTestID  AND tarw.I_Status = 1)      
   BEGIN      
     RAISERROR ('Assessment associated with a workflow, hence cannot be deleted.', 16, 1 );      
   END      
  ELSE      
   BEGIN      
    UPDATE ASSESSMENT.T_PreAssessment_Master SET         
    I_Status = @iStatus,        
    S_Upd_By = @sUpdtBy,        
    Dt_Upd_On = @dtUpdtOn        
    WHERE I_PreAssessment_ID = @iAssessmentTestID        
          
    DELETE FROM ASSESSMENT.T_PreAssessment_ExamComponent_Mapping WHERE I_PreAssessment_ID = @iAssessmentTestID            
   END       
        
  END        
 ELSE         
  BEGIN        
   UPDATE ASSESSMENT.T_PreAssessment_Master SET         
       S_PreAssessment_Code = @sAssessmentTestCode,        
       S_PreAssessment_Name = @sAssessmentTestName,        
       I_Status = @iStatus,        
       S_Upd_By = @sUpdtBy,        
       Dt_Upd_On = @dtUpdtOn        
   WHERE I_PreAssessment_ID = @iAssessmentTestID        
   SELECT @iAssessmentTestID        
  END        
        
END TRY      
BEGIN CATCH      
      
    DECLARE @ErrorMessage NVARCHAR(4000);      
    DECLARE @ErrorSeverity INT;      
    DECLARE @ErrorState INT;      
      
    SELECT       
        @ErrorMessage = ERROR_MESSAGE(),      
        @ErrorSeverity = ERROR_SEVERITY(),      
        @ErrorState = ERROR_STATE();      
      
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState );      
          
END CATCH      
END
