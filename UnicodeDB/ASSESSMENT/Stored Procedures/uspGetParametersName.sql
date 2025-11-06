CREATE PROC [ASSESSMENT].[uspGetParametersName]       
           
AS               
BEGIN              
  
 SET NOCOUNT ON              
   
      SELECT tpm.I_ParameterID,tpm.S_ParameterName FROM ASSESSMENT.T_Parameter_Master AS tpm      
        
            
END
