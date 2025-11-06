-- =============================================                      
--Procedure: usp_ERP_FEE_Payment_Collection                      
-- Ref Used: UT_Student_Fee_Collection_Add                     
-- Author:      Abhik Porel                      
-- Create date: 17.01.2024        
-- Modified date: NA 
-- Reason: Fee Payment Collection       
-- Description: Fee Payment Collection                
-- =============================================       
CREATE PROCEDURE [dbo].[usp_ERP_FEE_Payment_Collection]
    @I_Fee_Struct_Payment_ID INT = NULL,
    @I_Enquiry_Regn_ID int,
    @I_School_Session_ID int,
    @I_Brand_ID int,
    @Is_Offline int,
    @PaymentModeID int,
    @p_Is_Active bit = null,
    @p_I_CreatedBy int,
    @paymentReceivedDt date,
    @Fee_Payment_collection [UT_Student_Fee_Collection_Add] READONLY
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @OutputInvNo Varchar(20),
                @Inv_DT Date
        SET @Inv_DT = Convert(Date, Getdate())
        ------Generate Invoice Number---------      
        EXEC USP_Stud_InvNo_Generate_and_Update @Inv_DT,
                                                @I_Brand_ID,
                                                @I_School_Session_ID,
                                                @type = 'MR',
                                                @Inv_No_Out = @OutputInvNo OUTPUT;
        ---------------------------------      
        --Select @OutputInvNo 
        -----Fetching Total Componentwise Installment amount------
        Declare @Total_InstallmentAmt Numeric(18, 2)
        SET @Total_InstallmentAmt =
        (
            Select SUM([N_Component_Actual_InstallmentAmt])
            from @Fee_Payment_collection
        )
        --------------------------------------------------------------------------
        --------Fetching Total Recevable amount--------------------------
        Declare @Total_ReceivableAmt Numeric(18, 2)
        SET @Total_ReceivableAmt =
        (
            Select Top 1 ([N_Total_Received_AMt]) from @Fee_Payment_collection
        )
        -----Fetching Invoice ID -------
        Declare @I_Stud_Fee_Struct_CompMap_ID int
        SET @I_Stud_Fee_Struct_CompMap_ID =
        (
            Select Top 1
                I_Stud_Fee_Struct_CompMap_ID
            from T_ERP_Stud_Fee_Struct_Comp_Mapping
            Where R_I_School_Session_ID = @I_School_Session_ID
                  and I_Brand_ID = @I_Brand_ID
                  And R_I_Enquiry_Regn_ID = @I_Enquiry_Regn_ID
        )

        IF @I_Fee_Struct_Payment_ID IS NULL
        Begin
            INSERT INTO T_ERP_Student_Fee_Payment_Header
            (
                I_Brand_Id,
                I_School_Session_ID,
                R_I_Enquiry_Regn_ID,
                N_TotalInstallment_Amount,
                For_Dt_Installment_Dt,
                N_Total_Received_Amount,
                S_Payment_Receipt_No,
                Is_Offline,
                R_I_PaymentMode_ID,
                I_Payment_Status,
                Dt_Payment_Received_Dt,
                Dtt_Created_At,
                I_Created_By,
                I_Stud_Fee_Struct_CompMap_ID,
                Is_Active
            )
            values
            (   @I_Brand_ID,
                @I_School_Session_ID,
                @I_Enquiry_Regn_ID,
                @Total_InstallmentAmt,
                Null,
                @Total_ReceivableAmt,
                @OutputInvNo, -----For Money Receipt No generation                     
                @Is_Offline,
                @PaymentModeID,
                1,
                @paymentReceivedDt,
                Getdate(),
                @p_I_CreatedBy,
                @I_Stud_Fee_Struct_CompMap_ID,
                1
            )
            SET @I_Fee_Struct_Payment_ID = SCOPE_IDENTITY();
            -----Inserting Payment Details-----
            Insert Into T_ERP_Student_Fee_Payment_Details
            (
                I_Fee_Struct_Payment_ID,
                I_Fee_Component_InstallmentID,
                N_Amount_Paid,
                Is_Active,
                Dtt_Created_At,
                I_Created_By
            )
            Select @I_Fee_Struct_Payment_ID,
                   I_Fee_Component_InstallmentID,
                   N_ComponentReceived_Amt,
                   1,
                   Getdate(),
                   @p_I_CreatedBy
            from @Fee_Payment_collection

            -----Checking Adv Payment----------
            Declare @AdvAmt Numeric(12, 2)
            IF @Total_ReceivableAmt > @Total_InstallmentAmt
            Begin
                SET @AdvAmt = @Total_ReceivableAmt - @Total_InstallmentAmt
                Insert Into T_ERP_Fee_Advance_Records
                (
                    I_Brand_ID,
                    R_I_Enquiry_Regn_ID,
                    R_I_School_Session_ID,
                    N_Adv_Amt,
                    Dt_Adv_Dt,
                    I_Fee_Struct_Payment_ID,
                    Is_Active,
                    Dt_Create_Dt,
                    Is_AdhocAdv
                )
                Values
                (@I_Brand_ID,
                 @I_Enquiry_Regn_ID,
                 @I_School_Session_ID,
                 @AdvAmt,
                 @paymentReceivedDt,
                 @I_Fee_Struct_Payment_ID,
                 1  ,
                 GETDATE(),
                 0
                )
                -----Fetching Next Installment Date and AMount-----
                Declare @I_Fee_Component_InstallmentID int
                SET     @I_Fee_Component_InstallmentID =
                (
                    Select top 1
                        I_Fee_Component_InstallmentID
                    from T_ERP_Fee_Payment_Installment FPI
                        Inner Join T_ERP_Stud_Fee_Struct_Comp_Mapping_Details d
                            on d.I_Stud_Fee_Struct_CompMap_Details_ID = FPI.I_Stud_Fee_Struct_CompMap_Details_ID
                        Inner Join T_ERP_Stud_Fee_Struct_Comp_Mapping M
                            on M.I_Stud_Fee_Struct_CompMap_ID = d.R_I_Stud_Fee_Struct_CompMap_ID
                    where M.Is_Active = 1
                          and d.Is_Active = 1
                          and FPI.Is_Active = 1
                          And M.R_I_Enquiry_Regn_ID = 1
                          and M.I_Brand_ID = 1
                          and M.R_I_School_Session_ID = 1
                          and FPI.Dt_Payment_Installment_Dt > CONVERT(DATE, @paymentReceivedDt)
                    Order by FPI.Seq
                )
                --Select Dt_Payment_Installment_Dt,N_Installment_Amount ,@AdvAmt
                --from T_ERP_Fee_Payment_Installment 
                --where I_Fee_Component_InstallmentID=@I_Fee_Component_InstallmentID
                Update T_ERP_Fee_Payment_Installment
                Set Adv_Amt = @AdvAmt
                where I_Fee_Component_InstallmentID = @I_Fee_Component_InstallmentID
            End
            -------Update On existing Installment table-----
            Update FPI
            Set FPI.N_Received_Amt = UT.N_ComponentReceived_Amt,
                FPI.I_Installment_Status = 
				Case When FPI.N_Installment_Amount=Ut.N_ComponentReceived_Amt
				Then 1
				Else 0 End,
                FPI.Dt_Payment_Dt = Convert(Date, Getdate())
            From T_ERP_Fee_Payment_Installment FPI
                 Inner Join @Fee_Payment_collection Ut
                    on Ut.[I_Fee_Component_InstallmentID] = FPI.I_Fee_Component_InstallmentID
            where FPI.R_I_Enquiry_Regn_ID = @I_Enquiry_Regn_ID

        END
		---Generate-Update InstallMent Wise TempInvoice-------
		Declare @ID int,@Lst int
		Create Table #TempPayment_Collection(
		ID int Identity(1,1),
		[I_Fee_Component_InstallmentID] int
		)
		Insert Into #TempPayment_Collection([I_Fee_Component_InstallmentID])
		Select [I_Fee_Component_InstallmentID] From @Fee_Payment_collection 
		SET @ID=1
		SET @Lst =(Select MAX(ID) from  #TempPayment_Collection )
		While @ID<=@Lst
		Begin

		 Declare @TempInstallmentInv Varchar(100),@Fee_Component_InstallmentID int
		 SET @Fee_Component_InstallmentID=(Select Top 1 [I_Fee_Component_InstallmentID] 
		 from #TempPayment_Collection Where ID=@ID)
		 ------Looping generate tempInstallment Inv.
         EXEC USP_Stud_InstallmentWise_InvNo_Generate
         @brandID=@I_Brand_ID
        ,@SessionID=@I_School_Session_ID
        ,@type='INV'
        ,@Inv_No_Out=@TempInstallmentInv OUTPUT
		-- Select @Fee_Component_InstallmentID
         --Select @TempInstallmentInv
		 Update T_ERP_Fee_Payment_Installment Set TempInv=@TempInstallmentInv 
		 Where I_Fee_Component_InstallmentID=@Fee_Component_InstallmentID and TempInv IS Null
		 and I_Installment_Status=1
		 SET @ID=@ID+1
		End 
		Drop Table #TempPayment_Collection

        -----------------------------------------------------------------      

        select 1 StatusFlag,
               'Fee Installment Paid' Message
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
