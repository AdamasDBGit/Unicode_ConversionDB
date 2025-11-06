CREATE PROCEDURE [CORPORATE].[uspAddCorporateStudentReceipt]                    
(                  
 @iCorporatePlanId INT,                  
 @sCrtdBy varchar(20) = NULL,                  
 @dtCrtdOn datetime = NULL,                  
 @sUpdtBy varchar(20) = NULL,                  
 @dtUpdtOn datetime =  NULL ,            
 @iStatus INT  =  NULL  ,    
 @sCorpReceiptType VARCHAR(20),  
 @sTDSComment VARCHAR(500) =NULL          
)                  
AS                   
BEGIN                  
            
 INSERT INTO CORPORATE.T_Corporate_Receipt      
         (       
           I_Corporate_Plan_ID ,      
           S_Crtd_By ,      
           S_Upd_By ,      
           Dt_Crtd_On ,      
           Dt_Upd_On ,      
           I_Status  ,    
           S_Corporate_Receipt_Type,  
           S_TDS_Comment    
         )      
 VALUES  (       
           @iCorporatePlanId , -- I_Corporate_Plan_ID - int      
           @sCrtdBy , -- S_Crtd_By - varchar(20)      
           @sUpdtBy , -- S_Upd_By - varbinary(20)      
           @dtCrtdOn , -- Dt_Crtd_On - datetime      
           @dtUpdtOn , -- Dt_Upd_On - datetime      
           @iStatus  ,-- I_Status - int      
           @sCorpReceiptType,  
           @sTDSComment    
         )      
       
 SELECT @@IDENTITY            
                   
           
                    
            
END
