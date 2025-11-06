CREATE PROCEDURE [dbo].[uspGetAllUsersforRoleMappingWithBrand] --2,'','','','','',22
	-- Add the parameters for the stored procedure here
			@iSelectedHierarchyId int,
			@vLoginID varchar(100),
			@vFirstName varchar(100),
			@vMiddleName varchar(100),
			@vLastName varchar(100),
			@sCriteron varchar (5),
			@iSelectedBrandID int
 			
AS

BEGIN
	SET NOCOUNT ON;
	
		DECLARE @Is_Last_Node int
		
		SELECT @Is_Last_Node = hlm.I_Is_Last_Node 
		FROM T_Hierarchy_Details hd
		INNER JOIN T_Hierarchy_Level_Master hlm
		ON hd.I_Hierarchy_Level_Id = hlm.I_Hierarchy_Level_Id
		WHERE I_Hierarchy_Detail_ID = @iSelectedHierarchyId
		
		IF @Is_Last_Node<>1
		BEGIN
			SELECT DISTINCT um.I_User_ID,
							um.S_Login_ID,
							um.S_First_Name,
							um.S_Middle_Name,
							um.S_Last_Name,
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
		INNER JOIN T_Hierarchy_Level_Master hlm
		ON hd.I_Hierarchy_Level_Id = hlm.I_Hierarchy_Level_Id
		LEFT OUTER JOIN T_User_Role_Details urd
		ON um.I_User_ID = urd.I_User_ID
		AND ISNULL(urd.I_Status,1) <> 0
		WHERE um.I_Status<>0		
		AND hlm.I_Is_Last_Node =0
		AND hmd.S_Hierarchy_Chain LIKE (select S_Hierarchy_Chain FROM T_Hierarchy_Mapping_Details WHERE I_Hierarchy_Detail_ID=@iSelectedHierarchyId and I_Status = 1 )+@sCriteron
		AND um.S_Login_ID LIKE ISNULL(@vLoginID,um.S_Login_ID)+'%'
		AND um.S_First_Name LIKE ISNULL(@vFirstName,'')+'%'
		AND ISNULL(um.S_Middle_Name,'') LIKE ISNULL(@vMiddleName,'')+'%'
		AND ISNULL(um.S_Last_Name,'') LIKE ISNULL(@vLastName,'')+'%'

		UNION
			SELECT DISTINCT um.I_User_ID,
							um.S_Login_ID,
							um.S_First_Name,
							um.S_Middle_Name,
							um.S_Last_Name,
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
		INNER JOIN T_Hierarchy_Level_Master hlm
		ON hd.I_Hierarchy_Level_Id = hlm.I_Hierarchy_Level_Id
		INNER JOIN T_Center_Hierarchy_Details chd
		ON hd.I_Hierarchy_Detail_ID = chd.I_Hierarchy_Detail_ID
		INNER JOIN T_Brand_Center_Details bcd
		ON bcd.I_Centre_Id=chd.I_Center_Id
		LEFT OUTER JOIN T_User_Role_Details urd
		ON um.I_User_ID = urd.I_User_ID
		AND ISNULL(urd.I_Status,1) <> 0
		WHERE um.I_Status<>0
		AND chd.I_Status<>0		
		AND hlm.I_Is_Last_Node =1
		AND bcd.I_Brand_ID=@iSelectedBrandID
		AND hmd.S_Hierarchy_Chain LIKE (select S_Hierarchy_Chain FROM T_Hierarchy_Mapping_Details WHERE I_Hierarchy_Detail_ID=@iSelectedHierarchyId and I_Status = 1 )+@sCriteron
		AND um.S_Login_ID LIKE ISNULL(@vLoginID,um.S_Login_ID)+'%'
		AND um.S_First_Name LIKE ISNULL(@vFirstName,'')+'%'
		AND ISNULL(um.S_Middle_Name,'') LIKE ISNULL(@vMiddleName,'')+'%'
		AND ISNULL(um.S_Last_Name,'') LIKE ISNULL(@vLastName,'')+'%'
		
	END
		ELSE
	BEGIN
			SELECT DISTINCT um.I_User_ID,
							um.S_Login_ID,
							um.S_First_Name,
							um.S_Middle_Name,
							um.S_Last_Name,
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
		AND hmd.S_Hierarchy_Chain LIKE (select S_Hierarchy_Chain FROM T_Hierarchy_Mapping_Details WHERE I_Hierarchy_Detail_ID=@iSelectedHierarchyId and I_Status = 1 )+@sCriteron
		AND um.S_Login_ID LIKE ISNULL(@vLoginID,um.S_Login_ID)+'%'
		AND um.S_First_Name LIKE ISNULL(@vFirstName,'')+'%'
		AND ISNULL(um.S_Middle_Name,'') LIKE ISNULL(@vMiddleName,'')+'%'
		AND ISNULL(um.S_Last_Name,'') LIKE ISNULL(@vLastName,'')+'%'
	END
END
