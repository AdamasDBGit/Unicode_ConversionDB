CREATE PROCEDURE [ASSESSMENT].[uspDeteleStepDetails]              
 (            
    @iStepID INT = NULL            
 )               
AS                
BEGIN             
  DECLARE @iReturn INT          
            
   IF NOT EXISTS(SELECT * FROM ASSESSMENT.T_Rule_Step_Evaluation WHERE S_Operator_Name IS NULL AND I_Operand_ID1 = @iStepID AND I_Status = 1)          
     BEGIN          
  UPDATE ASSESSMENT.T_Step_Details            
  SET I_Status = 0            
  WHERE I_Step_ID = @iStepID            
           
  UPDATE  ASSESSMENT.T_Rule_Step_Map            
  SET  I_StatusID = 0            
  WHERE I_Step_ID = @iStepID    
        
       SET @iReturn = 1          
     END          
         
   ELSE          
     BEGIN          
      SET @iReturn = 0          
     END          
        
   SELECT @iReturn          
             
END
