CREATE PROCEDURE [ASSESSMENT].[uspGetStudentAssessmentEvaluationPlan] --1212,338338,0              
(          
 @iExamComponentId INT,          
 @iEnquiryID INT,          
 @iExamComponentType INT,
 @iRuleID INT = NULL                
)          
AS                 
BEGIN           
 DECLARE @nOnlineExamTotalMarks DECIMAL(18,2),@iAssessmentID INT,@iOnlineExamComponentId INT,@iInterviewExamComponentId INT          
 
 SELECT @iAssessmentID = B.I_PreAssessment_ID           
  FROM ASSESSMENT.T_PreAssessment_ExamComponent_Mapping A          
  INNER JOIN ASSESSMENT.T_PreAssessment_Master B          
  ON A.I_PreAssessment_ID = B.I_PreAssessment_ID          
  WHERE A.I_Exam_Component_ID = @iExamComponentId          
  AND A.I_Status = 1          
  AND B.I_Status = 1          
          
IF(@iExamComponentType = 1)          
 BEGIN          
  SET @iOnlineExamComponentId = @iExamComponentId          
  SELECT @iInterviewExamComponentId = B.I_Exam_Component_ID          
  FROM ASSESSMENT.T_PreAssessment_ExamComponent_Mapping A          
  INNER JOIN dbo.T_Exam_Component_Master B          
  ON A.I_Exam_Component_ID = B.I_Exam_Component_ID          
  WHERE A.I_Status = 1          
  AND B.I_Status = 1          
  AND I_PreAssessment_ID = @iAssessmentID          
  AND I_Exam_Type_Master_ID = 14          
 END          
ELSE          
 BEGIN          
  SET @iInterviewExamComponentId = @iExamComponentId          
  SELECT @iOnlineExamComponentId = B.I_Exam_Component_ID          
  FROM ASSESSMENT.T_PreAssessment_ExamComponent_Mapping A          
  INNER JOIN dbo.T_Exam_Component_Master B          
  ON A.I_Exam_Component_ID = B.I_Exam_Component_ID          
  WHERE A.I_Status = 1          
  AND B.I_Status = 1          
  AND I_PreAssessment_ID = @iAssessmentID          
  AND I_Exam_Type_Master_ID = 13          
 END          
          
IF(@iRuleID IS NULL)
	BEGIN
	SELECT I_Assessment_Rule_Map_ID ,          
			I_PreAssessment_ID ,          
			I_Rule_ID ,          
			S_Evaluated_True_Category ,          
			I_Evaluated_True_Assessment_ID , 
			I_Evaluated_True_Rule_ID,         
			I_Evaluated_True_CourseList_ID ,          
			S_Evaluated_False_Category ,          
			I_Evaluated_False_Assessment_ID ,          
			I_Evaluated_False_CourseList_ID,
			I_Evaluated_False_Rule_ID           
			FROM ASSESSMENT.T_Assessment_Rule_Workflow           
			WHERE I_PreAssessment_ID =@iAssessmentID   
			AND I_Rule_ID NOT IN (SELECT ISNULL(I_Evaluated_True_Rule_ID,0) FROM ASSESSMENT.T_Assessment_Rule_Workflow AS TARW 
													WHERE I_PreAssessment_ID = @iAssessmentID AND I_Status = 1)
			AND I_Rule_ID NOT IN (SELECT ISNULL(I_Evaluated_False_Rule_ID,0) FROM ASSESSMENT.T_Assessment_Rule_Workflow AS TARW 
													WHERE I_PreAssessment_ID = @iAssessmentID AND I_Status = 1)
	  AND ASSESSMENT.T_Assessment_Rule_Workflow.I_Status =1            
	          
	SELECT @iRuleID = I_Rule_ID          
	  FROM ASSESSMENT.T_Assessment_Rule_Workflow           
			WHERE I_PreAssessment_ID = @iAssessmentID     
			AND I_Rule_ID NOT IN (SELECT ISNULL(I_Evaluated_True_Rule_ID,0) FROM ASSESSMENT.T_Assessment_Rule_Workflow AS TARW 
													WHERE I_PreAssessment_ID = @iAssessmentID AND I_Status = 1)
			AND I_Rule_ID NOT IN (SELECT ISNULL(I_Evaluated_False_Rule_ID,0) FROM ASSESSMENT.T_Assessment_Rule_Workflow AS TARW 
													WHERE I_PreAssessment_ID = @iAssessmentID AND I_Status = 1)
			AND I_Status =1          
	END
