    
      
CREATE PROCEDURE [dbo].[usp_ERP_Fine_CalculateBased_On_Frequency_Bak_10062025]        
    @BrandID INT,        
    @s_StudentID NVARCHAR(MAX),        
    @Paymentdate date = Null        
AS        
BEGIN        
    SET NOCount ON        
    --Declare   @BrandID INT=1,        
    --    @s_StudentID VARCHAR(10)='24-0042'        
        
    --Declare @Paymentdate date=(Select convert(date,getdate()))        
    --Declare @Paymentdate date='2024-07-28'        
    --Select @Paymentdate        
    DECLARE @FineTotal DECIMAL(18, 2) = 0;        
    Declare @FrequencyID int,        
            @FrequencyCode Varchar(50),        
            @FineTagID int,        
            @waiveoff bit,        
            @InvoiceHeaderID bigint        
        
    Select @FineTagID = IVP.I_FineTagID,        
           @waiveoff = IVP.Is_Fine_waiveroff,        
           @InvoiceHeaderID = IVP.I_Invoice_Header_ID        
    from T_Invoice_Parent IVP With (Nolock)        
        Inner Join T_Student_Detail SD With (Nolock)        
            on SD.I_Student_Detail_ID = IVP.I_Student_Detail_ID        
        Inner Join T_Enquiry_Regn_Detail RD With (Nolock)        
            on RD.I_Enquiry_Regn_ID = SD.I_Enquiry_Regn_ID        
        Inner Join T_Brand_Center_Details BCD With (Nolock)        
            on BCD.I_Centre_Id = RD.I_Centre_Id        
    where SD.S_Student_ID = @s_StudentID        
          and BCD.I_Brand_ID = @BrandID        
        
      print @FineTagID  
        
    --------------------------------------------------------------        
    Select @FrequencyID = FreqType,        
           @FrequencyCode = PT.S_Installment_Frequency        
    from T_ERP_Fee_Fine_Header FH With (Nolock)        
        Inner Join T_ERP_Fee_PaymentInstallment_Type PT With (Nolock)        
            On FH.FreqType = PT.I_Fee_Pay_Installment_ID        
    where I_Fee_Fine_H_ID = @FineTagID        
   -- Select @FineTagID,@waiveoff,@FrequencyID,@FrequencyCode,@Paymentdate        
        
    If (@FineTagID is Not Null or @FineTagID <> 0)        
    Begin ---start Checking existense of Fine        
        --If (@waiveoff is null or @waiveoff = 0)        
        --Begin ----Start Block to Check fine Waive Off        
            Declare @InvDetails as Table        
            (        
                Id Int identity(1, 1),        
                T_Invoice_Child_Header Bigint,        
                Dt_Installment_Date datetime,        
                InstallmentNo Int,        
                N_FineAmount Numeric(18, 2)        
            )        
            Insert Into @InvDetails        
            (        
                T_Invoice_Child_Header,        
                Dt_Installment_Date,        
                InstallmentNo        
            )        
            Select ICH.I_Invoice_Header_ID,        
                   ICD.Dt_Installment_Date,        
                   ICD.I_Installment_No        
            from T_Invoice_Child_Header ICH With (Nolock)        
                Inner Join T_Invoice_Child_Detail ICD With (Nolock)        
                    on ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID        
            Where ICH.I_Invoice_Header_ID = @InvoiceHeaderID        
                  --and ICD.S_Invoice_Number Like '%TEMP%'        
            Group By ICH.I_Invoice_Header_ID,        
                     ICD.Dt_Installment_Date,        
                     ICD.I_Installment_No        
        
       If (@waiveoff is null or @waiveoff = 0)        
        Begin ----Start Block to Check fine Waive Off        
            --Select * from @InvDetails        
        
            Declare @ID Int = 1,        
                    @lst Int,        
                    @InstallmentDt Date,        
                    @FineAmount Numeric(18, 2)        
            SET @lst =        
            (        
                select Count(id) from @InvDetails        
            )        
            While @ID <= @lst        
            Begin        
                Print convert(varchar(10), @id) + ' Daily'        
                --Declare @StartDate Date,@EndDate date        
                IF @FrequencyCode = 'Daily'        
                Begin        
      SET @InstallmentDt =        
                    (        
                        select convert(date, Dt_Installment_Date) from @InvDetails where ID = @id        
                    )        
             Print 'Installmentdate:' + convert(varchar(20), @InstallmentDt)        
                    If @Paymentdate > @InstallmentDt        
                    Begin        
                        Declare @LateDays int        
                        SET @LateDays = DATEDIFF(DAY, @InstallmentDt, @PaymentDate);        
      print @LateDays  
                        SET @FineAmount =        
                        (        
                            Select Top 1        
                                N_Fine_Amount        
                            from T_ERP_Fee_Fine_Details With (Nolock)        
                            where I_Fee_Fine_H_ID = @FineTagID        
                                  and @LateDays        
                                  Between I_Frm_Range and I_To_Range        
                        )        
                        --Select @LateDays,@FineAmount        
                        Update @InvDetails        
                        set N_FineAmount = Isnull(@FineAmount, 0)        
                        where ID = @ID    
      print @LateDays  
                    END        
                End        
                ELSE IF @FrequencyCode = 'Monthly'        
                BEGIN        
                    Declare @FinalMonthly_Amount numeric(18, 2)        
                    SET @FineAmount =        
                    (        
                        Select Top 1        
                            N_Fine_Amount        
                        from T_ERP_Fee_Fine_Details With (Nolock)        
                        where I_Fee_Fine_H_ID = @FineTagID        
                    )        
                    Declare @MonthDiff int        
                    SET @MonthDiff =        
                    (        
                        SELECT DATEDIFF(month, @InstallmentDt, @PaymentDate)        
                    )        
                    If @MonthDiff <> 0        
                    Begin        
                        Set @FinalMonthly_Amount = @MonthDiff * @FineAmount        
                    End        
                    Else        
                    Begin        
                        Set @FinalMonthly_Amount = @FineAmount        
                    End        
                    Update @InvDetails        
                    set N_FineAmount = Isnull(@FinalMonthly_Amount, 0)        
                    where ID = @ID        
                END        
                ELSE IF @FrequencyCode = 'Yearly'        
                BEGIN        
                    SET @FineAmount =        
                    (        
                        Select Top 1        
                            N_Fine_Amount        
                        from T_ERP_Fee_Fine_Details With (Nolock)        
                        where I_Fee_Fine_H_ID = @FineTagID        
                    )        
                    Update @InvDetails        
                    set N_FineAmount = Isnull(@FineAmount, 0)        
                    where ID = @ID        
        
                END        
        
        
                Set @id = @id + 1 --End Of Loop        
            END        
            SELECT @s_StudentID as StudentID,        
    @InvoiceHeaderID as InvoiceID,        
   T_Invoice_Child_Header,        
                   Dt_Installment_Date,        
                   InstallmentNo,        
                   Isnull(N_FineAmount, 0) as FineAmount        
                   from @InvDetails --------Select Final Fine data        
        End ----End Block to Check fine Waive Off        
        Else        
        Begin        
       SELECT @s_StudentID as StudentID,        
    @InvoiceHeaderID as InvoiceID,        
   T_Invoice_Child_Header,        
                   Dt_Installment_Date,        
                   InstallmentNo,        
                   Isnull(N_FineAmount, 0) as FineAmount        
                   from @InvDetails        
            Print 'Student Fine has been Waived off'        
        End        
    End ----End of Checking existense of Fine        
    Else        
    Begin        
            SELECT @s_StudentID as StudentID,        
    @InvoiceHeaderID as InvoiceID,        
   T_Invoice_Child_Header,        
                   Dt_Installment_Date,        
                   InstallmentNo,        
                   Isnull(N_FineAmount, 0) as FineAmount        
                   from @InvDetails        
    End        
End 
