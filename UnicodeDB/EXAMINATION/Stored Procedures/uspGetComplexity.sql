/**************************************************************************************************************
Created by  : Debarshi Basu
Date		: 03.05.2007
Description : This SP will retrieve all the complexities
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspGetComplexity]
AS

BEGIN
	SET NOCOUNT ON;	
	SELECT I_Complexity_ID,S_Complexity_Desc, ISNULL(N_Marks,0) AS N_Marks
	FROM EXAMINATION.T_Complexity_Master	
	WITH (NOLOCK)
	
END
