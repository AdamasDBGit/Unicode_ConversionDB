CREATE PROC [dbo].[uspUpdateCourseFeePlanId]
(
  @iBatchID INT,
  @iCenterID INT,
  @iFeePlanId INT,
  @iNewFeePlanId INT
)
AS
BEGIN TRY

BEGIN

UPDATE dbo.T_Center_Batch_Details SET I_Course_Fee_Plan_ID=@iNewFeePlanId 
WHERE I_Batch_ID=@iBatchID AND I_Centre_Id=@iCenterID
AND I_Course_Fee_Plan_ID=@iFeePlanId


END

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
