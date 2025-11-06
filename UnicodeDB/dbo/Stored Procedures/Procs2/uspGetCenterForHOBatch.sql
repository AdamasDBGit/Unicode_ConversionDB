CREATE PROCEDURE [dbo].[uspGetCenterForHOBatch]  

@iBatchID INT = NULL  
AS
BEGIN  

SELECT I_Batch_ID,I_Centre_Id FROM dbo.T_Center_Batch_Details AS tcbd WHERE tcbd.I_Batch_ID = @iBatchID

END
