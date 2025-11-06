CREATE PROCEDURE [dbo].[uspGetTermModuleMapping] 	
	@iTermID int
AS
BEGIN
	SET NOCOUNT OFF;

    SELECT  A.I_Term_ID, A.I_Module_ID, A.I_Sequence, A.C_Examinable, B.S_Module_Code, B.S_Module_Name
	FROM dbo.T_Module_Term_Map A, dbo.T_Module_Master B
	WHERE A.I_Module_ID = B.I_Module_ID
	AND A.I_Term_ID = @iTermID
END
