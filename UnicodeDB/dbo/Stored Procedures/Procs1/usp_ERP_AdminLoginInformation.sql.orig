CREATE PROCEDURE [dbo].[usp_ERP_AdminLoginInformation]
    (
      @vLoginID VARCHAR(200) ,
      @vPassword NVARCHAR(200)
    )
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
	
        DECLARE @vUserType VARCHAR(20)
        DECLARE @vPasswordTemp NVARCHAR(200)
       

      

	
                SELECT TOP 1 S_Title AS Title ,
                        @vLoginID AS LoginID ,
                        UM.S_First_Name AS FirstName ,
                        ISNULL(UM.S_Middle_Name,'') AS MiddleName ,
                        UM.S_Last_Name AS LastName ,
                        UM.S_Email_ID AS EmailID ,
                        UM.S_User_Type AS UserType ,
                        UM.S_Forget_Pwd_Qtn AS ForgetPwdQs ,
                        UM.S_Forget_Pwd_Answer AS ForgetPwdAns ,
                        UM.I_User_ID AS UserID ,
                        ISNULL(B_LDAP_User, 'FALSE') AS IsLDAPUser
						,HBD.I_Brand_ID as BrandID
                FROM    dbo.T_User_Master as UM
						inner join
						T_User_Hierarchy_Details as UHD on UM.I_User_ID=UHD.I_User_ID -- susmita
						inner join
						T_Hierarchy_Brand_Details as HBD on HBD.I_Hierarchy_Master_ID=UHD.I_Hierarchy_Master_ID -- susmita
                WHERE   UM.S_Login_ID = @vLoginID
                        AND UM.S_Password = @vPassword
                        AND UM.I_Status = 1
						AND UHD.I_Status=1 --susmita
						AND HBD.I_Status=1 -- susmita
						AND HBD.I_Brand_ID in (107,110) --susmita 
          END
