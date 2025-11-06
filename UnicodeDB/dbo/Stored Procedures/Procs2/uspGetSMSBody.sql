

/*****************************************************************************************************************
Created by: 
Date: 20/02/2015
Description:Get SMS body Based on SMSType Passed as Parameter
Parameters: 
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspGetSMSBody]
(
	@iSMSTypeId INT	
)
AS
BEGIN	
	
	SELECT S_SMS_BODY_TEMPLATE FROM dbo.[T_SMS_TYPE_MASTER]
	WHERE I_SMS_TYPE_ID= @iSMSTypeId
		AND [I_Status] =1
	 
	
END
