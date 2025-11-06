CREATE PROCEDURE [ASSESSMENT].[uspSaveStudentSuggestions]         
(      
 @iNextAssessmentId INT = NULL,      
 @iEnquiryID INT,      
 @iCourseList INT = NULL            
)      
AS             
BEGIN   
IF(@iNextAssessmentId IS NOT NULL)    
 BEGIN    
  IF NOT EXISTS(SELECT * FROM ASSESSMENT.T_Student_Assessment_Map WHERE I_Enquiry_Regn_ID = @iEnquiryID AND I_PreAssessment_ID = @iNextAssessmentId)    
   BEGIN    
    INSERT INTO ASSESSMENT.T_Student_Assessment_Map
            ( I_Enquiry_Regn_ID ,
              I_PreAssessment_ID ,
              I_Exam_Component_ID ,
              B_Is_Complete
            )
    SELECT  @iEnquiryID ,    
            I_PreAssessment_ID ,    
            I_Exam_Component_ID ,    
            0    
    FROM ASSESSMENT.T_PreAssessment_ExamComponent_Mapping    
    WHERE I_PreAssessment_ID = @iNextAssessmentId    
    AND I_Status = 1    
   END    
 END    
ELSE IF(@iCourseList IS NOT NULL)    
 BEGIN    
  IF NOT EXISTS(SELECT * FROM ASSESSMENT.T_Student_Assessment_Suggestion WHERE I_Enquiry_Regn_ID = @iEnquiryID AND I_CourseList_ID = @iCourseList)    
   BEGIN    
    INSERT INTO ASSESSMENT.T_Student_Assessment_Suggestion    
            ( I_Enquiry_Regn_ID ,    
              I_CourseList_ID    
            )    
    VALUES  ( @iEnquiryID , -- I_Enquiry_Regn_ID - int    
              @iCourseList  -- I_CourseList_ID - int    
            )     
   END    
 END    
END
