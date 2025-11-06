CREATE PROCEDURE [dbo].[uspCheckBatchDeliveryPatternDetails] -- [dbo].[uspCheckBatchDeliveryPatternDetails]  763,'0'
(
	@iBatchID INT,
	@SDayOfWeek VARCHAR(1)
) 
AS  
BEGIN  
	SET NOCOUNT ON 
	DECLARE @B_DeliveryPatternFlag BIT  

	IF (SELECT COUNT(*) FROM dbo.T_Student_Batch_Master AS TSBM
		INNER JOIN dbo.T_Delivery_Pattern_Master AS TDPM
		ON TSBM.I_Delivery_Pattern_ID = TDPM.I_Delivery_Pattern_ID
		WHERE I_Batch_ID = @iBatchID and S_DaysOfWeek LIKE '%' + @SDayOfWeek + '%') >0
	BEGIN
		SET @B_DeliveryPatternFlag=1	
	END
	ELSE
	BEGIN
		SET @B_DeliveryPatternFlag=0	 
	END
	SELECT @B_DeliveryPatternFlag
END
