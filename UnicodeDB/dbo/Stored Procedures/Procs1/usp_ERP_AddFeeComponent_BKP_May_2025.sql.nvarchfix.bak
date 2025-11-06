
            
CREATE PROCEDURE [dbo].[usp_ERP_AddFeeComponent_BKP_May_2025]             
 -- Add the parameters for the stored procedure here            
   @FeeHeadID int Null,            
  @FeeComponentCode Nnvarchar(max),            
  @FeeComponentName Nnvarchar(max),            
  @Status int,            
  @UpdatedBy Nnvarchar(max),            
  @FeeComponentType int,            
  @BrandID int ,            
  @TypeOfComponent Nnvarchar(max),          
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
 Declare @DefaultGSTCATID int
SET @DefaultGSTCATID=
(
select Distinct TOP 1 GIC.I_GST_FeeComponent_Catagory_ID  
from T_ERP_GST_Configuration_Details GCD
Inner Join T_ERP_GST_Item_Category GIC 
ON GCD.I_GST_FeeComponent_Catagory_ID=GIC.I_GST_FeeComponent_Catagory_ID
where N_SGST=0.00 and N_CGST=0.00 and N_IGST=0.00 and GIC.Is_Active=1

order by GIC.I_GST_FeeComponent_Catagory_ID
)
          
 DECLARE @FeeCompID INT; -- for storing the feeId           
            
 IF(@FeeHeadID>0)            
          
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
    
  update  T_ERP_GST_Component_Mapping set I_GST_FeeComponent_Catagory_ID=@DefaultGSTCATID
  ,dt_modify=getdate()
  where I_Fee_Component_ID=@FeeHeadID  
  and I_GST_Component_Type=1  
  update T_Fee_Component_Master set Is_GST_Applicable=0   
  where I_Fee_Component_ID=@FeeHeadID    
  
  end      
  Else  
  Begin  
    update  T_ERP_GST_Component_Mapping set Is_Active=1,dt_modify=getdate()  
 ,I_GST_FeeComponent_Catagory_ID=@I_GST_FeeComponent_Catagory_ID  
 where I_Fee_Component_ID=@FeeHeadID and I_GST_Component_Type=1  
  
  End  
             
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
     Is_GST_Applicable  
          
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
    
  print @Is_GST_Applicable  
  SET @FeeCompID = SCOPE_IDENTITY();    
    
          
  IF @Is_GST_Applicable = 1 AND @I_GST_FeeComponent_Catagory_ID IS NOT NULL          
   Begin          
Insert into T_ERP_GST_Component_Mapping(  
  
I_GST_FeeComponent_Catagory_ID  
,I_Fee_Component_ID  
,Is_Active  
,dt_create  
,I_GST_Component_Type  
)  
Select @I_GST_FeeComponent_Catagory_ID,@FeeCompID,1,GETDATE(),1 where NOT Exists(  
Select 1 from T_ERP_GST_Component_Mapping cm where   
cm.I_GST_FeeComponent_Catagory_ID=@I_GST_FeeComponent_Catagory_ID  
and cm.I_Fee_Component_ID=@FeeCompID and cm.Is_Active=1 and cm.I_GST_Component_Type=1  
)  
          
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
  Else    
  Begin    
  --EXEC Usp_ERP_DefaultGSTMAP_Comp @FeeCompID,@BrandID,1   
  ----If GST NOT applicable-----

Insert into T_ERP_GST_Component_Mapping(  
  
I_GST_FeeComponent_Catagory_ID  
,I_Fee_Component_ID  
,Is_Active  
,dt_create  
,I_GST_Component_Type  
) 
Select @DefaultGSTCATID,@FeeCompID,1,getdate(),1 where NOT Exists(
Select 1 from T_ERP_GST_Component_Mapping cm where   
cm.I_GST_FeeComponent_Catagory_ID=@DefaultGSTCATID  
and cm.I_Fee_Component_ID=@FeeCompID and cm.Is_Active=1 and cm.I_GST_Component_Type=1 
)
  update T_Fee_Component_Master set Is_GST_Applicable=0 
  where I_Fee_Component_ID=@FeeCompID  
  End     
          
           
            
  SELECT 1 StatusFlag,'Fee Component added' Message            
  END            
             
 END            
             
           
END    
commit transaction   
END TRY     
  
BEGIN CATCH            
 rollback transaction            
 DECLARE @ErrMsg Nnvarchar(max), @ErrSeverity int            
            
 SELECT @ErrMsg = ERROR_MESSAGE(),            
   @ErrSeverity = ERROR_SEVERITY()            
select 0 StatusFlag,@ErrMsg Message            
END CATCH 

