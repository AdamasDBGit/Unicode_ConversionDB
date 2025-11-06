/*
-- =================================================================
-- Author:Sanjay Mitra
-- Create date:07/16/2007 
-- Description:INSERT [AUDIT].T_Audit_Result_NCR 
-- =================================================================
*/

---[AUDIT].[uspUpdatePrepareSendNCR] NULL,'1/Mar/2011','31/Mar/2011',1,1,0,NULL,2,1177,292340

CREATE PROCEDURE [AUDIT].[uspUpdatePrepareSendNCR]
(			 
             @iAuditScheduleID			INT = NULL
			,@iAusitScheduleStatus		INT
			,@iAuditResultID			INT		
			,@dtReportDate				DATETIME	
			,@fParScore					DECIMAL(4,2)
			,@iTotalNoNC				INT
			,@iTotalNCRepeated			INT
			,@iTotalNewNC				INT
			,@iNCRStatus				INT
			,@sUpdBy					VARCHAR(20)
			,@dtUpdOn					DATETIME
			,@ReportEscalated			VARCHAR(20)		
			,@fileName                  VARCHAR(100)
			,@iAuditResultIDReturn		INT  OUTPUT
			
		
)

AS
PRINT @fParScore
--BEGIN TRY
		
--	DECLARE @iTNewNC	INT
--	SET @iTNewNC = 0
--	SET @iAuditResultID = 0
--
--IF EXISTS(SELECT I_Audit_Result_ID FROM [AUDIT].[T_Audit_Result] WHERE I_Audit_Result_ID=@iAuditResultID)
--BEGIN
--	SET @iAuditResultIDReturn = @iAuditResultID
--	SELECT @iAuditResultID = I_Audit_Result_ID FROM [AUDIT].[T_Audit_Result] WHERE I_Audit_Result_ID = @iAuditResultID
--	
--	--SET @iTNewNC = (SELECT I_Audit_Result_ID FROM [AUDIT].[T_Audit_Result] WHERE I_Audit_Result_ID= @iAuditResultID AND I_NCR_Status = @iStatusID)
--	
--	IF @iAuditResultID <> 0 
--		BEGIN
			
		--IF(@iAuditResultID > 0 AND @@ERROR = 0)
			
	    UPDATE [AUDIT].[T_Audit_Schedule] SET I_Status_ID = @iAusitScheduleStatus 
	    WHERE I_Audit_Schedule_ID=@iAuditScheduleID
			
		UPDATE  [AUDIT].T_Audit_Result
			SET	Dt_Report_Date = @dtReportDate,F_Par_Score = @fParScore,S_File_Name=@fileName,
			I_Total_No_NC = COALESCE(@iTotalNoNC, I_Total_No_NC), 
			I_Total_No_Repeated_NC  = COALESCE(@iTotalNCRepeated, I_Total_No_Repeated_NC),
			I_Total_No_New_NC = COALESCE(@iTotalNewNC, I_Total_No_New_NC),
			S_Report_Escalated_To = COALESCE(@ReportEscalated, S_Report_Escalated_To),
			Dt_Upd_On = COALESCE(@dtUpdOn,Dt_Upd_On)
			WHERE I_Audit_Result_ID = @iAuditResultID;
		--END	
--END
--END TRY
--
--BEGIN CATCH
	--Error occurred:  

--	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
--	SELECT	@ErrMsg = ERROR_MESSAGE(),
--			@ErrSeverity = ERROR_SEVERITY()
--
--	RAISERROR(@ErrMsg, @ErrSeverity, 1)
--	
--END CATCH
