-- =============================================                                
--Procedure: usp_ERP_insert_Update_Fee_Structure_Component                                
-- Ref Used: UT_Student_Fee_Add                               
-- Author:      Abhik Porel                                
-- Create date: 27.12.2023                  
-- Modified date:04.01.2023                  
-- Reason: Integrate Payment Installment Process                  
-- Description: Savings Fee on Admission                                
-- =============================================  
--drop proc [usp_ERP_Save_Update_Fee_On_Admission_Bak_01022024]
CREATE PROCEDURE [dbo].[usp_ERP_Save_Update_Fee_On_Admission_Bak_01022024]                
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
BEGIN                
    SET NOCOUNT ON;                
    BEGIN TRY                
        BEGIN TRANSACTION;                
        DECLARE @OutputInvNo Varchar(20),                
                @Inv_DT Date                
            SET @Inv_DT = Convert(Date, Getdate())                
            
        --Select @OutputInvNo              
   -- If  Exists ( Select 1 from T_ERP_Stud_Fee_Struct_Comp_Mapping where R_I_Enquiry_Regn_ID=@I_Enquiry_Regn_ID and R_I_School_Session_ID=@I_School_Session_ID        
   --and I_Brand_ID=@I_Brand_ID)          
   --         Begin         
   ----SET @h_I_Stud_Fee_Struct_CompMap_ID=(Select I_Stud_Fee_Struct_CompMap_ID from T_ERP_Stud_Fee_Struct_Comp_Mapping         
   ----where R_I_Enquiry_Regn_ID=@I_Enquiry_Regn_ID and R_I_School_Session_ID=@I_School_Session_ID        
   ----and I_Brand_ID=@I_Brand_ID)        
   --select 0 StatusFlag,                
   --            'Fee Structure Already  Mapped' Message        
   --RETURN;         
   --End        
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
                Is_Active = 1                
            from T_ERP_Stud_Fee_Struct_Comp_Mapping a1                
            Inner Join @Fee_Details_On_Admission UT                
            on UT.h_I_Stud_Fee_Struct_CompMap_ID = a1.I_Stud_Fee_Struct_CompMap_ID           
   where a1.I_Stud_Fee_Struct_CompMap_ID=@h_I_Stud_Fee_Struct_CompMap_ID        
                
        End                
        -- SET @h_I_Stud_Fee_Struct_CompMap_ID = SCOPE_IDENTITY();                               
        MERGE INTO T_ERP_Stud_Fee_Struct_Comp_Mapping_Details AS target                
        Using @Fee_Details_On_Admission AS Source                
        ON target.I_Stud_Fee_Struct_CompMap_Details_ID = source.I_Stud_Fee_Struct_CompMap_Details_ID                
           And target.R_I_Stud_Fee_Struct_CompMap_ID = Source.h_I_Stud_Fee_Struct_CompMap_ID                
        WHEN MATCHED THEN                
            UPDATE SET R_I_Fee_Structure_ID = Source.R_I_Fee_Structure_ID,                
                       R_I_Fee_Component_ID = Source.R_I_Fee_Component_ID,                
                       N_Component_Actual_Amount = Source.N_Component_Actual_Amount,                
                       R_I_Fee_Pay_Installment_ID = Source.I_Fee_Pay_Installment_ID,            
                       Seq=Source.Comp_Seq,            
                       Dtt_Modified_At = Getdate()                
        WHEN NOT MATCHED THEN                
          INSERT                
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
                R_I_Fee_Pay_Installment_ID                
            )                
            Values                
            (        
    @h_I_Stud_Fee_Struct_CompMap_ID,                
             Source.R_I_Fee_Structure_ID,                
             Source.[R_I_Fee_Component_ID],                
             Source.[N_Component_Actual_Amount],            
             Source.Comp_Seq,            
             getdate(),                
             Null,                
             @p_I_CreatedBy,                
             Null,                
             Source.[Is_Active],                
             Source.I_Fee_Pay_Installment_ID                
            )                
          WHEN NOT MATCHED BY SOURCE AND R_I_Stud_Fee_Struct_CompMap_ID = @h_I_Stud_Fee_Struct_CompMap_ID THEN                
            Update SET Is_Active = 0,                
                       Dtt_Modified_At = GETDATE();                
                
                
        ------Update Total Amount of Individual component-----                        
        Update mp                
        Set N_Comp_Total_Amount =                
            (                
                Select Sum([N_Component_Actual_Amount])                
                from @Fee_Details_On_Admission                
                where Is_Active = 1                
                Group by R_I_Fee_Structure_ID                
          )                
        From T_ERP_Stud_Fee_Struct_Comp_Mapping mp                
            Inner Join @Fee_Details_On_Admission UDT                
                on mp.I_Stud_Fee_Struct_CompMap_ID = @h_I_Stud_Fee_Struct_CompMap_ID                
        ------Update Total Componentwise amount---                        
        Update T_ERP_Stud_Fee_Struct_Comp_Mapping                
        Set N_Component_Wise_TotalAmt =                
            (                
                Select Sum([N_Component_Actual_Amount])                
                from @Fee_Details_On_Admission                
                where Is_Active = 1                
                      and [R_I_Fee_Structure_ID] = 0                
                Group by R_I_Fee_Structure_ID                
            )                
        From T_ERP_Stud_Fee_Struct_Comp_Mapping mp                
            Inner Join @Fee_Details_On_Admission UDT                
                on mp.I_Stud_Fee_Struct_CompMap_ID = @h_I_Stud_Fee_Struct_CompMap_ID                
        ----Generate Installment Payment Process----------                  
        EXEC usp_ERP_Fee_InstallmentPayment @Enquiry_Regn_ID = @I_Enquiry_Regn_ID,                
                                            @School_Session_ID = @I_School_Session_ID,                
                                            @I_Brand_ID = @I_Brand_ID                
  -----------------------------------------------------------------                
                
        select 1 StatusFlag,                
               'Fee Structure Mapped with Student' Message              
      --End          
      --Else          
      --Begin          
      --select 0 StatusFlag,                
      --         'Enquiry ID Already Mapped' Message              
      --End          
          
        COMMIT;                
    END TRY                
    BEGIN CATCH                
        IF @@TRANCOUNT > 0                
            ROLLBACK;                
                
        DECLARE @ErrMsg NVARCHAR(4000),                
                @ErrSeverity int                
                
        SELECT ERROR_MESSAGE() as Message,                
               0 StatusFlag                
                
        RAISERROR(@ErrMsg, @ErrSeverity, 1)                
                
    END CATCH;                
END;
