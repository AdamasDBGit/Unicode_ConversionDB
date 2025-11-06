CREATE PROCEDURE [dbo].[Role_Add_Update]
-- =============================================
------- Author:  Tridip Chatterjee		
-- Create date:  13-09-2023
-- Description:	 Modify Arrivo Role
-- =============================================
-- Add the parameters for the stored procedure here
-- =============================================
@Role_ID int =null,
@Role_Name nvarchar(255)=null,
@Role_Desc nvarchar(255)=null,
@CreatedBy int =null,
@Status int=null

AS
BEGIN
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	   SET NOCOUNT ON;
	   IF @Role_ID is not Null
	   IF @Role_Name is null
	   Set @Role_Name=(Select S_Role_Name from T_ERP_Role where I_Role_ID=@Role_ID )
	   IF @Role_Desc is null
	   Set @Role_Desc=(Select S_Description from T_ERP_Role where I_Role_ID=@Role_ID )
	   IF @CreatedBy is null
	   Set @CreatedBy=(Select Dt_CreatedBy from T_ERP_Role where I_Role_ID=@Role_ID )
	   IF @Status is null
	   Set @Status=(Select I_Status from T_ERP_Role where I_Role_ID=@Role_ID )

   
    -- =============================================
              ---ROLE CHECKING----
    -- =============================================
   
	
	   IF @@ROWCOUNT = 0
    -- =============================================
                ---INSERT ROLE----
    -- =============================================
        If (@Role_ID is null)
		BEGIN
		INSERT INTO T_ERP_Role
		( 
		  S_Role_Name,
		  S_Description,
		  Dt_CreatedBy,
		  Dt_CreatedAt,
		  I_Status
         )
        
		VALUES
		( 
		  @Role_Name,
		  @Role_Desc,
		  @CreatedBy,
		  SYSDATETIME(), 
		  1
        )
		 select 1 StatusFlag,'Role Created Successfully' Message
		END
		ELSE
		BEGIN
		 -- =============================================
              ---ROLE UPDATE----
    -- =============================================

      UPDATE T_ERP_Role 
	  SET S_Role_Name = @Role_Name,
	      S_Description=@Role_Desc,
		  Dt_CreatedBy=@CreatedBy,
	      I_Status=@Status

      WHERE I_Role_ID=@Role_ID
  select 1 StatusFlag,'Role Updated Successfully' Message
		END
		
		

    --IF @Role_ID IS NULL
    --   SELECT SCOPE_IDENTITY() AS NEW_ROLE_ID
	   --select 1 StatusFlag,'Role Created Successfully' Message

END TRY

BEGIN CATCH
  SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
END
