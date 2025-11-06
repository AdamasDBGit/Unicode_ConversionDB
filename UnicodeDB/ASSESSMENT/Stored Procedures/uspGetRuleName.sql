CREATE PROCEDURE [ASSESSMENT].[uspGetRuleName]  
     
AS    
BEGIN    
    
 SELECT trm.I_Rule_ID,trm.S_Rule_Name FROM ASSESSMENT.T_Rule_Master AS trm  
 WHERE trm.I_Status=1  
    
END
