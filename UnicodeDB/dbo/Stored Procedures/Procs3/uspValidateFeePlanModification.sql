CREATE PROCEDURE [dbo].[uspValidateFeePlanModification] 
(
	@iFeePlanId int
)
AS
BEGIN TRY

	SELECT COUNT(A.I_Course_Center_Delivery_ID)
	FROM dbo.T_Course_Center_Delivery_FeePlan A
	INNER JOIN dbo.T_Course_Center_Detail CCD
	ON A.I_Course_Center_ID = CCD.I_Course_Center_ID 
	INNER JOIN dbo.T_Centre_Master CM
	ON CCD.I_Centre_Id = CM.I_Centre_Id
	INNER JOIN dbo.T_Course_Fee_Plan B
	ON A.I_Course_Fee_Plan_ID = B.I_Course_Fee_Plan_ID
	WHERE A.I_Course_Fee_Plan_ID = @iFeePlanId 
	AND A.I_Status = 1
	AND B.I_Status = 1
	AND CCD.I_Status = 1
	AND CM.I_Status = 1
	AND GETDATE() >= ISNULL(A.Dt_Valid_From,GETDATE())
	AND GETDATE() <= ISNULL(A.Dt_Valid_To,GETDATE())
	AND GETDATE() >= ISNULL(CCD.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(CCD.Dt_Valid_To, GETDATE())
	AND GETDATE() >= ISNULL(CM.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(CM.Dt_Valid_To, GETDATE())
	
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
