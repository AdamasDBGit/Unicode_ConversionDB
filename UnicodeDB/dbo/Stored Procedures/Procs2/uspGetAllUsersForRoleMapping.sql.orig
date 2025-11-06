CREATE PROCEDURE [dbo].[uspGetAllUsersForRoleMapping]
	-- Add the parameters for the stored procedure here
			@iSelectedHierarchyId int,
			@vLoginID varchar(100),
			@vFirstName varchar(100) = null,
			@vMiddleName varchar(100) = null,
			@vLastName varchar(100) = null,
			@sCriteron varchar (5)
 			
AS

BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT um.I_User_ID,
					um.S_Login_ID,
					um.S_First_Name,
					um.S_Middle_Name,
					um.S_Last_Name, 
					um.S_User_Type, 
					um.S_User_Type,
					urd.I_Role_ID,
					uhd.I_Hierarchy_Detail_ID
FROM T_User_Master um
LEFT OUTER JOIN T_User_Hierarchy_Details uhd
ON um.I_User_ID = uhd.I_User_Id
AND ISNULL(uhd.I_Status,1) <> 0
INNER JOIN T_Hierarchy_Details hd
ON uhd.I_Hierarchy_Detail_ID = hd.I_Hierarchy_Detail_ID
INNER JOIN T_Hierarchy_Mapping_Details hmd
ON hd.I_Hierarchy_Detail_ID = hmd.I_Hierarchy_Detail_ID
LEFT OUTER JOIN T_User_Role_Details urd
ON um.I_User_ID = urd.I_User_ID
AND ISNULL(urd.I_Status,1) <> 0
WHERE um.I_Status<>0
AND hmd.S_Hierarchy_Chain LIKE (SELECT S_Hierarchy_Chain FROM T_Hierarchy_Mapping_Details 
			WHERE I_Hierarchy_Detail_ID = @iSelectedHierarchyId
			AND I_Status = 1
			AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
			AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE()) )+@sCriteron
AND um.S_Login_ID LIKE ISNULL(@vLoginID,um.S_Login_ID)+'%'
AND ISNULL(um.S_First_Name,'%') LIKE ISNULL(@vFirstName,'')+'%'
AND ISNULL(um.S_Middle_Name,'%') LIKE ISNULL(@vMiddleName,'')+'%'
AND ISNULL(um.S_Last_Name,'%') LIKE ISNULL(@vLastName,'')+'%'
END
