CREATE PROCEDURE [dbo].[uspGetTransactions]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT A.I_Transaction_ID, A.S_Transaction_Code, A.S_Transaction_Name,
	A.I_Menu_Group_ID, B.S_Menu_Group_Name, A.I_Status
	FROM T_Transaction_Master A, T_Menu_Group_Master B 
	WHERE A.I_Menu_Group_ID = B.I_Menu_Group_ID
	ORDER BY A.I_Transaction_ID

END
