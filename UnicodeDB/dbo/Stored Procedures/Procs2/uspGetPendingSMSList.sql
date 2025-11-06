

/*****************************************************************************************************************
Created by: 
Date: 20/02/2015
Description:Get List of Pending SMS to be Send
Parameters: 
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspGetPendingSMSList]
(
	@iSMSDetailsID INT	 = NULL
	,@MaxNoOfAttempt INT = NULL
)
AS
BEGIN	
	
	SELECT [I_SMS_SEND_DETAILS_ID], [I_SMS_STUDENT_ID],[S_MOBILE_NO],[S_SMS_BODY],[I_NO_OF_ATTEMPT] 
	FROM  dbo.[T_SMS_SEND_DETAILS] SD 
	INNER JOIN [T_SMS_TYPE_MASTER] TM ON TM.[I_SMS_TYPE_ID]= SD.[I_SMS_TYPE_ID] AND TM.[I_Status] =1 
	WHERE 
	SD.[I_SMS_SEND_DETAILS_ID] = ISNULL(@iSMSDetailsID,SD.[I_SMS_SEND_DETAILS_ID])
	AND [I_IS_SUCCESS]= (CASE WHEN @iSMSDetailsID IS NOT NULL THEN [I_IS_SUCCESS] ELSE 0 END)  
	AND SD.[I_Status] =1 AND [I_NO_OF_ATTEMPT] < ISNULL(@MaxNoOfAttempt,-1)
	 
	
END
