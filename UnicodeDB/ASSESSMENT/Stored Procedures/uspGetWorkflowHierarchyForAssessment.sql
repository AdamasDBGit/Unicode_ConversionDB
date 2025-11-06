CREATE PROCEDURE [ASSESSMENT].[uspGetWorkflowHierarchyForAssessment]      
AS     
BEGIN    
 SELECT A.I_Assessment_Rule_Map_ID ,    
   A.I_PreAssessment_ID ,    
   C.S_PreAssessment_Name,    
   A.I_Rule_ID ,    
   B.S_Rule_Name,    
   A.S_Evaluated_True_Category ,    
   A.I_Evaluated_True_Assessment_ID ,    
   D.S_PreAssessment_Name AS S_Evaluated_True_Assessment_Name,    
   A.I_Evaluated_True_CourseList_ID,     
   dbo.fnGetCourseNameList(A.I_Evaluated_True_CourseList_ID) AS S_Evaluated_True_CourseNames, 
   A.I_Evaluated_True_Rule_ID,   
   TRM.S_Rule_Name AS S_Evaluated_True_Rule_Name,
   A.S_Evaluated_False_Category ,    
   A.I_Evaluated_False_Assessment_ID ,    
   H.S_PreAssessment_Name AS S_Evaluated_False_Assessment_Name,    
   A.I_Evaluated_False_CourseList_ID,    
   dbo.fnGetCourseNameList(A.I_Evaluated_False_CourseList_ID) AS S_Evaluated_False_CourseNames,
   A.I_Evaluated_False_Rule_ID,
   TRM2.S_Rule_Name AS S_Evaluated_False_Rule_Name    
  FROM ASSESSMENT.T_Assessment_Rule_Workflow A    
  INNER JOIN ASSESSMENT.T_Rule_Master B    
  ON A.I_Rule_ID = B.I_Rule_ID    
  INNER JOIN ASSESSMENT.T_PreAssessment_Master C    
  ON A.I_PreAssessment_ID = C.I_PreAssessment_ID    
  LEFT OUTER JOIN ASSESSMENT.T_PreAssessment_Master D    
  ON A.I_Evaluated_True_Assessment_ID = D.I_PreAssessment_ID    
  LEFT OUTER JOIN ASSESSMENT.T_Rule_CourseList_Map E    
  ON A.I_Evaluated_True_CourseList_ID = E.I_CourseList_ID   
  LEFT OUTER JOIN ASSESSMENT.T_Rule_Master AS TRM
  ON A.I_Evaluated_True_Rule_ID = TRM.I_Rule_ID 
  LEFT OUTER JOIN ASSESSMENT.T_PreAssessment_Master H    
  ON A.I_Evaluated_False_Assessment_ID = H.I_PreAssessment_ID    
  LEFT OUTER JOIN ASSESSMENT.T_Rule_CourseList_Map I    
  ON A.I_Evaluated_False_CourseList_ID = I.I_CourseList_ID  
  LEFT OUTER JOIN ASSESSMENT.T_Rule_Master AS TRM2
  ON A.I_Evaluated_False_Rule_ID = TRM2.I_Rule_ID  
  WHERE A.I_Status = 1    
END
