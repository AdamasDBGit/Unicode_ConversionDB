/*    
-- =================================================================    
-- Author:Sayan Basu  
-- Create date:12/03/2009     
-- Description:Saves/Updates Bridge Details in T_Bridge_Master table     
-- =================================================================    
*/    
CREATE PROCEDURE [dbo].[uspModifyBridge]    
(    
  @iBridgeID INT =  NULL ,    
  @sBridgeCode  VARCHAR(20) ,    
  @sBridgeDesc  VARCHAR(1000) ,  
  @iBrandID INT,    
  @sCrtdBy   VARCHAR(20) ,    
  @dtCrtdOn   DATETIME ,  
  @sUpdtdBy   VARCHAR(20) ,  
  @dtUpdtdOn   DATETIME,  
  @iFlag INT  
)    
AS    
BEGIN TRY    
     
    
-- Insert record in  T_Root_Cause_Master Table    
IF (@iFlag =1)    
BEGIN  
    
INSERT INTO [dbo].T_Bridge_Master    
  (    
  S_Bridge_Code,  
  S_Bridge_Desc,  
  I_Brand_ID,  
  I_Status,  
  S_Crtd_By,
  Dt_Crtd_On,  
  S_Upd_By,    
  Dt_Upd_On  
  )    
 VALUES   
 (    
  @sBridgeCode   ,    
  @sBridgeDesc ,  
  @iBrandID,   
  1  ,    
  @sCrtdBy  ,    
  @dtCrtdOn ,  
  NULL,  
  NULL    
  )  
      
END  
  
---Update records in T_Root_Cause_Master Table    
ELSE IF (@iFlag =2)  
  
BEGIN  
 UPDATE [dbo].t_Bridge_Master  
 SET  
  S_Bridge_Code=@sBridgeCode,  
  S_Bridge_Desc=@sBridgeDesc,  
  S_Upd_By=@sUpdtdBy,  
  Dt_Upd_On=@dtUpdtdOn  
 WHERE I_Bridge_ID=@iBridgeID  
   
END  
  
ELSE IF (@iFlag =3)  
  
BEGIN  
 UPDATE [dbo].t_Bridge_Master  
 SET  
  I_Status=0,  
  S_Upd_By=@sUpdtdBy,  
  Dt_Upd_On=@dtUpdtdOn  
 WHERE I_Bridge_ID=@iBridgeID  
   
END  
  
END TRY    
    
BEGIN CATCH    
 --Error occurred:      
    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH    
    
-----------------------------------------------------------------------------------------------------------------------------------------
