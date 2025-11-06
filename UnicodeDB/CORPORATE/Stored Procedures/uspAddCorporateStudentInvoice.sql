CREATE PROCEDURE [CORPORATE].[uspAddCorporateStudentInvoice]            
(          
 @iCorporatePlanId INT,          
 @sCrtdBy varchar(20) = NULL,          
 @dtCrtdOn datetime = NULL,          
 @sUpdtBy varchar(20) = NULL,          
 @dtUpdtOn datetime =  NULL ,    
 @iStatus INT  =  NULL,
 @dExcessAmt  DECIMAL = NULL       
)          
AS           
BEGIN          
    
 INSERT INTO CORPORATE.T_Corporate_Invoice  
         ( I_Corporate_Plan_ID ,  
           S_Crtd_By ,  
           S_Upd_By ,  
           Dt_Crtd_On ,  
           Dt_Upd_On ,  
           I_Status ,  
           N_Excess_Amt  
         )  
 VALUES  (   
           @iCorporatePlanId , -- I_Corporate_Plan_ID - int  
           @sCrtdBy , -- S_Crtd_By - varchar(20)  
           @sUpdtBy , -- S_Upd_By - varchar(20)  
           @dtCrtdOn , -- Dt_Crtd_On - datetime  
           @dtUpdtOn , -- Dt_Upd_On - datetime  
           @iStatus , -- I_Status - int  
           @dExcessAmt  -- N_Excess_Amt - decimal  
         )  
   
 SELECT @@IDENTITY    
           
   
            
    
END
