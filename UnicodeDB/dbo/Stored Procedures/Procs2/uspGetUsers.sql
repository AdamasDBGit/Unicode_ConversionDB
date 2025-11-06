-- =============================================
-- Author:		Debarshi Basu 
-- Create date: 01/03/2007
-- Description:	to get the data of all non Company Users
-- =============================================

CREATE PROCEDURE [dbo].[uspGetUsers] 
AS
BEGIN

	SET NOCOUNT ON;

	 SELECT U.I_User_ID,
			U.S_Login_ID,
			U.S_Title,
			U.S_Middle_Name,
			U.S_Email_ID,
			U.I_Status,
			U.S_Forget_Pwd_Answer,
			U.Dt_Crtd_On,
			H.I_Hierarchy_Master_ID
	FROM dbo.T_User_Master U, dbo.T_User_Hierarchy_Details H 
	WHERE U.S_User_Type<>'AE'
	and U.I_STATUS <> 0 

END
