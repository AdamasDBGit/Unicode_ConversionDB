CREATE PROCEDURE [ASSESSMENT].[uspGetStepLinkGridForRule]        
(      
 @iRuleID int       
)      
AS       
BEGIN      
 SELECT I_Link_ID ,      
         S_Link_Name ,      
         I_Operand_ID1 ,      
         S_Operand_Name1 ,      
         S_Operator_Name ,      
         I_Operand_ID2 ,      
         S_Operand_Name2 ,      
         B_Is_LastNode FROM ASSESSMENT.T_Rule_Step_Evaluation WHERE I_Rule_ID = @iRuleID  AND I_Status = 1    
         ORDER BY I_Link_ID      
END
