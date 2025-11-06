-- =============================================
-- Author:		Swagata De 
-- Create date: 21/2/2007
-- Description:	to get the data of all  Users
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAllUser] 
 	
AS
BEGIN

	SET NOCOUNT ON;
	
	select U.I_User_ID,U.S_Login_ID,U.S_Password,U.S_Title,U.S_First_Name,
	U.S_Middle_Name,U.S_Last_Name,U.S_Email_ID,U.S_User_Type,U.I_Status,
	U.S_Forget_Pwd_Qtn,U.S_Forget_Pwd_Answer,U.S_Crtd_By,U.S_Upd_By,
	U.Dt_Crtd_On,U.Dt_Upd_On,H.I_Hierarchy_Master_ID,H.I_Hierarchy_Detail_ID
	from dbo.T_User_Master U,dbo.T_User_Hierarchy_Details H where U.I_STATUS<>0 and U.I_User_ID=H.I_User_ID

END
