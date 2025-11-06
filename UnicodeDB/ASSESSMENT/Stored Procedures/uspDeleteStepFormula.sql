CREATE PROCEDURE [ASSESSMENT].[uspDeleteStepFormula]        
(    
   @iRuleID INT = NULL,  
   @sUpdateBy VARCHAR(20) = NULL,    
   @DtUpdateOn DATETIME   = NULL  
)  
AS       
BEGIN    
 IF @iRuleID IS NOT NULL  
   BEGIN  
    UPDATE ASSESSMENT.T_Rule_Step_Evaluation  
    SET I_Status = 0 ,S_Updt_By = @sUpdateBy , Dt_Updt_On = @DtUpdateOn  
    WHERE I_Rule_ID = ISNULL(@iRuleID,I_Rule_ID)     
   END      
     
END
