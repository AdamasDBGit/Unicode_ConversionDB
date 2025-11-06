CREATE PROCEDURE [ASSESSMENT].[uspGetAssessmentTestList] 
(    
 @iBrandId int     
)     
AS     
BEGIN    
 --Table[1] for the list of Assessment Tests    
 SELECT * FROM ASSESSMENT.T_PreAssessment_Master WHERE I_Status = 1 AND I_Brand_ID = @iBrandId    
     
 --Table[2] for the Assessment Test ExamComponent Mapping    
 SELECT B.I_PreAssessment_ID,A.I_Exam_Component_ID, A.S_Component_Name ,B.I_Total_Time    
 FROM dbo.T_Exam_Component_Master A    
 INNER JOIN ASSESSMENT.T_PreAssessment_ExamComponent_Mapping B    
 ON A.I_Exam_Component_ID = B.I_Exam_Component_ID    
 WHERE A.I_Brand_ID = @iBrandId    
 AND A.I_Status = 1    
 AND B.I_Status = 1    
     
 --Table[3] for the Assessment Course Mapping    
 SELECT A.I_PreAssessment_ID,A.I_Course_ID,B.I_CourseFamily_ID    
 FROM ASSESSMENT.T_Assessment_Course_Map A    
 INNER JOIN dbo.T_Course_Master B    
 ON A.I_Course_ID = B.I_Course_ID    
 INNER JOIN ASSESSMENT.T_PreAssessment_Master C    
 ON A.I_PreAssessment_ID = C.I_PreAssessment_ID    
 WHERE C.I_Brand_ID = @iBrandId    
 AND C.I_Status = 1    
 AND B.I_Status = 1    
     
     
END
