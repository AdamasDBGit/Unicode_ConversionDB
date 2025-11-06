CREATE PROCEDURE [ASSESSMENT].[uspGetStepLinkForRule]  
(      
 @iRuleID int       
)      
AS       
BEGIN      
 IF EXISTS(SELECT * FROM ASSESSMENT.T_Rule_Step_Evaluation WHERE I_Rule_ID = @iRuleID AND B_Is_LastNode = 1 AND I_Status = 1)      
  BEGIN      
   SELECT I_Link_ID AS I_Step_ID,S_Link_Name as S_Step_Name,1 AS IsLinked      
   FROM ASSESSMENT.T_Rule_Step_Evaluation       
   WHERE I_Rule_ID = @iRuleID       
   AND B_Is_LastNode = 1      
   AND I_Status = 1    
  END      
 ELSE      
  BEGIN      
   SELECT A.I_Step_ID,A.S_Step_Name,0 AS IsLinked       
   FROM ASSESSMENT.T_Step_Details AS A      
   INNER JOIN ASSESSMENT.T_Rule_Step_Map B      
   ON A.I_Step_ID = B.I_Step_ID      
   WHERE I_Rule_ID = @iRuleID       
   AND I_Status=1       
   ORDER BY A.I_Step_ID      
  END       
END
