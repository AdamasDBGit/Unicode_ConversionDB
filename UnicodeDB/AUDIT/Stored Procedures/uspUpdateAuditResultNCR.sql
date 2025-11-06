/*
-- =================================================================
-- Author:Babin SAha
-- Create date:07/13/2007 
-- Description:INSERT [AUDIT].T_Audit_Result_NCR
-- =================================================================
*/
CREATE PROCEDURE [AUDIT].[uspUpdateAuditResultNCR]
(
			 @iAuditResultID			INT
			,@sNCRNumber				VARCHAR(50)
			,@sNCRDesc					VARCHAR(2000)
			,@iNCRTypeID				INT
			,@iAuditFunctionalTypeID	INT
			,@dtTargetClose				DATETIME = NULL
			,@dtActualClose				DATETIME = NULL
			,@iStatusID					INT

)

AS
BEGIN TRY
		
--	DECLARE @iAuditResultID	INT
--	SET @iAuditResultID = 0

--IF EXISTS(SELECT I_Audit_Result_ID FROM [AUDIT].[T_Audit_Result] WHERE I_Audit_Schedule_ID = @iAuditScheduleID  AND I_Audit_Result_ID=@iAuditResultID)
--BEGIN
	--SELECT @iAuditResultID = I_Audit_Result_ID FROM [AUDIT].[T_Audit_Result] WHERE I_Audit_Schedule_ID = @iAuditScheduleID
	-- UPDATE record in  [AUDIT].T_Audit_Result
	IF @iAuditResultID <> 0 
		BEGIN
			INSERT INTO [AUDIT].T_Audit_Result_NCR 
			(
				 I_Audit_Result_ID
				,S_NCR_Number
				,S_NCR_Desc
				,I_NCR_Type_ID
				,I_Audit_Functional_Type_ID
				,Dt_Target_Close
				,Dt_Actual_Close
				,I_Status_ID
			)
			VALUES
			(
				 @iAuditResultID
				,@sNCRNumber
				,@sNCRDesc
				,@iNCRTypeID
				,@iAuditFunctionalTypeID
				,@dtTargetClose
				,@dtActualClose
				,@iStatusID
			)
	END	
--END
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
