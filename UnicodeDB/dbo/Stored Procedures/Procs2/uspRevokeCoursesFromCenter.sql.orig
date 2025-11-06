CREATE PROCEDURE [dbo].[uspRevokeCoursesFromCenter]
(
		@sSelectedCenters varchar(1000),
		@sSelectedCourseID varchar(100),
		@sLoginID varchar(200)
	)

AS

BEGIN TRY
	
DECLARE @iGetCenterIndex int
DECLARE @iGetCourseIndex int
DECLARE @iLength int
DECLARE @iCourseListLength int
DECLARE @iCenterID int
DECLARE @iCourseID int
DECLARE @sSelectedCourseIDs varchar(100)

SET @iGetCenterIndex = CHARINDEX(',',LTRIM(RTRIM(@sSelectedCenters)),1)

BEGIN TRANSACTION
IF @iGetCenterIndex > 1
BEGIN
	WHILE LEN(@sSelectedCenters) > 0
	BEGIN
		SET @iGetCenterIndex = CHARINDEX(',',@sSelectedCenters,1)
		SET @iLength = LEN(@sSelectedCenters)
		SET @iCenterID = CAST(LTRIM(RTRIM(LEFT(@sSelectedCenters,@iGetCenterIndex-1))) AS int)
		
		SET @sSelectedCourseIDs = @sSelectedCourseID
		SET @iGetCourseIndex = CHARINDEX(',',LTRIM(RTRIM(@sSelectedCourseIDs)),1)	
		WHILE LEN(@sSelectedCourseIDs) > 0
		BEGIN
			SET @iGetCourseIndex = CHARINDEX(',',@sSelectedCourseIDs,1)
			SET @iCourseListLength = LEN(@sSelectedCourseIDs)
			SET @iCourseID = CAST(LTRIM(RTRIM(LEFT(@sSelectedCourseIDs,@iGetCourseIndex-1))) AS int)
						
			UPDATE T_Course_Center_Detail 
			SET I_Status = 0, 
			S_Upd_By = @sLoginID, 
			Dt_Upd_On = GETDATE(),
			Dt_Valid_To = GETDATE()  
			WHERE I_Centre_ID = @iCenterID 
			AND I_Course_ID= @iCourseID 
						
			SELECT @sSelectedCourseIDs = SUBSTRING(@sSelectedCourseIDs,@iGetCourseIndex + 1, @iCourseListLength - @iGetCourseIndex)
			SELECT @sSelectedCourseIDs = LTRIM(RTRIM(@sSelectedCourseIDs))
		END

		SELECT @sSelectedCenters = SUBSTRING(@sSelectedCenters,@iGetCenterIndex + 1, @iLength - @iGetCenterIndex)
		SELECT @sSelectedCenters = LTRIM(RTRIM(@sSelectedCenters))
	END
END
COMMIT TRANSACTION
END TRY
BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRANSACTION
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
