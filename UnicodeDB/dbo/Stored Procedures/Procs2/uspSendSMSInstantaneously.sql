


/*****************************************************************************************************************
Created by: 
Date: 20/02/2015
Description:Send SMS To StudentID or Mobile No which are pending to be send in a loop from DTS Package
Parameters: 
******************************************************************************************************************/


CREATE PROCEDURE [dbo].[uspSendSMSInstantaneously]
(
	@iSMSDetailsID INT,
	--@sPackagePath NVARCHAR(MAX),
	@sConString NVARCHAR(MAX)
	
)
AS
BEGIN	
	DECLARE @CallPackage VARCHAR(8000)
	DECLARE @sPackagePath VARCHAR(250)
	
	 SELECT @sPackagePath = [S_PARAM_VALUE] FROM [T_SMS_PARAM_MASTER]
		WHERE [I_PARAM_ID] =8
	
	 SET @CallPackage='dtexec /f ' + @sPackagePath + '\SSISSMSTaskInstantaneous.dtsx /CONFIGFILE ' + @sPackagePath +'\SMSSendConfig.dtsConfig'
	 
	 SET @CallPackage= @CallPackage + ' /SET \package.Variables[User::SMSSendDetailID].Properties[Value];' + CONVERT(VARCHAR(10),@iSMSDetailsID) + ''
	 SET @CallPackage= @CallPackage + ' /SET "\package.Variables[User::SMSConString].Properties[Value]";"\"' + @sConString + '\""'
	 
	 
	 PRINT @CallPackage
	 EXEC xp_cmdshell @CallPackage
	 
	
END

