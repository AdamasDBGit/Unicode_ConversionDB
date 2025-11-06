/**************************************************************************************************************
Created by  : Swagata De
Date		: 13.05.2007
Description : This SP will validate the login for access to offline examination system
Parameters  : Login ID,Password
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspValidateLogin]
	(
		@sLoginId VARCHAR(200)		
	)
AS
BEGIN
	SELECT I_Exam_Candidate_ID,S_Login_ID,S_Password,S_User_Type,I_Reference_ID
	FROM EXAMINATION.T_Offline_Users WITH(NOLOCK)
	WHERE S_Login_ID=@sLoginId 
END
