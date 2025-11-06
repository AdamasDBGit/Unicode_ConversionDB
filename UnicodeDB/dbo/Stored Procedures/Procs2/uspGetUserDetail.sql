/*******************************************************
Description : Gets the Details of Users of selected User Id 
Author	:     Shankha Roy
Date	:	  07/11/2007
*********************************************************/

CREATE PROCEDURE [dbo].[uspGetUserDetail] 
	@iUserID int
	
AS
BEGIN TRY

	SELECT U.I_User_ID,
			U.S_Login_ID,
			U.S_Title,
			U.S_First_Name,
			U.S_Middle_Name,
			U.S_Last_Name,
			U.S_Email_ID,
			U.I_Status,
			U.S_Forget_Pwd_Answer,
			U.Dt_Crtd_On,
			RM.S_Role_Code 			
	FROM dbo.T_User_Master U
	inner join dbo.T_User_Role_Details USERRODTL
		on U.I_User_ID= USERRODTL.I_User_ID 
		inner join dbo.T_Role_Master RM
		on USERRODTL.I_Role_ID=RM.I_Role_ID 
	WHERE U.I_User_ID = @iUserID
	

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
