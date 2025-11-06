-- =============================================
-- Author:		Abhisek Bhattacharya
-- Create date: 27/12/2006
-- Description:	Selects all the Transactions and Role ID mapping
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTransactionsForRole] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT A.I_Role_Transaction_ID, A.I_Transaction_ID, A.I_Status, 
	B.S_Transaction_Code, B.S_Transaction_Name, A.I_Role_ID
	FROM T_Role_Transaction A, T_Transaction_Master B 
	WHERE A.I_Transaction_ID = B.I_Transaction_ID
END
