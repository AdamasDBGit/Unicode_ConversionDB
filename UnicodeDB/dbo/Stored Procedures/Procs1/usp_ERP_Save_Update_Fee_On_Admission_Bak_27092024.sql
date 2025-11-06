-- =============================================                                                    
--Procedure: usp_ERP_insert_Update_Fee_Structure_Component                                                    
-- Ref Used: UT_Student_Fee_Add                                                   
-- Author:      Abhik Porel                                                    
-- Create date: 27.12.2023                                      
-- Modified date:12.02.2023                                      
-- Reason: Integrate Payment Installment Process                                      
-- Description: Savings Fee on Admission   and Installment generation                                                 
-- =============================================                    
CREATE PROCEDURE [dbo].[usp_ERP_Save_Update_Fee_On_Admission_Bak_27092024]                                    
    @h_I_Stud_Fee_Struct_CompMap_ID INT = NULL,                                    
    @I_Enquiry_Regn_ID int,                                    
    @I_Fee_Structure_ID int,                                    
    @I_School_Session_ID int,                                    
    @I_Brand_ID int,                                    
    @p_Is_Active bit = null,                                    
    @p_I_CreatedBy int,                              
    @PaymentType int,                              
    @Fee_Details_On_Admission [UT_Student_Fee_Add] READONLY                                    
AS                                    
Begin                                    
    SET NOCOUNT ON;                                    
    BEGIN TRY                                    
        BEGIN TRANSACTION;               
                
  DECLARE @OutputInvNo Varchar(20),                                    
                @Inv_DT Date                                    
            SET @Inv_DT = Convert(Date, Getdate())             
   Declare @Currency_ID int          
   SET @Currency_ID=(select top 1 I_Currency_Type_ID from T_ERP_Fee_Structure           
   where I_Fee_Structure_ID=@I_Fee_Structure_ID)          
              --Select @Currency_ID                             
   ----Fetching Fee Structure Component Details-----------                            
       Select distinct F.I_Fee_Structure_ID,                            
       Comp.R_I_Fee_Component_ID,                            
       Comp.I_Seq_No,                            
       Comp.N_Component_Actual_Total_Annual_Amount,                            
       Comp.R_I_Fee_Pay_Installment_ID,                            
       cOMP.Is_Active,                            
       cp.I_Stud_Fee_Struct_CompMap_ID,                            
       cd.I_Stud_Fee_Struct_CompMap_Details_ID,              
       cd.I_ExtracomponentRef_ID,              
       cd.I_ExtracomponentRef_Type     
                           
       Into #tempFeeStructure                            
       from T_ERP_Fee_Structure_Installment_Component Comp                            
       inner Join T_ERP_Fee_Structure F                            
        on F.I_Fee_Structure_ID = Comp.R_I_Fee_Structure_ID                
  ANd F.I_Fee_Structure_ID =@I_Fee_Structure_ID                 
  Left Join T_ERP_Stud_Fee_Struct_Comp_Mapping cp                             
  on cp.R_I_Fee_Structure_ID=F.I_Fee_Structure_ID                                        
  And cp.I_Brand_ID=I_Brand_ID                 
  and cp.R_I_School_Session_ID=@I_School_Session_ID                 
  and cp.R_I_Enquiry_Regn_ID=@I_Enquiry_Regn_ID                 
  Left Join T_ERP_Stud_Fee_Struct_Comp_Mapping_Details cd                             
  on cp.I_Stud_Fee_Struct_CompMap_ID=cd.R_I_Stud_Fee_Struct_CompMap_ID                            
  And Comp.R_I_Fee_Component_ID=cd.R_I_Fee_Component_ID                            
  where                            
       F.Is_Active = 1 and Comp.Is_Active=1  and  Comp.Is_OneTime=@PaymentType                        
   Union All                            
