-- exec uspModifyCourseListCourse 0, 1, 'Quick Java', 'cm', '3/13/2007 2:26:00 PM', 1
-- =============================================
-- Author:		Soumya Sikder
-- Create date: 12/03/2007
-- Description:	Modifies the CourseList  Master and CourseList Course Mapping Table
-- =============================================
CREATE PROCEDURE [dbo].[uspModifyCourseListCourse] 
(
	@iCourseListCourseID int,
	@sCourseIdList varchar(100),
	@sCourseListName varchar(50),
	@sCourseListCourseBy varchar(20),
	@dCourseListCourseOn datetime,
	@iFlag int,
	@iBrandId int

)
AS
BEGIN TRY
	SET NOCOUNT ON
			
	DECLARE @iCourseListID int
	DECLARE @iCourseID int
	DECLARE @iGetIndex int
	DECLARE @sCourseID varchar(20)
	DECLARE @iLength int
			
    IF @iFlag = 1
	BEGIN
			INSERT INTO dbo.T_CourseList_Master
			(S_CourseList_Name,
			 I_Brand_ID,
			 I_Status,
			 S_Crtd_By,
             Dt_Crtd_On)
			VALUES
			(@sCourseListName,
			 @iBrandId,
			 1,
			 @sCourseListCourseBy,
			 @dCourseListCourseOn)
			SELECT @iCourseListID=@@IDENTITY
			
			SET @iGetIndex = CHARINDEX(',',LTRIM(RTRIM(@sCourseIdList)),1)
			IF @iGetIndex > 1
			BEGIN
				WHILE LEN(@sCourseIdList) > 0
				BEGIN
					SET @iGetIndex = CHARINDEX(',',@sCourseIdList,1)
					SET @iLength = LEN(@sCourseIdList)
					SET @iCourseID = CAST(LTRIM(RTRIM(LEFT(@sCourseIdList,@iGetIndex-1))) AS int)
					INSERT INTO dbo.T_CourseList_Course_Map
					(I_Course_ID,
					 I_CourseList_ID,
					 I_Status)
					VALUES
					(@iCourseID,
					 @iCourseListID,
					 1)	
					SELECT @sCourseIdList = SUBSTRING(@sCourseIdList,@iGetIndex + 1, @iLength - @iGetIndex)
					SELECT @sCourseIdList = LTRIM(RTRIM(@sCourseIdList))				
				END
			END
	END
	IF @iFlag = 2
	BEGIN
		SET @iCourseListID = @iCourseListCourseID

		UPDATE dbo.T_CourseList_Course_Map
		SET I_Status = 0
		WHERE I_CourseList_ID = @iCourseListID
		
		UPDATE dbo.T_CourseList_Master
		SET S_Upd_By = @sCourseListCourseBy,
		Dt_Upd_On = @dCourseListCourseOn
		WHERE I_CourseList_ID = @iCourseListID
		
		SET @iGetIndex = CHARINDEX(',',LTRIM(RTRIM(@sCourseIdList)),1)
			IF @iGetIndex > 1
			BEGIN
				WHILE LEN(@sCourseIdList) > 0
				BEGIN
					SET @iGetIndex = CHARINDEX(',',@sCourseIdList,1)
					SET @iLength = LEN(@sCourseIdList)
					SET @iCourseID = CAST(LTRIM(RTRIM(LEFT(@sCourseIdList,@iGetIndex-1))) AS int)
					INSERT INTO dbo.T_CourseList_Course_Map
					(I_Course_ID,
					 I_CourseList_ID,
					 I_Status)
					VALUES
					(@iCourseID,
					 @iCourseListID,
					 1)	
					SELECT @sCourseIdList = SUBSTRING(@sCourseIdList,@iGetIndex + 1, @iLength - @iGetIndex)
					SELECT @sCourseIdList = LTRIM(RTRIM(@sCourseIdList))				
				END
			END
	END
	IF @iFlag = 3
	BEGIN
		SET @iCourseListID = @iCourseListCourseID

		UPDATE dbo.T_CourseList_Course_Map
		SET I_Status = 0
		WHERE I_CourseList_ID = @iCourseListID
		
		UPDATE dbo.T_CourseList_Master
		SET I_Status = 0,
		S_Upd_By = @sCourseListCourseBy,
		Dt_Upd_On = @dCourseListCourseOn
		WHERE I_CourseList_ID = @iCourseListID
	END	
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
