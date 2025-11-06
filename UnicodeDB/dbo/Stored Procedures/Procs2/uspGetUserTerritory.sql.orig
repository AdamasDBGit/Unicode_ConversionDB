CREATE PROCEDURE [dbo].[uspGetUserTerritory]
(
	@vLoginID varchar(200)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF

	SELECT A.I_UTD_Detail_ID, A.I_UTD_User_ID, A.I_UTD_Brand_ID, A.I_UTD_Country_Group_ID, A.I_UTD_Country_ID, A.I_UTD_Zone_Id, A.I_UTD_Rgn_ID, A.I_UTD_Centre_Id, A.I_UTD_Is_Default
	FROM dbo.T_User_Territory_Details A, dbo.T_User_Master B
	WHERE A.I_UTD_User_ID = B.I_TUM_User_ID
	AND B.S_TUM_Login_ID = @vLoginID
END
