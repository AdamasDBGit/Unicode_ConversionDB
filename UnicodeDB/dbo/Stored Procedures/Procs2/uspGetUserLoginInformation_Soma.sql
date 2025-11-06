CREATE PROCEDURE [dbo].[uspGetUserLoginInformation_Soma]
    (
      @vLoginID Nnvarchar(max) ,
      @vPassword Nnvarchar(max)
    )
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
	
        DECLARE @vUserType nvarchar(max)
        DECLARE @vPasswordTemp Nnvarchar(max)
        DECLARE @iUserID INT
        DECLARE @bLDAPUser BIT

        SELECT  @iUserID = I_User_ID ,
                @vPasswordTemp = S_Password ,
                @vUserType = S_User_Type ,
                @bLDAPUser = ISNULL(B_LDAP_User, 'FALSE')
        FROM    dbo.T_User_Master
        WHERE   S_Login_ID = @vLoginID
                AND I_Status = 1

	-- For Non-Company User
        IF @bLDAPUser = 'TRUE'
            BEGIN
                SELECT  S_Title AS Title ,
                        @vLoginID AS LoginID ,
                        S_First_Name AS FirstName ,
                        ISNULL(S_Middle_Name,'') AS MiddleName ,
                        S_Last_Name AS LastName ,
                        S_Email_ID AS EmailID ,
                        S_User_Type AS UserType ,
                        S_Forget_Pwd_Qtn AS ForgetPwdQs ,
                        S_Forget_Pwd_Answer AS ForgetPwdAns ,
                        I_User_ID AS UserID ,
                        ISNULL(B_LDAP_User, 'FALSE') AS IsLDAPUser
                FROM    dbo.T_User_Master
                WHERE   S_Login_ID = @vLoginID
                        AND I_Status = 1
            END
	-- For Company Employee User
        ELSE
            BEGIN
                SELECT  S_Title AS Title ,
                        @vLoginID AS LoginID ,
                        S_First_Name AS FirstName ,
                        ISNULL(S_Middle_Name,'') AS MiddleName ,
                        S_Last_Name AS LastName ,
                        S_Email_ID AS EmailID ,
                        S_User_Type AS UserType ,
                        S_Forget_Pwd_Qtn AS ForgetPwdQs ,
                        S_Forget_Pwd_Answer AS ForgetPwdAns ,
                        I_User_ID AS UserID ,
                        ISNULL(B_LDAP_User, 'FALSE') AS IsLDAPUser
                FROM    dbo.T_User_Master
                WHERE   S_Login_ID = @vLoginID
                        AND S_Password = @vPassword
                        AND I_Status = 1
            END

    END

