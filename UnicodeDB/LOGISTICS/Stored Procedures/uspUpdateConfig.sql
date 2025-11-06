CREATE PROCEDURE [LOGISTICS].[uspUpdateConfig]    
(    
 @sChargeCode VARCHAR(50) = NULL,    
 @iAmount NUMERIC(18,2) = NULL,    
 @dtStart DATETIME,    
 @dtEnd DATETIME,    
 @sUpdBy VARCHAR(20),    
 @dtUpdOn DATETIME,  
 @iBrandId INT = NULL   
)    
AS    
BEGIN TRY    
SET NOCOUNT OFF;    
    
 UPDATE [LOGISTICS].T_Logistics_ChrgDiscount_Config    
  SET    
   --S_Logistics_Charge_Code = @sChargeCode,    
   I_Amount = @iAmount,    
   S_Upd_By = @sUpdBy,     
   Dt_Upd_On = @dtUpdOn,  
   Dt_Start = @dtStart,  
   Dt_End = @dtEnd   
  WHERE S_Logistics_Charge_Code = COALESCE(@sChargeCode, S_Logistics_Charge_Code)    
  AND I_Brand_Id = @iBrandId  
    
END TRY    
    
BEGIN CATCH    
 --Error occurred:    
    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH 

-------------------------- MBP SEED DATA -----------------------------
---------------------------------- ACE --------------------------------------------------------------
