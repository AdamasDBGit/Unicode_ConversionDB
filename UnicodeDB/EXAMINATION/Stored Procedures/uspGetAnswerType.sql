/**************************************************************************************************************
Created by  : Debarshi Basu
Date		: 03.05.2007
Description : This SP will retrieve all the different answer types
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE  Procedure [EXAMINATION].[uspGetAnswerType]
AS

BEGIN
	SET NOCOUNT ON;	
	SELECT I_Answer_Type_ID,S_Answer_Type_Desc
	FROM EXAMINATION.T_Answer_Type_Master
	WITH (NOLOCK)
	WHERE I_Status = 1
	
END
