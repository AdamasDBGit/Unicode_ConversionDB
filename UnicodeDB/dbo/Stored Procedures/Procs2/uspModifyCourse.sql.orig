-- =============================================
-- Author:		Rabin Mukherjee
-- Create date: 02/02/2007
-- Description:	Modifies the Course  Master Table
-- =============================================
CREATE PROCEDURE [dbo].[uspModifyCourse] 
(
	@iCourseID int = null,
	@iBrandID int = null ,
	@iCourseFamilyID int = null ,
	@sCourseCode varchar(50)= null ,
	@sCourseName varchar(250) = null ,
	@sCourseFamilyName varchar(50) = null,
	@sCourseDescription varchar(500) = null,
	@sCreatedBy varchar(20)= null ,
	@dCreatedOn datetime = null ,
	@iIsNewCourse int = null ,
	@iFlag int = null ,
	@iDocumentID INT = null,
	@sDocumentName varchar(1000) = null,
	@sDocumentType varchar(50) = null,
	@sDocumentPath varchar(5000) = null,
	@sDocumentURL varchar(5000) = null
)

AS
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE @iUploadDocumentID INT
	
    IF @iFlag = 1
	BEGIN
		IF @iIsNewCourse = 1
			BEGIN
				DECLARE @CourseFamilyID int
				BEGIN TRAN T1
					INSERT INTO T_CourseFamily_Master 
					(	I_Brand_ID,
						S_CourseFamily_Name,
						S_Crtd_By,
						Dt_Crtd_On,
						I_Status	)
					VALUES
					(	@iBrandID,
						@sCourseFamilyName,
						@sCreatedBy,
						@dCreatedOn,
						1	)
					SELECT @CourseFamilyID=@@IDENTITY
					
					INSERT INTO T_Course_Master
					(	I_CourseFamily_ID,
						I_Brand_ID,
						S_Course_Code,
						S_Course_Name,
						S_Course_Desc,
						S_Crtd_By,
						Dt_Crtd_On,
						I_Is_Editable,
						I_Status	)
					VALUES
					(	@CourseFamilyID,
						@iBrandID,
						@sCourseCode,
						@sCourseName,
						@sCourseDescription,
						@sCreatedBy,
						@dCreatedOn,
						1,
						1	)	
										
				COMMIT TRAN T1
			END
		ELSE
			BEGIN
				BEGIN TRAN T2
				INSERT INTO T_Course_Master
				(	I_CourseFamily_ID,
					I_Brand_ID,
					S_Course_Code,
					S_Course_Name,
					S_Course_Desc,
					S_Crtd_By,
					Dt_Crtd_On,
					I_Is_Editable,
					I_Status	)
				VALUES
				(	@iCourseFamilyID,
					@iBrandID,
					@sCourseCode,
					@sCourseName,
					@sCourseDescription,
					@sCreatedBy,
					@dCreatedOn,
					1,
					1	)
					
					SET @iCourseID = @@IDENTITY
				COMMIT TRAN T2
			END

	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_Course_Master
		SET I_CourseFamily_ID = @iCourseFamilyID,
		I_Brand_ID = @iBrandID,
		S_Course_Code = @sCourseCode,
		S_Course_Name = @sCourseName,
		S_Course_Desc = @sCourseDescription,		
		S_Upd_By = @sCreatedBy,
		Dt_Upd_On= @dCreatedOn
		where I_Course_ID = @iCourseID
		
		IF(@iDocumentID is not null)
		BEGIN
			UPDATE dbo.T_Upload_Document
			SET S_Document_Name = @sDocumentName,
			S_Document_Type = @sDocumentType,
			S_Document_Path = @sDocumentPath,
			S_Document_URL = @sDocumentURL,		
			S_Upd_By = @sCreatedBy,
			Dt_Upd_On= @dCreatedOn
			where I_Document_ID = @iDocumentID
			
			UPDATE dbo.T_Course_Master
			SET I_Document_ID = @iDocumentID,
			S_Upd_By = @sCreatedBy,
			Dt_Upd_On= @dCreatedOn
			where I_Course_ID = @iCourseID
			
		END
		ELSE
		BEGIN
			INSERT INTO dbo.T_Upload_Document(S_Document_Name, S_Document_Type, S_Document_Path, S_Document_URL,I_Status, S_Crtd_By, Dt_Crtd_On)
			VALUES(@sDocumentName, @sDocumentType, @sDocumentPath, @sDocumentURL,1, @sCreatedBy, @dCreatedOn)
			
			SELECT  @iUploadDocumentID = @@IDENTITY 
			
			UPDATE dbo.T_Course_Master
			SET I_Document_ID = @iUploadDocumentID,
			S_Upd_By = @sCreatedBy,
			Dt_Upd_On= @dCreatedOn
			where I_Course_ID = @iCourseID
			
			
		END
		
	END
	ELSE IF @iFlag = 3
	BEGIN
		UPDATE dbo.T_Course_Master
		SET I_Status = 0,
		S_Upd_By = @sCreatedBy,
		Dt_Upd_On= @dCreatedOn
		WHERE I_Course_ID = @iCourseID
		IF(@iDocumentID is not null)
		BEGIN
			UPDATE dbo.T_Upload_Document
			SET I_Status = 0,
			S_Upd_By = @sCreatedBy,
			Dt_Upd_On= @dCreatedOn
			WHERE I_Document_ID = @iDocumentID
		END
	END
	
	SELECT @iCourseID AS CourseID

END TRY
BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRAN T1
	ROLLBACK TRAN T2
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
