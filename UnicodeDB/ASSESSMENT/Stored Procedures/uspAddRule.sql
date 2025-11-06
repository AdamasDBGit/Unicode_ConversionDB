CREATE PROCEDURE [ASSESSMENT].[uspAddRule]    
(    
    @iBrandId INT,  
    @sRuleName varchar(50),  
    @iStatus INT,  
    @sCrtdBy varchar(20) = NULL,  
    @dtCrtdOn datetime = NULL  
    
)    
AS    
BEGIN   
   
  INSERT INTO ASSESSMENT.T_Rule_Master  
          (   
            I_Brand_ID,  
            S_Rule_Name,  
            I_Status,  
            S_Crtd_By,  
            Dt_Crtd_On,  
            S_Updt_By,  
            Dt_Updt_On  
          )  
  VALUES  (  
           @iBrandId,  
           @sRuleName,  
           @iStatus,  
           @sCrtdBy,  
           @dtCrtdOn,  
           NULL,  
           NULL  
          )  
     
   SELECT @@IDENTITY  
END
