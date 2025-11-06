-- =============================================  
-- Author:  Monalisa Dey  
-- Create date: 13/09/2012  
-- Description: Update the effective date for center transfer request after final approval  
-- =============================================  
CREATE PROCEDURE [dbo].[uspCompleteCTProcess]  
(  
 @sLoginId VARCHAR(100) ,
 @iTransferRequestId INT ,
 @dtEffectivedate DATETIME

)  
AS  
BEGIN TRY  
  
 UPDATE  dbo.T_Student_Transfer_Request
                    SET     S_Upd_By = @sLoginId ,
                            Dt_Upd_On = GETDATE() ,
                            Dt_effective_Date = @dtEffectivedate
                    WHERE   I_Transfer_Request_Id = @iTransferRequestId      
  
END TRY  
BEGIN CATCH  
 --Error occurred:    
  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
