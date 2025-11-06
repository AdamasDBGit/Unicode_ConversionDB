CREATE PROCEDURE [dbo].[Usp_ERP_User_Group_Insert_Update]    
    @User_Group_Master_ID INT = NULL,    
    @User_GroupName NVARCHAR(max),    
    @Code NVARCHAR(max),    
    @BrandID int,    
    @Is_Active bit,  
    @CreatedBy  int
    --,@UT_Roles [UT_Roles] READONLY  
    
AS    
BEGIN    
SET NOCOUNT ON;  
    --BEGIN TRY    
    --    BEGIN TRANSACTION;    
    
        -- Insert or Update HeaderTable    
        --IF @User_Group_Master_ID IS NULL    
        --BEGIN    
  IF EXISTS (SELECT 1 FROM T_ERP_User_Group_Master     
  WHERE S_User_GroupName = @User_GroupName AND S_Code = @Code and I_Brand_ID=@BrandID)    
    BEGIN    
  
     Select 'Duplicate name and code combination.' as Message   
  --RAISEERROR('Duplicate record found for the given name and code.', 16, 1);  
        RETURN; -- Exit the stored procedure    
    END    
     BEGIN TRY    
        BEGIN TRANSACTION;    
         IF @User_Group_Master_ID IS NULL    
        BEGIN    
            -- Insert new record    
            INSERT INTO T_ERP_User_Group_Master     
            (    
            S_User_GroupName    
           ,S_Code    
           ,Is_Active    
           ,I_Brand_ID    
            )    
   Values    
   (    
   @User_GroupName,    
   @Code,    
   1,    
   @BrandID    
     
   )    
   --SET @User_Group_Master_ID=SCOPE_IDENTITY()  
        END    
        ELSE    
        BEGIN    
  --IF EXISTS (SELECT 1 FROM T_ERP_User_Group_Master     
  --WHERE S_User_GroupName = @User_GroupName   
  --AND S_Code = @Code and I_Brand_ID=@BrandID)    
  --  BEGIN    
  --      -- If the name and code combination already exists, raise an error    
  --       Select 'Duplicate name and code combination.'    
  --      RETURN;   
  --  END    
            -- Update existing record    
            UPDATE T_ERP_User_Group_Master    
            SET S_User_GroupName = @User_GroupName ,S_Code = @Code    
            WHERE I_User_Group_Master_ID = @User_Group_Master_ID;    
        END    
  ------------------------------------------------------------  
  --MERGE INTO T_ERP_UserGroup_Role_Brand_Map AS target    
  --      Using @UT_Roles AS Source    
  --      ON target.I_User_Group_Master_ID = @User_Group_Master_ID  
  --        And target.I_Role_ID = Source.I_Role_ID  and target.I_Brand_ID=@BrandID  
  --      WHEN MATCHED THEN    
  --          UPDATE SET Is_Active = Source.[Is_Active]   
                       
  --      WHEN NOT MATCHED THEN    
  --          INSERT    
  --          (    
  --             I_User_Group_Master_ID  
  --            ,I_Role_ID  
  --            ,I_Brand_ID  
  --            ,Is_Active  
  --            ,Dt_created_Dt  
  --            ,I_Created_By  
  --          )    
  --          Values    
  --          (@User_Group_Master_ID    
  --         , Source.I_Role_ID    
  --         , @brandid    
  --         , Source.[Is_Active]    
  --         , Getdate()   
  --         , @CreatedBy    
  --          )    
  --      WHEN NOT MATCHED BY SOURCE     
  --and target.I_User_Group_Master_ID=@User_Group_Master_ID    
  --THEN    
  --          Update SET Is_Active = 0  ;  
                     
    
        select 1                       StatusFlag    
             , 'User Group Created' Message    
    
    
        COMMIT;    
    END TRY    
    BEGIN CATCH    
        IF @@TRANCOUNT > 0    
            ROLLBACK;    
DECLARE @ErrorMessage NVARCHAR(max);  
        SET @ErrorMessage = ERROR_MESSAGE();  
        -- Log the error message or handle it as needed  
  
        -- Raise an error to indicate the failure  
        Select @ErrorMessage as Message  
    END CATCH    
End