Select 0 As I_Fee_Structure_ID,                            
       R_I_Fee_Component_ID,                            
       Comp_Seq,                       
       [N_Component_Actual_Amount],                            
       I_Fee_Pay_Installment_ID,                       
       [Is_Active],                            
       [h_I_Stud_Fee_Struct_CompMap_ID],                            
       [I_Stud_Fee_Struct_CompMap_Details_ID] ,              
       I_ExtracomponentRef_ID,              
       I_ExtracomponentRef__Type      
    
       from @Fee_Details_On_Admission                         
     ------Fine Implement----------        
  Declare @Is_Fine_Applicable int,@FineTagID int    
  Set @Is_Fine_Applicable=(    
  Select top 1 isnull(Is_Late_Fine_Applicable ,0)    
  from T_ERP_Fee_Structure with(Nolock) where I_Fee_Structure_ID=@I_Fee_Structure_ID    
  )    
   Set @FineTagID=(    
  Select top 1 isnull(R_I_FineRangeTagID ,0)    
  from T_ERP_Fee_Structure with(Nolock) where I_Fee_Structure_ID=@I_Fee_Structure_ID    
  )    
  ----------------------------------------------------------------------------------    
    --drop table #tempFeeStructure                        
    --Select * from #tempFeeStructure                        
        IF @h_I_Stud_Fee_Struct_CompMap_ID IS NULL                                    
        Begin                               
    ------Generate Invoice Number---------                                    
        EXEC USP_Stud_InvNo_Generate_and_Update @Inv_DT,                                    
              @I_Brand_ID,                                    
               @I_School_Session_ID,                                
                                                @type='INV',                                
              @Inv_No_Out = @OutputInvNo OUTPUT;                                    
            ---------------------------------                                
                                   
           INSERT INTO T_ERP_Stud_Fee_Struct_Comp_Mapping                                    
            (                                    
                R_I_Enquiry_Regn_ID,                                    
                R_I_Fee_Structure_ID,                                    
                R_I_School_Session_ID,                                    
                I_Brand_ID,                                    
                N_Comp_Total_Amount,                                    
                N_Component_Wise_TotalAmt,                                    
                S_Invoice_No,                                    
                Dtt_Created_At,                                    
                Dtt_Modified_At,                                    
                I_Created_By,                                    
                I_Modified_By,                                    
                Is_Active ,                              
                Is_LumpSum     
     
                  
            )                                    
            values                                    
            (   @I_Enquiry_Regn_ID,                                    
                @I_Fee_Structure_ID,                                    
                @I_School_Session_ID,                                    
                @I_Brand_ID,                                    
                Null,                                    
                Null,                                    
                @OutputInvNo, -----For Inv No generation                                                   
                @Inv_DT,                                    
                Null,                                    
                @p_I_CreatedBy,                                    
                Null,                                    
                @p_Is_Active ,                              
                @PaymentType    
        
            )                                    
            SET @h_I_Stud_Fee_Struct_CompMap_ID = SCOPE_IDENTITY();                                    
        END                              
                            
        ELSE                                    
        Begin                                    
                                    
    UPDATE T_ERP_Stud_Fee_Struct_Comp_Mapping                                    
            SET R_I_Fee_Structure_ID = @I_Fee_Structure_ID,                                    
                Dtt_Modified_At = Getdate(),                                    
                I_Modified_By = @p_I_CreatedBy,                                    
                Is_Active = 1,                
                Is_LumpSum=@PaymentType                
            from T_ERP_Stud_Fee_Struct_Comp_Mapping a1                                    
            --Inner Join #tempFeeStructure UT                                    
            --on UT.I_Stud_Fee_Struct_CompMap_ID = a1.I_Stud_Fee_Struct_CompMap_ID             
            where a1.I_Stud_Fee_Struct_CompMap_ID=@h_I_Stud_Fee_Struct_CompMap_ID                            
                                    
        End                                    
                  
            ----Deleting Data from Installment Table First-----            
