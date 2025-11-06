CREATE PROCEDURE [ASSESSMENT].[uspGetAssessmentExamTotalTime] --1200      
(      
  @iExamComponentID int     
)      
AS       
BEGIN      
    
  DECLARE @iTotalTime INT                         
  SET @iTotalTime = 0      
      
  SELECT @iTotalTime=tpaecm.I_Total_Time  FROM ASSESSMENT.T_PreAssessment_ExamComponent_Mapping AS tpaecm    
  WHERE tpaecm.I_Exam_Component_ID=@iExamComponentID    
      
  SELECT @iTotalTime    
END
