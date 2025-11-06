-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	Modifies the Qualification Name master table
-- =============================================

CREATE PROCEDURE [dbo].[uspModifyQualificationNameMaster]
	@iQualificationNameID int,
	@iQualificationTypeID int,
	@sQualificationName varchar(50),
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
			INSERT INTO dbo.T_Qualification_Name_Master(
												I_Qualification_Type_ID,
												S_Qualification_Name,
												I_Status, 
												S_Crtd_By,
												Dt_Crtd_On
										   )
			VALUES(
					@iQualificationTypeID,
					@sQualificationName, 
					1, 
					@sCreatedBy, 
					@dtCreatedOn
				)
			SET @iResult = 1  -- Insertion successful
		END	
			
		ELSE IF(@iFlag=2)
		BEGIN
				UPDATE dbo.T_Qualification_Name_Master
				SET I_Qualification_Type_ID = @iQualificationTypeID,
				S_Qualification_Name = @sQualificationName,
				S_Upd_By = @sCreatedBy,
				Dt_Upd_On = @dtCreatedOn
				where I_Qualification_Name_ID = @iQualificationNameID	
				SET @iResult = 1  -- Updation successful
		END

	ELSE IF(@iFlag = 3)
		BEGIN
			IF NOT EXISTS(SELECT I_Qualification_Name_ID FROM dbo.T_Enquiry_Regn_Detail WHERE I_Qualification_Name_ID=@iQualificationNameID)
				BEGIN
					UPDATE dbo.T_Qualification_Name_Master
					SET I_Status = 0,
					S_Upd_By = @sCreatedBy,
					Dt_Upd_On = @dtCreatedOn
					where I_Qualification_Name_ID = @iQualificationNameID
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
