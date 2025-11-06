/**************************************************************************************************************
Created by  : Debarshi Basu
Date		: 01.05.2007
Description : This SP will retrieve the list of all the Question Banks
Parameters  : nil
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspGetQuestionBankList]
(
	@iBrandID INT = NULL
)
AS

BEGIN
	SET NOCOUNT ON;	
	
	SELECT I_Question_Bank_ID,S_Bank_Desc
	FROM EXAMINATION.T_Question_Bank_Master
	WITH (NOLOCK)
	WHERE I_Status = 1
	AND I_Brand_ID = ISNULL(@iBrandID, I_Brand_ID)
	ORDER BY S_Bank_Desc
END
