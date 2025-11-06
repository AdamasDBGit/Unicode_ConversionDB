CREATE PROCEDURE [dbo].[uspGetEVALUATION]             
            
AS            
BEGIN            
            
 SELECT S_Evaluation_Name,TAEM.I_Evaluation_ID ,TAEM.I_Brand_ID,I_Activity_ID     
 FROM dbo.T_Activity_Evaluation_Master TAEM        
 left outer join T_ActivityEvalCriteria_Map TAECM        
 on TAEM.I_Evaluation_ID = TAECM.I_Evaluation_ID       
 WHERE TAEM.I_Status = 1  
            
END
