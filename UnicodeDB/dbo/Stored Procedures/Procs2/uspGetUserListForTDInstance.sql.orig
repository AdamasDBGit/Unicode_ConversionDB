/*******************************************************
Description : Gets the list of Users of type AE and Selected Role Hierarchy
Author	:     Soumya Sikder
Date	:	  03/05/2007
*********************************************************/

CREATE PROCEDURE [dbo].[uspGetUserListForTDInstance] 
	@iTrustDomainInstanceID int,
	@sUserType varchar(20) = null
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
			H.I_Hierarchy_Master_ID
	FROM dbo.T_User_Master U, dbo.T_User_Hierarchy_Details H 
	WHERE H.I_User_ID = U.I_User_ID
	AND H.I_Hierarchy_Detail_ID = @iTrustDomainInstanceID 
	AND U.S_User_Type = COALESCE( @sUserType,U.S_User_Type)
	AND U.I_Status = 1 
	AND H.I_Status = 1
	AND GETDATE() >= ISNULL(H.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(H.Dt_Valid_To,GETDATE())


END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
