CREATE PROC [ASSESSMENT].[uspGetStepName]               
(      
 @iRuleID INT      
)                   
AS                       
BEGIN                      
          
 SET NOCOUNT ON                      
           
        SELECT A.I_Step_ID,A.S_Step_Name FROM ASSESSMENT.T_Step_Details AS A      
        INNER JOIN ASSESSMENT.T_Rule_Step_Map B      
        ON A.I_Step_ID = B.I_Step_ID      
        WHERE I_Rule_ID = @iRuleID       
        AND I_Status=1        
        ORDER BY A.I_Step_ID            
END
