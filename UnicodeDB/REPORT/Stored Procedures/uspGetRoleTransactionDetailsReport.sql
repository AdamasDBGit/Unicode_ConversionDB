/*
-- =================================================================
-- Author:Soumya Sikder
-- Create date:31/01/2008 
-- Description: Fetch List of all Transaction fotr a particular role
-- =================================================================
*/
CREATE PROCEDURE [REPORT].[uspGetRoleTransactionDetailsReport]
(
   @sRoleDesc VARCHAR(150) = NULL
)
AS
BEGIN TRY
-- exec [REPORT].[uspGetRoleTransactionDetailsReport] 'System Administrator'
SELECT MGM.S_Menu_Group_Name,
	   TM.I_Transaction_ID,
	   TM.S_Transaction_Code,
	   TM.S_Transaction_Name
FROM dbo.T_Transaction_Master TM
INNER JOIN dbo.T_Menu_Group_Master MGM
ON MGM.I_Menu_Group_ID = TM.I_Menu_Group_ID
INNER JOIN dbo.T_Role_Transaction RT
ON RT.I_Transaction_ID = TM.I_Transaction_ID
INNER JOIN dbo.T_Role_Master RM
ON RM.I_Role_ID = RT.I_Role_ID
WHERE TM.I_Status = 1
AND RT.I_Status = 1
AND RM.I_Status = 1
AND RM.S_Role_Desc LIKE @sRoleDesc
ORDER BY MGM.S_Menu_Group_Name
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
