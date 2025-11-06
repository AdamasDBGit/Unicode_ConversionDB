CREATE PROCEDURE [ASSESSMENT].[uspDeteleRuleAndStepDetails]          
 (          
    @iRuleID INT = NULL          
 )             
AS              
BEGIN           
    
   DECLARE @iReturn INT    
       
   IF  EXISTS(SELECT * FROM ASSESSMENT.T_Rule_Step_Map WHERE  I_Rule_ID = @iRuleID AND I_StatusID = 0)    
      BEGIN    
		  UPDATE ASSESSMENT.T_Rule_Master         
		  SET I_Status = 0          
		  WHERE I_Rule_ID = @iRuleID          
             
          SET @iReturn = 1    
         
      END    
   ELSE    
      BEGIN    
        SET @iReturn = 0    
      END      
         
     SELECT @iReturn    
         
END
