CREATE PROCEDURE [dbo].[uspAuditNotification]
(
	@sLoginID VARCHAR(20)
	,@iTaskID INT
	,@iID INT
	,@sMessage VARCHAR(500)
)

AS
BEGIN

DECLARE @id INT
DECLARE @sCenterName VARCHAR(100)
DECLARE @iCenterId int

	IF ( @iTaskID = 84 OR @iTaskID = 80 OR @iTaskID = 81 OR @iTaskID = 82)
	BEGIN

		IF EXISTS(SELECT I_User_Id FROM  dbo.fnGetCHandASH(@iID,8))
		BEGIN

			SELECT @sMessage = @sMessage + S_Center_Name
			FROM dbo.T_Centre_Master WHERE I_Centre_Id = @iID

			INSERT INTO dbo.T_Task_Details
			VALUES(@iTaskID,@sMessage,'',2,2,1,NULL,getdate(),getdate(),NULL)

			SET @id = SCOPE_IDENTITY()

			INSERT INTO dbo.T_Task_Assignment
			SELECT @id,I_User_Id,@sLoginID FROM dbo.fnGetCHandASH(@iID,8)
		END
	END
	ELSE IF (@iTaskID = 83)
	BEGIN

	
	DECLARE @sNCCode VARCHAR(100)

			SELECT @sCenterName =  CM.S_Center_Name
			FROM AUDIT.T_Audit_Result AR
			INNER JOIN AUDIT.T_Audit_Schedule A
				ON A.I_Audit_Schedule_Id = AR.I_Audit_Schedule_Id
			INNER JOIN dbo.T_Centre_Master CM
				ON CM.I_Centre_id = A.I_Center_Id
			WHERE AR.I_Audit_Result_Id = @iID

--			SELECT @sNCCode =  ARNCR.S_NCR_Number
--			FROM AUDIT.T_Audit_Result AR
--			INNER JOIN AUDIT.T_Audit_Result_NCR ARNCR
--				ON AR.I_Audit_Result_Id = ARNCR.I_Audit_Result_Id
--			WHERE ARNCR.I_Audit_Result_Id = @iID
			
			SET @sMessage = 'Request to close NC : ' + @sCenterName
			INSERT INTO dbo.T_Task_Details
			VALUES(@iTaskID,@sMessage,'',2,2,1,NULL,GETDATE(),GETDATE(),NULL)

			SET @id = SCOPE_IDENTITY()

			INSERT INTO dbo.T_Task_Assignment
			SELECT @id,I_User_Id,@sLoginID
			FROM dbo.T_User_Master WHERE S_Login_Id IN
			(
				SELECT DISTINCT AR.S_Crtd_by
				FROM AUDIT.T_Audit_Result AR
				WHERE AR.I_Audit_Result_Id = @iID
			)
	END
	ELSE IF (@iTaskID = 116 OR @iTaskID = 117)
	BEGIN
		
		SELECT 	@sCenterName = CM.S_Center_Name, @iCenterId = CM.I_Centre_Id
		FROM dbo.T_Centre_Master CM
		INNER JOIN AUDIT.T_Audit_Schedule A
				ON A.I_Center_Id = CM.I_Centre_Id
		INNER JOIN AUDIT.T_Schedule_Change_Request SCR
				ON SCR.I_Audit_Schedule_Id = A.I_Audit_Schedule_Id
		WHERE SCR.I_Schedule_Change_Request_Id = @iID

		SET @sMessage = @sMessage + @sCenterName

		INSERT INTO dbo.T_Task_Details
		VALUES(@iTaskID,@sMessage,'',2,2,1,NULL,GETDATE(),GETDATE(),NULL)

		SET @id = SCOPE_IDENTITY()

			IF (@iTaskID = 116)
			BEGIN
				INSERT INTO dbo.T_Task_Assignment
				SELECT @id,I_User_Id,@sLoginID FROM dbo.fnGetCHandASH(@iCenterId,8)
			END
		INSERT INTO dbo.T_Task_Assignment
		SELECT @id,I_User_Id,@sLoginID
		FROM dbo.T_User_Master WHERE S_Login_Id in
		(
			SELECT S_Crtd_By FROM AUDIT.T_Schedule_Change_Request
			WHERE I_Schedule_Change_Request_ID = @iID
		)

	END

END
