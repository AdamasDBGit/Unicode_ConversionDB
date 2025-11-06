      
CREATE PROCEDURE [dbo].[uspGet_ERP_UserLoginInformationAdminForExternal]      
    (      
      @EmailID NVARCHAR(MAX)       
    )      
AS      
    BEGIN      
 -- SET NOCOUNT ON added to prevent extra result sets from      
 -- interfering with SELECT statements.      
        SET NOCOUNT ON;      
       
        --DECLARE @vUserType int      
        --DECLARE @vPasswordTemp NVARCHAR(200)      
        --DECLARE @iUserID INT      
        --DECLARE @bLDAPUser BIT      
      
        --SELECT  @iUserID = I_User_ID ,      
        --        @vPasswordTemp = S_Password ,      
        --        @vUserType = I_User_Type       
        --        --@bLDAPUser = ISNULL(B_LDAP_User, 'FALSE')      
        --FROM    dbo.T_ERP_User      
        --WHERE   S_Username = @vLoginID      
        --        AND I_Status = 1      
      
       
                SELECT  TOP 1 '' AS Title ,      
                        S_Username AS LoginID ,      
                        UM.S_First_Name AS FirstName ,      
                        ISNULL(UM.S_Middle_Name,'') AS MiddleName ,      
                        UM.S_Last_Name AS LastName ,      
                        UM.S_Email AS EmailID ,      
                        UM.I_User_Type AS UserType ,      
                        --UM.S_Forget_Pwd_Qtn AS ForgetPwdQs ,      
                        --UM.S_Forget_Pwd_Answer AS ForgetPwdAns ,      
                        UM.I_User_ID AS UserID       
      ,BM.I_Brand_ID as BrandID      
      ,BM.S_Brand_Name as BrandName,      
      ISNULL(UM.IsAllAllowedEligible,'false') as IsAllAllowedEligible,      
      BM.S_Brand_Code as BrandCode  
	  ,isnull(UM.Is_Teaching_Staff,0) as D_User_Type
                FROM    dbo.T_ERP_User as UM      
      inner join      
      dbo.T_ERP_User_Brand as UB on UB.I_User_ID=UM.I_User_ID      
      Inner join T_Brand_Master as BM on BM.I_Brand_ID=UB.I_Brand_ID       
                WHERE   UM.S_Email = @EmailID  
      AND UM.I_Status=1      
      
                  
      
    END

