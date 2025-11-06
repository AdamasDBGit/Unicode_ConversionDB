/*
-- =================================================================
-- Author:Babin SAha
-- Create date:07/13/2007 
-- Description:UPDATE [AUDIT].T_Audit_Result
-- =================================================================
*/
CREATE PROCEDURE [AUDIT].[uspUpdateAuditResult]
(
			 @iAuditScheduleID			INT = NULL
			,@iAusitScheduleStatus		INT
			,@dtReportDate				DATETIME	
			,@fParScore					INT
			,@iPart_A_Score				INT
			,@iPart_B_Score				INT
			,@iPart_C_Score				INT
			,@iPart_D_Score				INT
			,@iTotalNoNC				INT
			,@iNCRStatus				INT
			,@sUpdBy					VARCHAR(20)
			,@dtUpdOn					DATETIME
			
			,@iAuditResultIDReturn		INT  OUTPUT

)

AS
BEGIN TRY
	DECLARE @iAuditResultID	INT
	SET @iAuditResultID = 0
IF EXISTS(SELECT I_Audit_Result_ID FROM [AUDIT].[T_Audit_Result] WHERE I_Audit_Schedule_ID = @iAuditScheduleID)
BEGIN

	SELECT @iAuditResultID = I_Audit_Result_ID FROM [AUDIT].[T_Audit_Result] WHERE I_Audit_Schedule_ID = @iAuditScheduleID
	-- UPDATE record in  [AUDIT].T_Audit_Result
	IF @iAuditResultID <> 0 
	BEGIN
		SET @iAuditResultIDReturn = @iAuditResultID
		UPDATE [AUDIT].[T_Audit_Schedule] SET I_Status_ID = @iAusitScheduleStatus WHERE I_Audit_Schedule_ID=@iAuditScheduleID
		
		UPDATE [AUDIT].T_Audit_Result SET 
					
					Dt_Report_Date = @dtReportDate
					,F_Par_Score = @fParScore
					,I_Part_A_Score = @iPart_A_Score
					,I_Part_B_Score = @iPart_B_Score
					,I_Part_C_Score = @iPart_C_Score
					,I_Part_D_Score = @iPart_D_Score
					,I_Total_No_NC = @iTotalNoNC
					,I_NCR_Status = @iNCRStatus
					,S_Upd_By = @sUpdBy
					,Dt_Crtd_On = @dtUpdOn
					WHERE I_Audit_Result_ID = @iAuditResultID

	END	
END
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
