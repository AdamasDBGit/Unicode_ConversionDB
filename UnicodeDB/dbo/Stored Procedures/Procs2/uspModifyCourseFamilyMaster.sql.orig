-- =============================================

-- Author:		Soumya Sikder

-- Create date: 17/01/2007

-- Description:	Modifies the Course Family Master Table

-- =============================================

CREATE PROCEDURE [dbo].[uspModifyCourseFamilyMaster] 

(

	@iCourseFamilyID int,

	@iBrandID int,

	@sCourseFamilyName varchar(50),

    @sCourseFamilyBy varchar(20),

	@dCourseFamilyOn datetime,

    @iFlag int,
	
	@isMtech int


)

AS

BEGIN TRY

	-- SET NOCOUNT ON added to prevent extra result sets from

	-- interfering with SELECT statements.

	SET NOCOUNT OFF

	

	DECLARE @sErrorCode varchar(20)



    IF @iFlag = 1

	BEGIN

		INSERT INTO dbo.T_CourseFamily_Master

		(I_Brand_ID, 

		 S_CourseFamily_Name, 

		 I_Status, 

		 S_Crtd_By, 

		 Dt_Crtd_On,

		 I_IsMTech)

		VALUES

		( @iBrandID, 

		  @sCourseFamilyName, 

          1, 

		  @sCourseFamilyBy, 

		  @dCourseFamilyOn,

		  @isMtech)    

	END

	ELSE IF @iFlag = 2

	BEGIN

		UPDATE dbo.T_CourseFamily_Master

		SET S_CourseFamily_Name = @sCourseFamilyName,

		S_Upd_By = @sCourseFamilyBy,

		Dt_Upd_On = @dCourseFamilyOn,

		 I_IsMTech=@isMtech

		where I_CourseFamily_ID = @iCourseFamilyID

	END

	ELSE IF @iFlag = 3

	BEGIN

		IF EXISTS(SELECT I_Course_ID FROM dbo.T_Course_Master

				WHERE I_CourseFamily_ID = @iCourseFamilyID

				AND I_Status = 1)

		BEGIN

			SET @sErrorCode = 'CM_100001'

		END

		ELSE

		BEGIN

			UPDATE dbo.T_CourseFamily_Master

			SET I_Status = 0,

			S_Upd_By = @sCourseFamilyBy,

			Dt_Upd_On = @dCourseFamilyOn

			WHERE I_CourseFamily_ID = @iCourseFamilyID

		END

	END

	SELECT @sErrorCode AS ERROR

END TRY

BEGIN CATCH

	--Error occurred:  



	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),

			@ErrSeverity = ERROR_SEVERITY()



	RAISERROR(@ErrMsg, @ErrSeverity, 1)

END CATCH
