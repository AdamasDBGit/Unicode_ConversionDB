CREATE PROCEDURE [dbo].[uspGetAllUsers] 
	@iFlagCompany int,
	@sLoginID varchar(200),
	@sFirstName varchar(100),
	@sMiddleName varchar(100),
	@sLastName varchar(100)
AS
BEGIN

	SET NOCOUNT ON;
		
	IF @iFlagCompany = 0
	BEGIN
		SELECT DISTINCT D.S_Login_ID, 
			A.I_Hierarchy_Detail_ID, 
			C.S_Hierarchy_Name,
			D.I_User_ID,
			D.S_Title,
			D.S_First_Name,
			D.S_Middle_Name,
			D.S_Last_Name,
			D.S_Email_ID,
			D.S_User_Type,
			D.I_Status,
			D.S_Forget_Pwd_Qtn,
			D.S_Forget_Pwd_Answer,
			D.S_Crtd_By,
			D.S_Upd_By,
			D.Dt_Crtd_On,
			D.Dt_Upd_On,
			D.Dt_Date_Of_Birth,
			ISNULL(D.B_LDAP_User,'FALSE') AS B_LDAP_User
		FROM dbo.T_User_Hierarchy_Details A,
			 dbo.T_Hierarchy_Master B, 
		     dbo.T_Hierarchy_Details C, 
			 dbo.T_User_Master D
		WHERE D.S_User_Type <> 'EMP' 
		AND D.I_STATUS <> 0 
		AND A.I_STATUS <> 0
		AND B.I_STATUS <> 0
		AND C.I_STATUS <> 0
		AND D.S_Login_ID LIKE @sLoginID
		AND ISNULL(D.S_First_Name,'%') LIKE @sFirstName 
		AND ISNULL(D.S_Middle_Name,'%') LIKE @sMiddleName 
		AND ISNULL(D.S_Last_Name,'%') LIKE @sLastName
		AND D.I_User_ID = A.I_User_ID
		AND A.I_Hierarchy_Master_ID = B.I_Hierarchy_Master_ID
		AND B.S_Hierarchy_Type = 'RH'
		AND A.I_Hierarchy_Detail_ID = C.I_Hierarchy_Detail_ID
		ORDER BY D.S_Login_ID
	END
	ELSE IF @iFlagCompany = -1
	 BEGIN
	  SELECT DISTINCT D.S_Login_ID,   
	   --A.I_Hierarchy_Detail_ID,   
	   --C.S_Hierarchy_Name,  
	   D.I_User_ID,  
	   D.S_Title,  
	   D.S_First_Name,  
	   D.S_Middle_Name,  
	   D.S_Last_Name,  
	   D.S_Email_ID,  
	   D.S_User_Type,  
	   D.I_Status,  
	   D.S_Forget_Pwd_Qtn,  
	   D.S_Forget_Pwd_Answer,  
	   D.S_Crtd_By,  
	   D.S_Upd_By,  
	   D.Dt_Crtd_On,  
	   D.Dt_Upd_On,
	   D.Dt_Date_Of_Birth,
	   ISNULL(D.B_LDAP_User,'FALSE') AS B_LDAP_User
	  FROM --dbo.T_User_Hierarchy_Details A,  
		--dbo.T_Hierarchy_Master B,   
		   --dbo.T_Hierarchy_Details C,   
		dbo.T_User_Master D  
	  WHERE (D.S_User_Type = 'EMP' OR D.S_User_Type = 'TE')   
	  AND D.I_STATUS <> 0   
	  --AND A.I_STATUS <> 0  
	  --AND B.I_STATUS <> 0  
	  --AND C.I_STATUS <> 0  
	  AND D.S_Login_ID LIKE @sLoginID  
	  AND ISNULL(D.S_First_Name,'%') LIKE @sFirstName   
	  AND ISNULL(D.S_Middle_Name,'%') LIKE @sMiddleName   
	  AND ISNULL(D.S_Last_Name,'%') LIKE @sLastName  
	  --AND D.I_User_ID = A.I_User_ID  
	  --AND A.I_Hierarchy_Master_ID = B.I_Hierarchy_Master_ID  
	 -- AND B.S_Hierarchy_Type = 'RH'  
	  --AND A.I_Hierarchy_Detail_ID = C.I_Hierarchy_Detail_ID  
	  ORDER BY D.S_Login_ID  
	 END 
	ELSE
	BEGIN	
		SELECT DISTINCT D.S_Login_ID,
			D.I_User_ID, 
			A.I_Hierarchy_Detail_ID, 
			C.S_Hierarchy_Name,			
			D.S_Title,
			D.S_First_Name,
			D.S_Middle_Name,
			D.S_Last_Name,
			D.S_Email_ID,
			D.S_User_Type,
			D.I_Status,
			D.S_Forget_Pwd_Qtn,
			D.S_Forget_Pwd_Answer,
			D.S_Crtd_By,
			D.S_Upd_By,
			D.Dt_Crtd_On,
			D.Dt_Upd_On,
			D.Dt_Date_Of_Birth,
			ISNULL(D.B_LDAP_User,'FALSE') AS B_LDAP_User
		FROM dbo.T_User_Hierarchy_Details A,
			 dbo.T_Hierarchy_Master B, 
		     dbo.T_Hierarchy_Details C, 
			 dbo.T_User_Master D
		WHERE D.S_User_Type = 'EMP' 
		AND D.I_STATUS <> 0 
		AND A.I_STATUS <> 0
		AND B.I_STATUS <> 0
		AND C.I_STATUS <> 0 
		AND D.S_Login_ID LIKE @sLoginID
		AND ISNULL(D.S_First_Name,'%') LIKE @sFirstName 
		AND ISNULL(D.S_Middle_Name,'%') LIKE @sMiddleName
		AND ISNULL(D.S_Last_Name,'%') LIKE @sLastName
		AND D.I_User_ID = A.I_User_ID
		AND A.I_Hierarchy_Master_ID = B.I_Hierarchy_Master_ID
		AND B.S_Hierarchy_Type = 'RH'
		AND A.I_Hierarchy_Detail_ID = C.I_Hierarchy_Detail_ID
		ORDER BY D.S_Login_ID
	END
 
END
