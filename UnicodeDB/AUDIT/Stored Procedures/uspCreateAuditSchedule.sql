/*
-- =================================================================
-- Author:Babin SAha
-- Create date:07/07/2007 
-- Description:Insert Schedule Into  [AUDIT].T_Audit_Schedule Table 
-- =================================================================
*/
CREATE PROCEDURE [AUDIT].[uspCreateAuditSchedule]
(
		@iCenterID			INT			,
		@dtAuditedOn 		DATETIME	,
		@iUserID			INT			,
		@iAuditTypeID		INT			,-- Coming Value Not Needed
		@iStatusID			INT			,
		@sCrtdBy			VARCHAR(20)	,
		@sUpdBy 			VARCHAR(20)	,
		@dtCretedOn 		DATETIME	,
		@dtUpdatedOn 		DATETIME    ,
		@iVar				INT			,
		@sAuditDates		VARCHAR(MAX)
)

AS
BEGIN TRY
	
DECLARE @iCountCenterID INT, @iAuditScheduleID INT
SET @iCountCenterID =0

--*********************** Check New or Existance Audit Schedule For The Center ***********************
--S_Audit_Type_Code='NEW'
--S_Audit_Type_Code='EXST'
SELECT @iCountCenterID=COUNT(*) FROM [AUDIT].T_Audit_Schedule WHERE I_Center_ID = @iCenterID
IF @iCountCenterID > 0
BEGIN
	SELECT @iAuditTypeID = I_Audit_Type_ID FROM  [AUDIT].[T_Audit_Type] WHERE S_Audit_Type_Code='EXST'
END
ELSE
BEGIN
	SELECT @iAuditTypeID = I_Audit_Type_ID FROM  [AUDIT].[T_Audit_Type] WHERE S_Audit_Type_Code='NEW'
END
--*********************** CHECK Audit Schedule Not More Than 3 in Year ***********************
DECLARE @iCountAdtYear INT
SELECT  @iCountAdtYear=COUNT(*) FROM [AUDIT].T_Audit_Schedule WHERE I_Center_ID = @iCenterID AND CONVERT(INT,DATEPART(yy,Dt_Audit_on))=CONVERT(INT,DATEPART(yy,@dtAuditedOn))


--*********************** Insert record in  [AUDIT].T_Audit_Schedule Table ***********************
IF @iCountAdtYear < @iVar -- Number of times  
BEGIN
INSERT INTO [AUDIT].T_Audit_Schedule
		(	
			I_Center_ID			
			,Dt_Audit_On		
			,I_User_ID
			,I_Audit_Type_ID
			,I_Status_ID
			,S_Crtd_By
			,S_Upd_By
			,Dt_Crtd_On
			,Dt_Upd_On		 
		)
	VALUES 
		(
			@iCenterID
			,@dtAuditedOn
			,@iUserID
			,@iAuditTypeID
			,@iStatusID
			,@sCrtdBy
			,@sUpdBy
			,@dtCretedOn
			,@dtUpdatedOn
		)
		
	SELECT @iAuditScheduleID = SCOPE_IDENTITY();

	INSERT INTO AUDIT.T_Audit_Schedule_Details
	        ( I_Audit_Schedule_ID ,
	          Dt_Audit_Date
	        )
	SELECT @iAuditScheduleID, CAST(FN.Val AS DATE) FROM dbo.fnString2Rows(@sAuditDates,',') FN
	
	SELECT  @iAuditScheduleID
END
ELSE
BEGIN
 SELECT '0'
END

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
