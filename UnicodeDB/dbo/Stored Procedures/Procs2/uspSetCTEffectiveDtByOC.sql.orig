-- =============================================  
-- Author:  Monalisa Dey 
-- Create date: 14/09/2012  
-- Description: Validate coupon  
-- =============================================  
CREATE PROCEDURE [dbo].[uspSetCTEffectiveDtByOC]  
(  
 @sLoginId varchar(30) ,
 @iTransferRequestId INT ,
 @dtEffectivedate DATETIME
)  
AS  
BEGIN TRY  
  
 UPDATE dbo.T_Student_Transfer_Request  
  SET Dt_effective_Date =@dtEffectivedate  
  WHERE I_Transfer_Request_ID = @iTransferRequestId  
  
END TRY  
BEGIN CATCH  
 --Error occurred:    
  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
