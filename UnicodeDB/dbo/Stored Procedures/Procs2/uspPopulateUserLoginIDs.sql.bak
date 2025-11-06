CREATE PROCEDURE [dbo].[uspPopulateUserLoginIDs] 
	@flagCompany int
AS
BEGIN TRY

	SET NOCOUNT ON;
	If @flagCompany =0
		Begin
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
			   D.Dt_Upd_On  
			  FROM dbo.T_User_Hierarchy_Details A,  
				dbo.T_Hierarchy_Master B,   
				   dbo.T_Hierarchy_Details C,   
				dbo.T_User_Master D  
			  WHERE D.S_User_Type = 'TE'   
			  AND D.I_STATUS <> 0   
			  AND A.I_STATUS <> 0  
			  AND B.I_STATUS <> 0  
			  AND C.I_STATUS <> 0
			  AND D.I_User_ID = A.I_User_ID  
			  AND A.I_Hierarchy_Master_ID = B.I_Hierarchy_Master_ID  
			  AND B.S_Hierarchy_Type = 'RH'  
			  AND A.I_Hierarchy_Detail_ID = C.I_Hierarchy_Detail_ID  
			  ORDER BY D.S_Login_ID
		End
	Else
		Begin
			select	I_User_ID,
					S_Login_ID,
					S_User_Type	
			from dbo.T_User_Master 
			where (S_User_Type = 'EMP' OR S_User_Type = 'TE')
			and I_STATUS <> 0
			order by  S_Login_ID 
		End

	
	SELECT	A.I_Hierarchy_Detail_ID, 
			A.I_Hierarchy_Master_ID, 
			A.S_Hierarchy_Name
	FROM dbo.T_Hierarchy_Details A, dbo.T_Hierarchy_Master B
	WHERE A.I_Status = 1
	AND A.I_Hierarchy_Master_ID = B.I_Hierarchy_Master_ID
	AND B.S_Hierarchy_Type = 'RH'
	    
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
