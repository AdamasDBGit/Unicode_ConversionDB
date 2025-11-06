CREATE PROCEDURE [dbo].[uspGetState] 
AS
BEGIN

	SELECT  A.I_State_ID,A.S_State_Name,A.S_State_Code,A.I_Status,A.I_Country_ID,
	B.S_Country_Code ,B.S_Country_Name	
	FROM dbo.T_State_Master A,dbo.T_Country_Master B
	WHERE A.I_Country_ID = B.I_Country_ID 
	AND  A.I_Status <> 0
	ORDER BY A.S_State_Name

END
