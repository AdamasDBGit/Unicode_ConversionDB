



/*****************************************************************************************************************
Created by: 
Date: 20/02/2015
Description:Get SMS Configuration Details
Parameters: 
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspGetSMSConfiguration]

AS
BEGIN	
	DECLARE @Url VARCHAR(500),@UID VARCHAR(25),@PWD VARCHAR(250),@SenderID VARCHAR(250),@MaxNoOfAttempt INT, @IsSMSRequired BIT

SELECT @Url=Url.S_PARAM_VALUE,@UID=Uname.S_PARAM_VALUE ,@PWD=Pword.S_PARAM_VALUE ,@SenderID=Sender.S_PARAM_VALUE
		,@MaxNoOfAttempt= NOA.S_PARAM_VALUE, @IsSMSRequired = Req.S_PARAM_VALUE
		FROM 
		(SELECT 1 as ID,S_PARAM_NAME, S_PARAM_VALUE  FROM [T_SMS_PARAM_MASTER]  WHERE I_PARAM_ID=1) AS Url
		INNER JOIN (SELECT 1 as ID,S_PARAM_NAME, S_PARAM_VALUE  FROM [T_SMS_PARAM_MASTER]  WHERE I_PARAM_ID=2) AS Uname 
		ON Uname.ID=Url.ID
		INNER JOIN (SELECT 1 as ID,S_PARAM_NAME, S_PARAM_VALUE  FROM [T_SMS_PARAM_MASTER]  WHERE I_PARAM_ID=3) AS Pword 
		ON Pword.ID=Url.ID
		INNER JOIN (SELECT 1 as ID,S_PARAM_NAME, S_PARAM_VALUE  FROM [T_SMS_PARAM_MASTER]  WHERE I_PARAM_ID=4) AS Sender 
		ON Sender.ID=Url.ID
		INNER JOIN (SELECT 1 as ID,S_PARAM_NAME, S_PARAM_VALUE  FROM [T_SMS_PARAM_MASTER]  WHERE I_PARAM_ID=6) AS NOA 
		ON NOA.ID=Url.ID
		INNER JOIN (SELECT 1 as ID,S_PARAM_NAME, S_PARAM_VALUE  FROM [T_SMS_PARAM_MASTER]  WHERE I_PARAM_ID=5) AS Req 
		ON Req.ID=Url.ID

		SET @Url =REPLACE(@Url,'[USERNAME]',@UID)
		SET @Url =REPLACE(@Url,'[PASSWORD]',@PWD)
		SET @Url =REPLACE(@Url,'[SENDERID]',@SenderID)
		
		SELECT @Url AS Url, @MaxNoOfAttempt AS MaxNoOfAttempt, @IsSMSRequired AS IsSMSRequired
	 
	
END
