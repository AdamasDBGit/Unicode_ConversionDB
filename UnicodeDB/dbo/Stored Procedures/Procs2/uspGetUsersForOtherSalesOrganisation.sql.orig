CREATE PROCEDURE [dbo].[uspGetUsersForOtherSalesOrganisation]
(
	
	@sLoginID varchar(200) = null,
	@sFirstName varchar(100) = null,
	@sMiddleName varchar(100) = null,
	@sLastName varchar(100) = null,
	@iSalesOrgID int
)
AS
BEGIN

	SET NOCOUNT OFF;
	
	SELECT DISTINCT um.I_User_ID,
					um.S_Login_ID,
					um.S_First_Name,
					um.S_Middle_Name,
					um.S_Last_Name,
					um.S_User_Type,
					uhd.I_Hierarchy_Detail_ID
	FROM dbo.T_User_Master um
	LEFT OUTER JOIN T_User_Hierarchy_Details uhd
	ON um.I_User_ID = uhd.I_User_Id
	AND ISNULL(uhd.I_Status,1) <> 0
	WHERE um.I_Status <> 0
	AND um.I_User_ID NOT IN 
	(	SELECT I_User_ID 
		FROM dbo.T_User_Hierarchy_Details
		WHERE I_Hierarchy_Master_ID = @iSalesOrgID
		AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
		AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())
		AND I_Status = 1	)
	AND um.S_Login_ID LIKE ISNULL(@sLoginID, um.S_Login_ID)+ '%'
	AND ISNULL(um.S_First_Name,'%') LIKE ISNULL(@sFirstName,'')+'%'
	AND ISNULL(um.S_Middle_Name,'%') LIKE ISNULL(@sMiddleName,'')+'%'
	AND ISNULL(um.S_Last_Name,'%') LIKE ISNULL(@sLastName,'')+'%'
END
