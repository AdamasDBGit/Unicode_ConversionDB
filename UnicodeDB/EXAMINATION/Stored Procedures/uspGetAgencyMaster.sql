/**************************************************************************************************************
Created by  : Debarshi Basu
Date		: 03.05.2007
Description : This SP will retrieve all the details from Agency master table
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspGetAgencyMaster]
AS

BEGIN
	SET NOCOUNT ON;	
	
	SELECT I_Agency_ID,S_Agency_Name,S_Agency_Address1,S_Agency_Address2,S_Agency_Email
	FROM EXAMINATION.T_Agency_Master ORDER BY S_Agency_Name
END
