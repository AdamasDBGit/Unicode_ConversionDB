CREATE PROCEDURE [dbo].[uspGetRole] 

AS
BEGIN

	SELECT  I_Role_ID, S_Role_Code, S_Role_Desc, S_Role_Type, I_Status, I_Hierarchy_Detail_ID, S_Crtd_By, S_Upd_By, Dt_Crtd_On, Dt_Upd_On
	FROM dbo.T_Role_Master
	WHERE I_Status <> 0
	ORDER BY S_Role_Code,S_Role_Desc
END
