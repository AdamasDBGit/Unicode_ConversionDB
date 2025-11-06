/*
-- =================================================================
-- Author:Sanjay Mitra
-- Create date:07/12/2007 
-- Description:Insert Report Into  [AUDIT].T_Audit_Result 
-- =================================================================
*/
 CREATE PROCEDURE [AUDIT].[uspUploadNewCenterAuditReportInsert]
(
			 @iAuditScheduleID			INT 
			,@iVisitReportDocumentID	INT = NULL
			,@iNCRStatus				INT = NULL
			,@sCrtdBy					VARCHAR(20)
			,@sUpdBy					VARCHAR(20)
			,@iAuditScheduleStatus		INT		
			
			,@dtReportDate				DATETIME = NULL		
			,@fParScore					INT = NULL
			,@iTotalNoNC				INT = 0
			,@iTotalNoRepeatedNC		INT = 0
			,@iTotalNoNewNC				INT = 0
			,@sAuditedBy				VARCHAR(20) = NULL
			,@sReportEscalatedTo		VARCHAR(20) = NULL
			,@dtCrtdOn					DATETIME
			,@dtUpdOn					DATETIME
)

AS
BEGIN TRY

BEGIN TRANSACTION Trans_AtdResul

UPDATE [AUDIT].T_Audit_Schedule SET I_Status_ID=@iAuditScheduleStatus WHERE I_Audit_Schedule_ID=@iAuditScheduleID

IF (@@ERROR = 0)
BEGIN
---- Insert record in  [AUDIT].T_Audit_Result
INSERT INTO [AUDIT].T_Audit_Result
		(	
			I_Audit_Schedule_ID
			,Dt_Report_Date
			,F_Par_Score
			,I_Total_No_NC
			,I_Total_No_Repeated_NC
			,I_Total_No_New_NC
			,S_Audited_By
			,S_Report_Escalated_To
			,I_Visit_Report_Document_ID
			,I_NCR_Status
			,S_Crtd_By
			,S_Upd_By
			,Dt_Crtd_On
			,Dt_Upd_On
	 
		)
	VALUES 
		(
			 @iAuditScheduleID
			,@dtReportDate					
			,@fParScore
			,@iTotalNoNC
			,@iTotalNoRepeatedNC
			,@iTotalNoNewNC
			,@sAuditedBy
			,@sReportEscalatedTo
			,@iVisitReportDocumentID
			,@iNCRStatus
			,@sCrtdBy
			,@sUpdBy
			,@dtCrtdOn
			,@dtUpdOn
		)
	COMMIT TRANSACTION Trans_AtdResul
END
ELSE
BEGIN
	ROLLBACK TRANSACTION Trans_AtdResul
END


END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
