/**************************************************************************************************************
Created by  : Swagata De
Date		: 10.05.2007
Description : This SP will retrieve the center id and its corresponding connection string
Parameters  : 
Returns     : 
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspGetConnectionString]
	(
		@iCenterId INT=NULL
				
	) 
AS
BEGIN
	SELECT I_Centre_Id,S_Connection_String
	FROM EXAMINATION.T_Center_Connection WITH (NOLOCK)
	WHERE I_Centre_Id=ISNULL(@iCenterId,I_Centre_Id)
END