ELSE
	BEGIN
		SELECT I_Assessment_Rule_Map_ID ,          
			I_PreAssessment_ID ,          
			I_Rule_ID ,          
			S_Evaluated_True_Category ,          
			I_Evaluated_True_Assessment_ID , 
			I_Evaluated_True_Rule_ID,         
			I_Evaluated_True_CourseList_ID ,          
			S_Evaluated_False_Category ,          
			I_Evaluated_False_Assessment_ID ,          
			I_Evaluated_False_CourseList_ID,
			I_Evaluated_False_Rule_ID           
			FROM ASSESSMENT.T_Assessment_Rule_Workflow           
			WHERE I_PreAssessment_ID =@iAssessmentID   
			AND I_Rule_ID = @iRuleID
			AND I_Status =1  		
	END          
SELECT * FROM ASSESSMENT.T_Rule_Step_Evaluation WHERE I_Rule_ID = @iRuleID AND I_Status = 1          
          
SELECT A.I_Step_ID ,          
        A.S_Step_Name ,          
        B.S_ParameterName,          
        A.S_Parameter_Values ,          
        C.S_EvaluationName ,          
        A.N_Min_Range ,          
        A.N_Max_Range ,          
        A.N_Min_Percent_Range ,          
        A.N_Max_Percent_Range ,          
        A.N_CutOff_Score           
        FROM ASSESSMENT.T_Step_Details A          
INNER JOIN ASSESSMENT.T_Parameter_Master B          
ON A.I_Parameter_ID = B.I_ParameterID          
INNER JOIN ASSESSMENT.T_Evaluation_Master C          
ON A.I_EvaluationCriteria_ID = C.I_EvaluationID          
 WHERE I_Step_ID IN (SELECT I_Operand_ID1 FROM ASSESSMENT.T_Rule_Step_Evaluation WHERE I_Rule_ID = @iRuleID AND I_Status = 1 AND S_Operator_Name IS NULL)          
 AND A.I_Status = 1          
  
SELECT TSCMD.I_Competency_ID,        
       TCD.S_Competency_Code,TSCMD.N_Total_Marks,TSCMD.N_Marks_Obtained  
       FROM ASSESSMENT.T_Student_Competency_Marks_Details AS TSCMD  
       INNER JOIN ASSESSMENT.T_Competency_Details AS TCD  
       ON TSCMD.I_Competency_ID = TCD.I_Competency_ID  
       WHERE I_Exam_Component_ID = @iOnlineExamComponentId  
       AND I_Enquiry_Regn_ID = @iEnquiryID  
          
SELECT I_Exam_Component_ID,SUM(I_Value) AS N_Interview_Rating FROM STUDENTFEATURES.T_Student_Feedback A          
INNER JOIN STUDENTFEATURES.T_Student_Feedback_Details B          
ON A.I_Student_Feedback_ID = B.I_Student_Feedback_ID          
INNER JOIN ACADEMICS.T_Feedback_Option_Master C          
ON B.I_Feedback_Option_Master_ID = C.I_Feedback_Option_Master_ID          
INNER JOIN ACADEMICS.T_Feedback_Master D          
ON C.I_Feedback_Master_ID = D.I_Feedback_Master_ID          
WHERE I_Enquiry_Regn_ID = @iEnquiryID          
AND I_Exam_Component_ID = @iInterviewExamComponentId          
GROUP BY I_Exam_Component_ID          
          
--DROP TABLE #temp          
END
