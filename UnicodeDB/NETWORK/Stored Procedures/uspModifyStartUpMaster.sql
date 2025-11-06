-- =============================================
-- Author:		Debarshi Basu
-- Create date: 23/03/2007
-- Description:	Modifies the StartUp master table
-- =============================================
CREATE PROCEDURE [NETWORK].[uspModifyStartUpMaster] 

	@iStartUpID INT,
	@iBrandID INT,
	@sMaterialItem VARCHAR(20),
	@sRecNumber VARCHAR(50),
	@sRecSpec VARCHAR(200),
	@sCreatedBy VARCHAR(20),
	@dCreatedOn DATETIME,	
	@iFlag INT
AS
BEGIN TRY

	SET NOCOUNT OFF;

	IF(@iFlag=1)
		BEGIN
			INSERT INTO NETWORK.T_Startup_Kit_Master (
											I_Brand_ID,
											S_Material_Item,
											S_Rec_No,
											S_Rec_Spec,
											S_Crtd_By,
											Dt_Crtd_On,
											I_Status
											)
			VALUES (
					@iBrandID,
					@sMaterialItem,
					@sRecNumber,
					@sRecSpec,
					@sCreatedBy,	
					@dCreatedOn,
					1
					)

		END
	IF(@iFlag=2)
		BEGIN
			UPDATE NETWORK.T_Startup_Kit_Master SET
			I_Brand_ID = @iBrandID,
			S_Material_Item = @sMaterialItem,
			S_Rec_No = @sRecNumber,
			S_Rec_Spec = @sRecSpec,
			S_Upd_By = @sCreatedBy,
			Dt_Upd_On = @dCreatedOn
			WHERE I_Startup_Kit_ID = @iStartUpID
				AND I_Status = 1
		END

	IF(@iFlag=3)
		BEGIN
			UPDATE NETWORK.T_Startup_Kit_Master SET
			I_Status=0,
			S_Upd_By=@sCreatedBy,
			Dt_Upd_On=@dCreatedOn
			WHERE I_Startup_Kit_ID = @iStartUpID
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
