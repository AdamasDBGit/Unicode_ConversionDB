CREATE PROC [ASSESSMENT].[uspGetEvaluationName]       
           
AS               
BEGIN              
  
 SET NOCOUNT ON              
   
      SELECT tem.I_EvaluationID,tem.S_EvaluationName FROM ASSESSMENT.T_Evaluation_Master AS tem    
        
            
END
