-- =============================================
-- Author:		Debarshi Basu
-- Create date: 23/03/2007
-- Description:	Modifies the Software master table
-- =============================================
CREATE PROCEDURE [NETWORK].[uspModifySoftwareMaster] 

	@iSoftwareID INT,
	@iBrandID INT,
	@sSoftwareName VARCHAR(20),
	@sRecVersion VARCHAR(50),
	@sRecLicence VARCHAR(200),
	@sCreatedBy VARCHAR(20),
	@dCreatedOn DATETIME,	
	@iFlag INT
AS
BEGIN TRY

	SET NOCOUNT OFF;

	IF(@iFlag=1)
		BEGIN
			INSERT INTO NETWORK.T_Software_Master (
											I_Brand_ID,
											S_Software_Name,
											S_Rec_Version,
											S_Rec_License_No,
											S_Crtd_By,
											Dt_Crtd_On,
											I_Status
											)
			VALUES (
					@iBrandID,
					@sSoftwareName,
					@sRecVersion,
					@sRecLicence,
					@sCreatedBy,	
					@dCreatedOn,
					1
					)

		END
	IF(@iFlag=2)
		BEGIN
			UPDATE NETWORK.T_Software_Master SET
			I_Brand_ID = @iBrandID,
			S_Software_Name = @sSoftwareName,
			S_Rec_Version = @sRecVersion,
			S_Rec_License_No = @sRecLicence,
			S_Upd_By = @sCreatedBy,
			Dt_Upd_On = @dCreatedOn
			WHERE I_Software_ID = @iSoftwareID
				AND I_Status = 1
		END

	IF(@iFlag=3)
		BEGIN
			UPDATE NETWORK.T_Software_Master SET
			I_Status=0,
			S_Upd_By=@sCreatedBy,
			Dt_Upd_On=@dCreatedOn
			WHERE I_Software_ID = @iSoftwareID
				AND I_Status = 1
		END
	
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
