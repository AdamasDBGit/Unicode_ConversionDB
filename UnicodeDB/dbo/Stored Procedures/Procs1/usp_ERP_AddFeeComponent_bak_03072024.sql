-- =============================================        
-- Author:  <Parichoy Nandi>        
-- Create date: <10th Nov 2023>        
-- Description: <to add or update the class>        
-- =============================================        
CREATE PROCEDURE [dbo].[usp_ERP_AddFeeComponent_bak_03072024]         
 -- Add the parameters for the stored procedure here        
   @FeeHeadID int Null,        
  @FeeComponentCode NVARCHAR(MAX),        
  @FeeComponentName NVARCHAR(MAX),        
  @Status int,        
  @UpdatedBy NVARCHAR(MAX),        
  @FeeComponentType int,        
  @BrandID int ,        
  @TypeOfComponent NVARCHAR(MAX),      
  @Is_GST_Applicable bit null,      
  @I_GST_FeeComponent_Catagory_ID int null,      
  @Valid_from datetime null,      
  @Valid_to datetime null      
AS        
begin transaction        
BEGIN TRY         
BEGIN        
 -- SET NOCOUNT ON added to prevent extra result sets from        
 -- interfering with SELECT statements.        
 SET NOCOUNT ON;       
      
 DECLARE @FeeCompID INT; -- for storing the feeId       
        
 IF(@FeeHeadID>0)        
 --Begin        
 --if exists (select * from [dbo].[T_Fee_Component_Master]     
 --where S_Component_Name = @FeeComponentName or     
 --S_Component_Code = @FeeComponentCode and I_Brand_ID=@BrandID)        
 --Begin        
 --SELECT 0 StatusFlag,'Duplicate Fee Component Name or Code' Message        
 --END        
 --ELSE        
  Begin        
  update [dbo].[T_Fee_Component_Master]         
  SET         
  [S_Component_Code]= @FeeComponentCode,        
  [S_Component_Name] = @FeeComponentName,        
  [I_Status] = @Status,        
  [S_Upd_By] = @UpdatedBy,        
  [Dt_Upd_On] = GETDATE(),        
    [I_Fee_Component_Type_ID] = @FeeComponentType,        
    [I_Brand_ID] = @BrandID,        
    [S_Type_Of_Component] =@TypeOfComponent,      
  [Is_GST_Applicable] = @Is_GST_Applicable      
         
  where [I_Fee_Component_ID] = @FeeHeadID         
     
  IF @Is_GST_Applicable = 0      
  Begin      
    update T_ERP_GST_Item_Category      
    set I_Fee_Component_ID = NULL      
    where I_GST_FeeComponent_Catagory_ID = @I_GST_FeeComponent_Catagory_ID     
   
    update T_Tax_Country_Fee_Component   
    set I_Status = 0  
    where I_Fee_Component_ID = @FeeHeadID  
    and I_Tax_ID in (select I_Tax_ID from T_Tax_Master where S_Tax_Code in ('CGST', 'SGST', 'IGST') )  
  end      
  else       
  Begin      
   update T_ERP_GST_Item_Category      
   set I_Fee_Component_ID = @FeeHeadID      
   where I_GST_FeeComponent_Catagory_ID = @I_GST_FeeComponent_Catagory_ID      
  end      
         
  SELECT 1 StatusFlag,'Fee Component updated' Message        
  END        
         
 --END        
 ELSE ---------Insert Block Start        
 BEGIN        
  if exists (select * from [dbo].[T_Fee_Component_Master]     
  where S_Component_Name = @FeeComponentName or     
  S_Component_Code = @FeeComponentCode and I_Brand_ID=@BrandID)        
    
  BEGIN        
    
  SELECT 0 StatusFlag,'Duplicate Fee Component Name' Message        
   
  END        
  ELSE        
  BEGIN        
   INSERT INTO [dbo].[T_Fee_Component_Master]        
  (        
     [S_Component_Code],        
     [S_Component_Name],        
     [I_Status],        
     [S_Crtd_By],        
     [Dt_Crtd_On],        
     [I_Fee_Component_Type_ID],        
     [I_Brand_ID],        
     [S_Type_Of_Component],        
     [Is_GST_Applicable]      
  )        
  VALUES        
  (        
    @FeeComponentCode,        
    @FeeComponentName,        
    @Status,        
    @UpdatedBy,        
    GETDATE(),        
    @FeeComponentType,        
    @BrandID,        
    @TypeOfComponent,      
    @Is_GST_Applicable      
  )       
  SET @FeeCompID = SCOPE_IDENTITY();      
      
  IF @Is_GST_Applicable = 1 AND @I_GST_FeeComponent_Catagory_ID IS NOT NULL      
   BEGIN      
     UPDATE T_ERP_GST_Item_Category      
     SET I_Fee_Component_ID = @FeeCompID      
     WHERE I_GST_FeeComponent_Catagory_ID = @I_GST_FeeComponent_Catagory_ID      
      
     IF @Valid_from IS NOT NULL AND @Valid_to IS NOT NULL      
     BEGIN      
      Insert into T_Tax_Country_Fee_Component      
      (I_Tax_ID, I_Country_ID, I_Fee_Component_ID, N_Tax_Rate, Dt_Valid_From, Dt_Valid_To, I_Status, S_Crtd_By, Dt_Crtd_On)      
      
      select I_Tax_ID,      
       1,      
       @FeeCompID,      
       0,      
       @Valid_from,      
       @Valid_to,      
       1,      
       1,      
       GETDATE()  from T_Tax_Master where S_Tax_Code in ('CGST', 'SGST', 'IGST')      
    END      
  END      
      
       
        
  SELECT 1 StatusFlag,'Fee Component added' Message        
  END        
         
 END        
         
       
END        
END TRY        
BEGIN CATCH        
 rollback transaction        
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int        
        
 SELECT @ErrMsg = ERROR_MESSAGE(),        
   @ErrSeverity = ERROR_SEVERITY()        
select 0 StatusFlag,@ErrMsg Message        
END CATCH        
commit transaction        
