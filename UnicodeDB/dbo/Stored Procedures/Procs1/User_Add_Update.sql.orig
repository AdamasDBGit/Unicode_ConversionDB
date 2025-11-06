
CREATE PROCEDURE [dbo].[User_Add_Update] ---SP_NAME----

-- =============================================
-- -----Author: Tridip Chatterjee
-- Create date: 12-09-2023
-- Description:	User_Insertion_Updation
-- =============================================
-- =============================================
----- SP Parameters------------Default value null------------
-- =============================================
@User_ID int=null,
@Username varchar(255)=null,
@Password varchar(255)=null,
@Email varchar(255)=null,
@First_Name varchar(255)=null,
@Middle_Name varchar(255)=null,
@Last_Name varchar(255)=null,
@Mobile varchar(255)=null,
@Created_By int =Null,
@Status int=null


AS
BEGIN
BEGIN TRY
SET NOCOUNT ON;

-- =============================================
----- SP Parameters----------- value Checking for update------------
-- =============================================

      If @Created_By is null
      set @Created_By=(select I_Created_By from  T_ERP_User  where I_User_ID=@User_ID)

      If @Status is null
      set @Status=(select I_Status from  T_ERP_User  where I_User_ID=@User_ID)

      If @Username is null
      set @Username= (select S_Username from  T_ERP_User  where I_User_ID=@User_ID)

      If @Password is null
      set @Password= (select S_Password from  T_ERP_User  where I_User_ID=@User_ID)

      If @Email is null
      set @Email= (select S_Email from  T_ERP_User  where I_User_ID=@User_ID)

      If @First_Name is null
      set @First_Name= (select S_First_Name from  T_ERP_User  where I_User_ID=@User_ID)

      If @Last_Name is null
      set @Last_Name= (select S_Last_Name from  T_ERP_User  where I_User_ID=@User_ID)

      If @Mobile is null
      set @Mobile= (select S_Mobile from  T_ERP_User  where I_User_ID=@User_ID)



    
-- =============================================
     ---USER CHECKING----
-- =============================================
   
	
	IF @@ROWCOUNT = 0

       If (@User_ID is null)
	   BEGIN
	   -- =============================================
     ---INSERT USER----
-- =============================================
        
		
		INSERT INTO T_ERP_User
		( 
		  S_Username, 
		  S_Password, 
		  S_Email,
	      S_First_Name,
		  S_Middle_Name,
		  S_Last_Name,
	      S_Mobile, 
		  Dt_CreatedAt, 
		  I_Created_By,
	      Dt_Last_Login, 
		  I_Status
         )
        
		VALUES
		( 
		  @Username, 
		  @Password, 
		  @Email,
	      @First_Name,
		  @Middle_Name,
		  @Last_Name,
	      @Mobile, 
		  SYSDATETIME(), 
		  @Created_By,
	      SYSDATETIME(), 
		  1
        )

      IF @User_ID IS NULL
      --PRINT 'User Created  Successfully';
	  select 1 StatusFlag,'User Created  Successfully' Message
	   END
	   ELSE
	   BEGIN
	   -- =============================================
     ---USER UPDATE----
-- =============================================



    UPDATE T_ERP_User SET S_Username = @Username, S_Password = @Password, S_Email=@Email,
	S_First_Name=@First_Name,S_Middle_Name=@Middle_Name,S_Last_Name=@Last_Name,
	S_Mobile=@Mobile,  I_Created_By=@Created_By,
	I_Status=@Status

    WHERE I_User_ID = @User_ID
	IF @@ROWCOUNT != 0
	--PRINT 'User Updated Successfully';
	select 1 StatusFlag,'User Updated Successfully' Message
	   END
	  
    


     

END TRY

BEGIN CATCH
  
	throw 50001,'User Creation  Unsuccessfully',1;
        
END CATCH;
END
