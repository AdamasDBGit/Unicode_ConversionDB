CREATE PROCEDURE [dbo].[uspValidateDeliveryPatternModification] 
(
	@iDeliveryPatternID int
)
AS
BEGIN TRY
	
	SELECT COUNT(A.I_Course_Fee_Plan_ID) 
	FROM dbo.T_Course_Fee_Plan A
	INNER JOIN dbo.T_Course_Delivery_Map B
	ON A.I_Course_Delivery_ID = B.I_Course_Delivery_ID
	INNER JOIN dbo.T_Course_Master CM
	ON B.I_Course_ID = CM.I_Course_ID
	INNER JOIN dbo.T_Delivery_Pattern_Master C
	ON B.I_Delivery_Pattern_ID = C.I_Delivery_Pattern_ID
	WHERE B.I_Delivery_Pattern_ID = @iDeliveryPatternID
	AND A.I_Status = 1
	AND B.I_Status = 1
	AND C.I_Status = 1
	AND CM.I_Status = 1

	
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
