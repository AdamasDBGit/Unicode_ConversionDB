/**************************************************************************************************************
Created by  : Debarshi Basu
Date		: 09.05.2007
Description : This SP will save the user credentials in the ExamCandidate table for each center
Parameters  : 
Returns     : 
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspSaveUserCredentialsForCenter]
	(	
		@iCenterID int,
		@sUserCredentials XML 		
	)
AS

BEGIN TRY
	SET NOCOUNT ON;	
	DECLARE	
	@sLoginID VARCHAR(200), 
    @sPassword VARCHAR(200),
    @sUserType VARCHAR(50),
    @iRefID INT 

	--	Create Temporary Table To store offline user attributes from XML
	CREATE TABLE #tempTable
	(            
		S_Login_ID varchar(200),
		S_Password varchar(200),
		S_User_Type varchar(50),
		I_Reference_ID int
	)

--	Insert Values into Temporary Table
	INSERT INTO #tempTable
	SELECT T.c.value('@S_Login_ID','varchar(200)'),
			T.c.value('@S_Password','varchar(200)'),
			T.c.value('@S_User_Type','varchar(50)'),
			T.c.value('@I_Reference_ID','int')
	FROM   @sUserCredentials.nodes('/OfflineUserList/OfflineUser') T(c)       
		
		--Update the entries already present
		UPDATE TEC
		SET TEC.S_Password=TEMP1.S_Password,
			TEC.S_User_Type=TEMP1.S_User_Type,
			TEC.I_Reference_ID=TEMP1.I_Reference_ID
		FROM EXAMINATION.T_Offline_Users  TEC,#tempTable TEMP1
		WHERE TEC.S_Login_ID = TEMP1.S_Login_ID
		AND I_Center_ID = @iCenterID
		
		--Insert only those entries which are not present	
		INSERT INTO EXAMINATION.T_Offline_Users 
		(
			I_Center_ID,
			S_Login_ID,
			S_Password,
			S_User_Type,
			I_Reference_ID
			
		)
		SELECT @iCenterID,* FROM #tempTable WHERE S_Login_ID NOT IN ( SELECT S_Login_ID FROM EXAMINATION.T_Offline_Users )

		TRUNCATE TABLE #tempTable
		DROP TABLE #tempTable

END TRY	
	
BEGIN CATCH
--Error occurred:  

DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
SELECT	@ErrMsg = ERROR_MESSAGE(),
		@ErrSeverity = ERROR_SEVERITY()

RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
