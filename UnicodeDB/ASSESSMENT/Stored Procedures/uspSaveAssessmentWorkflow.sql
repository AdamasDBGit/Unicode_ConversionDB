CREATE PROCEDURE [ASSESSMENT].[uspSaveAssessmentWorkflow]              
(            
 @iAssessmentID int,            
 @iRuleID INT,            
 @sEvaluatedTrueCategory varchar(20),            
 @iEvaluatedTrueAssessmentID INT = NULL,            
 @sEvaluatedTrueCourseListXML varchar(MAX) = NULL,        
 @iEvaluatedTrueRuleID INT = NULL,    
 @sEvaluatedFalseCategory VARCHAR(20),            
 @iEvaluatedFalseAssessmentID INT = NULL,            
 @sEvaluatedFalseCourseListXML varchar(MAX) = NULL,    
 @iEvaluatedFalseRuleID INT = NULL,           
 @iStatus int,            
 @sCrtdBy varchar(20) = NULL,            
 @sUpdtBy VARCHAR(20) = NULL,            
 @dtCrtdOn DATETIME = NULL,            
 @dtUpdtOn DATETIME = NULL             
)            
AS             
BEGIN TRY            
  DECLARE @iEvaluatedTrueCourseListID INT,@iEvaluatedFalseCourseListID INT            
              
  BEGIN TRANSACTION            
            
  IF(@sEvaluatedTrueCategory = 'ASSESSMENT')          
  BEGIN          
 IF NOT EXISTS(SELECT * FROM ASSESSMENT.T_Assessment_Rule_Workflow AS tarw WHERE tarw.I_PreAssessment_ID = @iEvaluatedTrueAssessmentID AND I_Status = 1)          
  BEGIN          
   RAISERROR          
     (N'The workflow for the selected assessment(s) is not complete. Please complete the workflow for the selected assessment test.',          
     16,          
     1);          
  END          
  END           
  ELSE IF(@sEvaluatedFalseCategory = 'ASSESSMENT')          
  BEGIN          
 IF NOT EXISTS(SELECT * FROM ASSESSMENT.T_Assessment_Rule_Workflow AS tarw WHERE tarw.I_PreAssessment_ID = @iEvaluatedFalseAssessmentID AND I_Status = 1)          
  BEGIN          
   RAISERROR          
     (N'The workflow for the selected assessment(s) is not complete. Please complete the workflow for the selected assessment test.',          
     16,          
     1);          
  END          
  END     
      
  IF(@sEvaluatedTrueCategory = 'RULE')          
  BEGIN          
 IF NOT EXISTS(SELECT * FROM ASSESSMENT.T_Assessment_Rule_Workflow AS tarw WHERE tarw.I_Rule_ID = @iEvaluatedTrueRuleID)          
   BEGIN          
    RAISERROR          
   (N'The workflow for the selected rule is not complete. Please complete the workflow for the selected rule.',          
   16,          
   1);          
   END          
  END          
  ELSE IF(@sEvaluatedFalseCategory = 'RULE')          
  BEGIN          
  IF NOT EXISTS(SELECT * FROM ASSESSMENT.T_Assessment_Rule_Workflow AS tarw WHERE tarw.I_Rule_ID = @iEvaluatedFalseRuleID)          
   BEGIN          
    RAISERROR          
   (N'The workflow for the selected rule is not complete. Please complete the workflow for the selected rule.',          
   16,          
   1);          
 END          
  END     
            
  UPDATE ASSESSMENT.T_Assessment_Rule_Workflow SET I_Status = 0,S_Updt_By = @sUpdtBy,Dt_Updt_On = @dtUpdtOn            
  WHERE I_PreAssessment_ID = @iAssessmentID AND I_Rule_ID = @iRuleID AND I_Status = 1            
              
  declare @xml_hndl int            
  IF(@sEvaluatedTrueCourseListXML IS NOT NULL)            
  BEGIN            
              
  UPDATE ASSESSMENT.T_Rule_CourseList_Map             
  SET I_Status = 0,S_Updt_By = @sUpdtBy,Dt_Updt_On = @dtUpdtOn            
  WHERE I_Rule_ID = @iRuleID AND I_Status = 1 AND B_Is_Evaluated_True = 1            
              
  INSERT INTO ASSESSMENT.T_Rule_CourseList_Map            
          ( I_Rule_ID ,            
            B_Is_Evaluated_True,            
            I_Status ,            
            S_Crtd_By ,            
            Dt_Crtd_On            
          )            
  VALUES  ( @iRuleID , -- I_Rule_ID - int            
            1 , -- I_Status - int            
            1,            
            @sCrtdBy , -- S_Crtd_By - varchar(20)            
            @dtCrtdOn -- Dt_Crtd_On - datetime            
          )            
              
  SELECT @iEvaluatedTrueCourseListID = @@IDENTITY            
              
  exec sp_xml_preparedocument @xml_hndl OUTPUT, @sEvaluatedTrueCourseListXML            
  INSERT INTO ASSESSMENT.T_Assessment_CourseList_Course_Map            
          ( I_Course_List_ID, I_Course_ID )            
   SELECT                
            @iEvaluatedTrueCourseListID,CourseID            
  FROM            
            OPENXML(@xml_hndl, '/Root/Course', 1)                
            With                
                        (                
       CourseID int '@ID'                
                        )                
                  
  END            
  IF(@sEvaluatedFalseCourseListXML IS NOT NULL)            
  BEGIN            
              
  UPDATE ASSESSMENT.T_Rule_CourseList_Map             
  SET I_Status = 0,S_Updt_By = @sUpdtBy,Dt_Updt_On = @dtUpdtOn            
  WHERE I_Rule_ID = @iRuleID AND I_Status = 1 AND B_Is_Evaluated_True = 0            
              
  INSERT INTO ASSESSMENT.T_Rule_CourseList_Map            
          ( I_Rule_ID ,            
      B_Is_Evaluated_True,            
            I_Status ,            
            S_Crtd_By ,            
            Dt_Crtd_On            
          )            
  VALUES  ( @iRuleID , -- I_Rule_ID - int            
            0 , -- I_Status - int            
            1,            
            @sCrtdBy , -- S_Crtd_By - varchar(20)            
            @dtCrtdOn -- Dt_Crtd_On - datetime            
          )            
             
  SELECT @iEvaluatedFalseCourseListID = @@IDENTITY            
              
  exec sp_xml_preparedocument @xml_hndl OUTPUT, @sEvaluatedFalseCourseListXML            
  INSERT INTO ASSESSMENT.T_Assessment_CourseList_Course_Map            
          ( I_Course_List_ID, I_Course_ID )            
   SELECT                
            @iEvaluatedFalseCourseListID,CourseID            
  FROM            
            OPENXML(@xml_hndl, '/Root/Course', 1)                
            With                
                        (                
       CourseID int '@ID'                
                       )                
                  
  END            
              
  INSERT INTO ASSESSMENT.T_Assessment_Rule_Workflow            
          ( I_PreAssessment_ID ,            
            I_Rule_ID ,            
            S_Evaluated_True_Category ,            
            I_Evaluated_True_Assessment_ID ,            
            I_Evaluated_True_CourseList_ID ,      
            I_Evaluated_True_Rule_ID ,          
            S_Evaluated_False_Category ,            
            I_Evaluated_False_Assessment_ID ,            
            I_Evaluated_False_CourseList_ID ,      
            I_Evaluated_False_Rule_ID ,          
            I_Status ,            
            S_Crtd_By ,            
            Dt_Crtd_On            
          )            
  VALUES  ( @iAssessmentID , -- I_PreAssessment_ID - int            
            @iRuleID , -- I_Rule_ID - int            
            @sEvaluatedTrueCategory , -- S_Evaluated_True_Category - varchar(20)            
            @iEvaluatedTrueAssessmentID , -- I_Evaluated_True_Assessment_ID - int            
            @iEvaluatedTrueCourseListID , -- I_Evaluated_True_CourseList_ID - int     
            @iEvaluatedTrueRuleID ,           
            @sEvaluatedFalseCategory , -- S_Evaluated_False_Category - varchar(20)            
            @iEvaluatedFalseAssessmentID , -- I_Evaluated_False_Assessment_ID - int            
            @iEvaluatedFalseCourseListID , -- I_Evaluated_False_CourseList_ID - int            
            @iEvaluatedFalseRuleID ,    
            1 , -- I_Status - int            
            @sCrtdBy , -- S_Crtd_By - varchar(20)            
            @dtCrtdOn  -- Dt_Crtd_On - datetime            
          )            
   COMMIT TRANSACTION            
END TRY             
BEGIN CATCH            
 --Error occurred:              
 ROLLBACK TRANSACTION            
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int            
 SELECT @ErrMsg = ERROR_MESSAGE(),            
   @ErrSeverity = ERROR_SEVERITY()            
            
 RAISERROR(@ErrMsg, @ErrSeverity, 1)            
END CATCH
