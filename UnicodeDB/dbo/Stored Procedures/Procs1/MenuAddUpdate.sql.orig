CREATE PROCEDURE [dbo].[MenuAddUpdate] 
-- =============================================
     -- Author:	Tridip Chatterjee
-- Create date: 20-09-2023
-- Description:	Menu Add or Update
-- =============================================
-- Add the parameters for the stored procedure here
	
@MenuID int =null,
@MenuCode nvarchar(255)=null,
@MenuName varchar(255)=null,
@ParentMenuID int =null,
@LeafNode int =null,
@Icon nvarchar(255)=null,
@Url  nvarchar(255)=null,
@CreatedBy int=null,
@Status int =null

AS
BEGIN
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	   IF @MenuID is not null
	   BEGIN
		   IF @MenuCode is null
			set @MenuCode=(select S_Code from T_Erp_Menu where I_Menu_ID=@MenuID)
		   IF @MenuName is null
			set @MenuName=(select S_Name from T_Erp_Menu where I_Menu_ID=@MenuID)
		   IF @ParentMenuID is null
			set @ParentMenuID=(select I_Parent_Menu_ID from T_Erp_Menu where I_Menu_ID=@MenuID)
		   IF @LeafNode is null
			set @LeafNode=(select I_Is_Leaf_Node from T_Erp_Menu where I_Menu_ID=@MenuID)
		   IF @Icon is null
			set @Icon=(select S_Icon from T_Erp_Menu where I_Menu_ID=@MenuID)
		   IF @Url is null
			set @Url=(select S_Url from T_Erp_Menu where I_Menu_ID=@MenuID)
		   IF @CreatedBy is null
			set @CreatedBy=(select I_CreatedBy from T_Erp_Menu where I_Menu_ID=@MenuID)
		   --IF @CreatedOn is null
		   --set @CreatedOn=(select Dt_CreatedAt from T_Erp_Menu where I_Menu_ID=@MenuID)
		   IF @Status is null
			set @Status=(select I_Status from T_Erp_Menu where I_Menu_ID=@MenuID)
	   
	-- =============================================
              ---MENU UPDATE----
    -- =============================================
			IF EXISTS(select S_Code from T_ERP_Menu where S_Code=@MenuCode and I_Menu_ID != @MenuID)
			BEGIN
				SELECT 0 StatusFlag,'Duplicate Menu Code' Message
			END
			ELSE IF EXISTS(select S_Name from T_ERP_Menu where S_Name = @MenuName and I_Menu_ID != @MenuID)
			BEGIN
				SELECT 0 StatusFlag,'Duplicate Menu Name' Message
			END
			ELSE
			BEGIN
			   Update T_Erp_Menu set S_Code=@MenuCode, 
									 S_Name=@MenuName,
									 I_Parent_Menu_ID=@ParentMenuID,
									 I_Is_Leaf_Node=@LeafNode,
									 S_Icon=@Icon,
									 S_Url=@Url,
									 I_CreatedBy=@CreatedBy,
									 Dt_CreatedAt=GETDATE(),
									 I_Status=@Status

			   Where I_Menu_ID=@MenuID 
	   
			   IF @@ROWCOUNT != 0    
			   select 1 StatusFlag,'Menu Updated Successfully' Message  
		   END
		END

 --    =============================================
              ---MENU CHECKING----
 --    =============================================
   
         
       IF @@ROWCOUNT = 0  
  
       If @MenuID is null  

	-- =============================================
                ---INSERT MENU----
    -- =============================================
		IF EXISTS(select S_Code from T_ERP_Menu where S_Code=@MenuCode)
		BEGIN
			SELECT 0 StatusFlag,'Duplicate Menu Code' Message
		END
		ELSE IF EXISTS(select S_Name from T_ERP_Menu where S_Name = @MenuName)
		BEGIN
			SELECT 0 StatusFlag,'Duplicate Menu Name' Message
		END
		ELSE
		BEGIN
			insert into T_ERP_Menu
								 (
								  S_Code,
								  S_Name,
								  I_Parent_Menu_ID,
								  I_Is_Leaf_Node,
								  S_Icon,
								  S_Url,
								  I_CreatedBy,
								  Dt_CreatedAt,
								  I_Status
								 )      
			Values  
								 (
								   @MenuCode,
								   @MenuName,
								   @ParentMenuID,
								   @LeafNode,
								   @Icon,
								   @Url,
								   @CreatedBy,
								   GETDATE(),
								   @Status
								 )
		   IF @MenuID IS NULL
		   select 1 StatusFlag,'Menu Created  Successfully' Message  
      END

END TRY
BEGIN CATCH  
    
 throw 50001,'Menu Creation  Unsuccessfully',1;  
          
END CATCH; 

END
