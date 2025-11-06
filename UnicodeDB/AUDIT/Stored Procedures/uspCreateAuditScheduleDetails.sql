CREATE PROCEDURE [AUDIT].[uspCreateAuditScheduleDetails]
(
	@dtAuditDate	DATETIME    	
)

AS
BEGIN TRY
	
DECLARE @iAuditScheduleID INT

SELECT  @iAuditScheduleID=MAX(I_Audit_Schedule_ID)  FROM [AUDIT].T_Audit_Schedule

BEGIN
INSERT INTO [AUDIT].T_Audit_Schedule_Details
		(	
			 I_Audit_Schedule_ID,
			 Dt_Audit_Date
		)
	VALUES 
		(
		    @iAuditScheduleID,
			@dtAuditDate
		)
SELECT SCOPE_IDENTITY();
END

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
