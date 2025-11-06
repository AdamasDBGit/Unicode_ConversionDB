        
-- =============================================          
-- Author:  <Author,,Name>          
-- Create date: <Create Date,,>          
-- Description: <Description,,>          
-- exec [usp_ERP_InsertFeeStructureAcademicSessionMap] 107,21,2,1          
-- =============================================          
CREATE PROCEDURE [dbo].[usp_ERP_Insert_Fee_StructureAcademicSessionMap]          
(          
 @BrandID int,          
 @FeeStructureID int,          
 @SchoolSessionID int,          
 @CreatedBy int,        
 @FeeStructureSessionInstallmentBreakup UT_ERP_Fee_Structure_Academic_Session_Installment_Breakup READONLY          
)          
AS          
begin transaction          
BEGIN TRY           
 SET NOCOUNT ON;            
          
  If exists (select 1 from T_ERP_Fee_Structure_AcademicSession_Map         
  where I_Fee_Structure_ID=@FeeStructureID and I_School_Session_ID=@SchoolSessionID)          
  Begin          
   Update [dbo].[T_ERP_Fee_Structure_AcademicSession_Map]          
   Set          
    Is_Active = 1,          
    Dt_Updated_At = GETDATE(),          
    I_Updated_By = @CreatedBy          
   Where I_Fee_Structure_ID=@FeeStructureID and I_School_Session_ID=@SchoolSessionID          
   Update T_ERP_Fee_Structure_AcademicSession_Map set Is_Active=0         
   where I_Fee_Structure_ID=@FeeStructureID and I_School_Session_ID<>@SchoolSessionID        
  end          
  else          
  begin          
   INSERT INTO [dbo].[T_ERP_Fee_Structure_AcademicSession_Map]          
   (          
    I_Brand_ID,          
    I_School_Session_ID,          
    I_Fee_Structure_ID,          
    Is_Active,          
    I_Created_By,          
    Dt_Created_At          
   )          
   VALUES          
   (          
    @BrandID,          
    @SchoolSessionID,          
    @FeeStructureID,          
    1,          
    @CreatedBy,          
    GETDATE()          
   )          
        
        
   DECLARE @Fee_Structure_AcademicSession_Map int = NULL        
        
   set @Fee_Structure_AcademicSession_Map = SCOPE_IDENTITY()        
   -------GST Generation-----------    
   Create Table #TempComponent_GST (            
 I_ID int Identity(1,1),            
 I_Fee_Structure_ID int,            
 I_Fee_Component_ID int,            
 CGST_Amt Numeric(18,2),            
 SGST_Amt Numeric(18,2),            
 IGST_Amt Numeric(18,2),            
 CGST_Per Numeric(10,2),            
 SGST_Per Numeric(10,2),            
 IGST_Per numeric(10,2)            
            
 )            
Insert Into #TempComponent_GST (I_Fee_Structure_ID,I_Fee_Component_ID,CGST_Amt,SGST_Amt,IGST_Amt,            
CGST_Per,SGST_Per,IGST_Per)            
EXEC [dbo].[USP_ERP_get_FEE_Structure_GST_Generation] @FeeStructureID,NULL      
        
        
   insert into T_ERP_Fee_Structure_Session_Installment_Breakup        
   (        
  I_Fee_Structure_Installment_Component_ID,        
  R_I_Fee_Component_ID,        
  I_Seq_No,        
  N_Component_Actual_Total_Annual_Amount,        
  Is_OneTime,        
  R_I_Fee_Pay_Installment_ID,        
  Is_During_Admission,        
  Expected_Installment_Date,        
  Dtt_Created_At,        
  I_Created_By,        
  I_Fee_Structure_AcademicSession_Map_ID  ,      
  I_Fee_Structure_ID  ,    
  SGST_Perc,    
  CGST_Perc,    
  IGST_Perc,    
  CGST_value,    
  SGST_value,    
  IGST_value    
   )        
   select   Distinct      
   I_Fee_Structure_Installment_Component_ID,        
   R_I_Fee_Component_ID,        
   I_Seq_No,        
   N_Component_Actual_Total_Annual_Amount,        
   Is_OneTime,        
   ISNULL(R_I_Fee_Pay_Installment_ID,3),        
   Is_During_Admission,        
   Expected_Installment_Date,        
   GETDATE(),        
   @CreatedBy,        
   @Fee_Structure_AcademicSession_Map        
   ,@FeeStructureID    
   ,tgst.SGST_Per    
   ,tgst.CGST_Per    
   ,tgst.IGST_Per    
   ,(N_Component_Actual_Total_Annual_Amount * tgst.CGST_Per / 100)  
   ,(N_Component_Actual_Total_Annual_Amount * tgst.SGST_Per / 100)  
   ,(N_Component_Actual_Total_Annual_Amount * tgst.IGST_Per / 100)  
   --,tgst.CGST_Amt    
   --,tgst.SGST_Amt    
   --,tgst.IGST_Amt    
   from @FeeStructureSessionInstallmentBreakup   ut     
   Left Join #TempComponent_GST tgst     
   on tgst.I_Fee_Component_ID=ut.R_I_Fee_Component_ID    
   and tgst.I_Fee_Structure_ID=@FeeStructureID    
        
        
--- Start : 2025-Jul-31 : Susmita : Command for multiple session---
   --Update T_ERP_Fee_Structure_AcademicSession_Map set Is_Active=0         
   --where I_Fee_Structure_ID=@FeeStructureID and I_School_Session_ID<>@SchoolSessionID 
--- End : 2025-Jul-31 : Susmita : Command for multiple session---   
  end          
  SELECT 1 StatusFlag,'Academic Session and Fee Structure Mapped successfully' Message               
  commit transaction;          
END TRY          
BEGIN CATCH          
 IF @@TRANCOUNT > 0          
  rollback transaction;          
            
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int          
          
 --SELECT @ErrMsg = ERROR_MESSAGE(),          
 --  @ErrSeverity = ERROR_SEVERITY()          
 select 0 StatusFlag,ERROR_MESSAGE() Message          
 --RAISERROR(@ErrMsg, @ErrSeverity, 1)          
END CATCH 