CREATE PROCEDURE [CORPORATE].[uspGetCorporatePlanBatchWise] --401   
(    
 @iBatchID INT  
)  
AS    
BEGIN TRY    
  


SELECT tcpbm.I_Corporate_Plan_ID ,tcp1.S_Corporate_Plan_Name,
        tcpbm.I_Batch_ID FROM CORPORATE.T_Corporate_Plan_Batch_Map AS tcpbm
        INNER JOIN CORPORATE.T_Corporate_Plan AS tcp1
        ON tcpbm.I_Corporate_Plan_ID = tcp1.I_Corporate_Plan_ID
        WHERE tcpbm.I_Batch_ID = @iBatchID
END TRY    
  
BEGIN CATCH    
 --Error occurred:      
    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH
