-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	Modifies the Qualification Name master table
-- =============================================

CREATE PROCEDURE [dbo].[uspModifyQualificationTypeMaster]
	@iQualificationTypeID int,
	@sQualificationTypeName varchar(50),
	@sCreatedBy varchar(20),
	@dtCreatedOn datetime,
	@iFlag int			
AS
BEGIN TRY

	SET NOCOUNT OFF;
	DECLARE @iResult INT
	
	set @iResult = 0 -- set to default zero 

	if(@iFlag=1)
		BEGIN
			INSERT INTO dbo.T_Qualification_Type_Master(
												S_Qualification_Type,
												I_Status,
												S_Crtd_By, 
												Dt_Crtd_On
										   )
			VALUES(
					@sQualificationTypeName, 
					1, 
					@sCreatedBy, 
					@dtCreatedOn
				)
			SET @iResult = 1  -- Insertion successful
		END	
			
		ELSE IF(@iFlag=2)
		BEGIN
				UPDATE dbo.T_Qualification_Type_Master
				SET S_Qualification_Type = @sQualificationTypeName,
				S_Upd_By = @sCreatedBy,
				Dt_Upd_On = @dtCreatedOn
				where I_Qualification_Type_ID = @iQualificationTypeID	
				SET @iResult = 1  -- Updation successful	
		END

	ELSE IF(@iFlag = 3)
		BEGIN
			IF NOT EXISTS(SELECT I_Qualification_Type_ID FROM dbo.T_Qualification_Name_Master WHERE I_Qualification_Type_ID=@iQualificationTypeID)
				BEGIN
					UPDATE dbo.T_Qualification_Type_Master
					SET I_Status = 0,
					S_Upd_By = @sCreatedBy,
					Dt_Upd_On = @dtCreatedOn
					where I_Qualification_Type_ID = @iQualificationTypeID
					SET @iResult = 1  -- Deletion successful
				END
			ELSE
				BEGIN
					SET @iResult = 2  -- Deletion not allowed due to Foreign Key Constraint
				END
		END
		SELECT @iResult Result
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
