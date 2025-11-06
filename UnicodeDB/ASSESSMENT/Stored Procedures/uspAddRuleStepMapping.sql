CREATE PROCEDURE [ASSESSMENT].[uspAddRuleStepMapping]      
(      
    @iRuleID INT,    
    @iStepID INT    
      
)      
AS      
BEGIN     
     
  INSERT INTO ASSESSMENT.T_Rule_Step_Map    
          (     
           I_Rule_ID,    
           I_Step_ID,  
           I_StatusID  
          )    
  VALUES  (    
           @iRuleID,    
           @iStepID,  
           1    
          )    
       
       
END
