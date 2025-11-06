-- =============================================
-- Author:		Aritra Saha
-- Create date: 15/03/2007
-- Description:	Update the Fee Plan Request Status - Approved/Rejected
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateFeePlanRequest] 
(
	-- Add the parameters for the stored procedure here
	@iCourseFeePlanRequestID int = null,
	@sComments varchar(200) = null,
	@iStatus int = null,
	@sUpdatedBy varchar(20)= null ,
	@dUpdatedOn datetime = null	 	

)
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF
	

	-- Update the Fee Plan Request Status (Approved/Rejected) in CourseFeePlanRequest
	UPDATE
		 T_Course_FeePlan_Request 
	SET 
		I_Status = @iStatus, 
		S_Comments = @sComments,
		S_Upd_By = @sUpdatedBy,
		Dt_Upd_On = @dUpdatedOn
	WHERE 
		I_Course_FeePlan_Request_ID = @iCourseFeePlanRequestID 
          
	

END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
