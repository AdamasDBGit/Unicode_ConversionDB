-- =============================================
-- Author:		Debarshi Basu
-- Create date: 23/03/2007
-- Description:	Modifies the Occupation type master table
-- =============================================
CREATE PROCEDURE [dbo].[uspModifyOccupationMaster] 

	@iOccupationID INT,
	@sOccupationName VARCHAR(50),
	@sOccupationBy VARCHAR(20),
	@dtOccupationOn DATETIME,
	@iFlag INT
AS
BEGIN TRY

	SET NOCOUNT OFF;
	DECLARE @iResult INT
	
	set @iResult = 0 -- set to default zero 
	
	IF(@iFlag=1)
		BEGIN
			INSERT INTO T_Occupation_Master (
											S_Occupation_Name,
											I_Status,
											S_Crtd_By,
											Dt_Crtd_On
											)
			VALUES (
					@sOccupationName,
					1,
					@sOccupationBy,
					@dtOccupationOn
					)
			SET @iResult = 1  -- Insertion successful
		END
	IF(@iFlag=2)
		BEGIN
			UPDATE T_Occupation_Master SET
			S_Occupation_Name=@sOccupationName,
			S_Upd_By=@sOccupationBy,
			Dt_Upd_On=@dtOccupationOn
			WHERE I_Occupation_ID=@iOccupationID
			SET @iResult = 1  -- Updation successful
		END

	IF(@iFlag=3)
		BEGIN
			IF NOT EXISTS(SELECT I_Occupation_ID FROM dbo.T_Enquiry_Regn_Detail WHERE I_Occupation_ID=@iOccupationID)
				BEGIN
					UPDATE T_Occupation_Master SET
					I_Status=0,
					S_Upd_By=@sOccupationBy,
					Dt_Upd_On=@dtOccupationOn
					WHERE I_Occupation_ID=@iOccupationID
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