delete from  T_ERP_Fee_Payment_Installment where I_Stud_Fee_Struct_CompMap_Details_ID in(                
Select I_Stud_Fee_Struct_CompMap_Details_ID                 
from T_ERP_Stud_Fee_Struct_Comp_Mapping_Details                
where R_I_Stud_Fee_Struct_CompMap_ID in (                
Select I_Stud_Fee_Struct_CompMap_ID from T_ERP_Stud_Fee_Struct_Comp_Mapping                 
where R_I_Enquiry_Regn_ID=@I_Enquiry_Regn_ID and I_Brand_ID=@I_Brand_ID AND                 
R_I_School_Session_ID=@I_School_Session_ID                
))                
-----deleting STudent Mapping Details-------                
Delete                    
from T_ERP_Stud_Fee_Struct_Comp_Mapping_Details                
where R_I_Stud_Fee_Struct_CompMap_ID in (                
Select I_Stud_Fee_Struct_CompMap_ID from T_ERP_Stud_Fee_Struct_Comp_Mapping                 
where R_I_Enquiry_Regn_ID=@I_Enquiry_Regn_ID and I_Brand_ID=@I_Brand_ID AND                 
R_I_School_Session_ID=@I_School_Session_ID                
)                
-----Inserting Data into Student mapping Details----                
INSERT  Into    T_ERP_Stud_Fee_Struct_Comp_Mapping_Details                               
            (                                    
                R_I_Stud_Fee_Struct_CompMap_ID,                                    
                R_I_Fee_Structure_ID,                                    
                R_I_Fee_Component_ID,                                    
                N_Component_Actual_Amount,                            
                Seq,                          
                Dtt_Created_At,                                    
                Dtt_Modified_At,                                    
                I_Created_By,                                    
                I_Modified_By,                                    
                Is_Active,                                    
                R_I_Fee_Pay_Installment_ID ,              
                I_ExtracomponentRef_ID,              
                I_ExtracomponentRef_Type              
            )                                    
             Select                           
             @h_I_Stud_Fee_Struct_CompMap_ID,                                    
             I_Fee_Structure_ID,                                    
             R_I_Fee_Component_ID,                                    
             N_Component_Actual_Total_Annual_Amount,                                
             I_Seq_No,                                
             getdate(),                                    
             Null,                                    
             @p_I_CreatedBy,                                    
             Null,                                    
          [Is_Active],                                    
             R_I_Fee_Pay_Installment_ID,              
             I_ExtracomponentRef_ID,              
             I_ExtracomponentRef_Type              
             From #tempFeeStructure                  
      -----------------------------------------------------------------                
    ------------------GST Implementation----------------------------            
   EXEC ERP_FEE_GST_Generation @I_Enquiry_Regn_ID,@I_School_Session_ID,@I_Brand_ID            
  ---------------------------------------------------------------------            
                 
        ----Generate Installment Payment Process----------                                      
        EXEC usp_ERP_Fee_InstallmentPayment @Enquiry_Regn_ID = @I_Enquiry_Regn_ID,                                    
                                            @School_Session_ID = @I_School_Session_ID,                                    
                                            @I_Brand_ID = @I_Brand_ID  ,                        
                                            @PaymentType1=@PaymentType                        
  -----------------------------------------------------------------                
            
            
          update T_Enquiry_Regn_Detail set R_I_AdmStgTypeID = 6 where I_Enquiry_Regn_ID = @I_Enquiry_Regn_ID                          
    Update T_ERP_Stud_Fee_Struct_Comp_Mapping set I_Currency_ID=@Currency_ID          
    where I_Stud_Fee_Struct_CompMap_ID=@h_I_Stud_Fee_Struct_CompMap_ID      
 -------------Fine Update---------------------    
     Update T_ERP_Stud_Fee_Struct_Comp_Mapping set Is_Fine_Applicable=@Is_Fine_Applicable    
  ,I_FineTagID=@FineTagID    
        where I_Stud_Fee_Struct_CompMap_ID=@h_I_Stud_Fee_Struct_CompMap_ID      
    
 -------------------------------------------------------------------------    
    
   select 1 StatusFlag,                                    
               'Fee Structure Mapped with Student' Message                                  
            
                              
        COMMIT;                                    
    END TRY                                    
    BEGIN CATCH                                    
        IF @@TRANCOUNT > 0                                    
            ROLLBACK;                                    
                                    
        DECLARE @ErrMsg NVARCHAR(4000),            
                @ErrSeverity int                                    
                                    
        SELECT 'Error-On Temporary Saving data' as Message,                                    
               0 StatusFlag                                    
                                    
        RAISERROR(@ErrMsg, @ErrSeverity, 1)                                    
                                    
    END CATCH;                                    
END;
