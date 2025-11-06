CREATE PROCEDURE [dbo].[usp_ERP_Get_TaxRegister_for_Oracle]
    @iBrandID INT,
    @dtStartDate DATETIME = NULL,
    @dtEndDate   DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @dtExecutionDate DATETIME;
    -- Declared internally as requested
    --DECLARE @StatusFlag INT;
    --DECLARE @Message VARCHAR(MAX);

    BEGIN TRY
        BEGIN TRANSACTION;

        CREATE TABLE #temp
        (
            BrandID int,
            TransactionTypeID int,
            StudentDetailID int,
            StudentID varchar(max),
            CostCentre varchar(max),
            Amount decimal(14,2),
            TransactionDate datetime,
            CreditNoteNo varchar(max),
            FeeComponent varchar(max)
        );

        SET @dtExecutionDate = @dtStartDate;  -- mm/dd/yyyy

        WHILE (DATEDIFF(dd, @dtExecutionDate, @dtEndDate) >= 0)
        BEGIN

            INSERT INTO #temp
            SELECT  tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID, tsd.S_Student_ID,
                    tcm.S_Cost_Center, ABS(ticd.N_Amount_Due), @dtExecutionDate, ticd.S_Invoice_Number, tttm.S_Transaction_Code
            FROM dbo.T_Invoice_Parent AS tip WITH (NOLOCK)
            INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
            INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
            INNER JOIN dbo.T_Invoice_Child_Header AS tich WITH (NOLOCK) ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
            INNER JOIN dbo.T_Invoice_Child_Detail AS ticd WITH (NOLOCK) ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID
            INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
                AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Brand_ID = tbcd.I_Brand_ID
                AND tttm.I_Status_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
                AND tttm.I_Transaction_Nature_ID = 2
            INNER JOIN T_Student_Detail tsd ON tsd.I_Student_Detail_ID = tip.I_Student_Detail_ID
            WHERE tip.I_Status = 0
              AND CONVERT(DATE, tip.Dt_Upd_On) < CONVERT(DATE, '2017-07-01')
              AND DATEDIFF(dd,
                           CASE WHEN ticd.Dt_Installment_Date > tip.Dt_Upd_On THEN ticd.Dt_Installment_Date
                                ELSE tip.Dt_Upd_On END,
                           @dtExecutionDate) = 0
              AND ISNULL(ticd.Flag_IsAdvanceTax, 'N') <> 'Y'
              AND tbcd.I_Brand_ID = @iBrandID

            UNION ALL

            SELECT  tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID, tsd.S_Student_ID,
                    tcm.S_Cost_Center, ABS(tidt.N_Tax_Value_Scheduled), @dtExecutionDate, ticd.S_Invoice_Number, tttm.S_Transaction_Code
            FROM dbo.T_Invoice_Parent AS tip WITH (NOLOCK)
            INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
            INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
            INNER JOIN dbo.T_Invoice_Child_Header AS tich WITH (NOLOCK) ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
            INNER JOIN dbo.T_Invoice_Child_Detail AS ticd WITH (NOLOCK) ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID
            INNER JOIN dbo.T_Invoice_Detail_Tax AS tidt WITH (NOLOCK) ON ticd.I_Invoice_Detail_ID = tidt.I_Invoice_Detail_ID
            INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
                AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Brand_ID = tbcd.I_Brand_ID
                AND tidt.I_Tax_ID = tttm.I_Tax_ID AND tttm.I_Status_ID IS NULL AND tttm.I_Status = 1
                AND tttm.I_Transaction_Nature_ID = 2
            INNER JOIN T_Student_Detail tsd ON tsd.I_Student_Detail_ID = tip.I_Student_Detail_ID
            WHERE tip.I_Status = 0
              AND CONVERT(DATE, tip.Dt_Upd_On) < CONVERT(DATE, '2017-07-01')
              AND DATEDIFF(dd,
                           CASE WHEN ticd.Dt_Installment_Date > tip.Dt_Upd_On THEN ticd.Dt_Installment_Date
                                ELSE tip.Dt_Upd_On END,
                           @dtExecutionDate) = 0
              AND ISNULL(ticd.Flag_IsAdvanceTax, 'N') <> 'Y'
              AND tbcd.I_Brand_ID = @iBrandID

            UNION ALL

            SELECT  tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID, tsd.S_Student_ID,
                    tcm.S_Cost_Center, ABS(ISNULL(tcnicd.N_Amount_Due,0)), @dtExecutionDate, tcnicd.S_Invoice_Number, tttm.S_Transaction_Code
            FROM dbo.T_Invoice_Parent AS tip WITH (NOLOCK)
            INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
            INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
            INNER JOIN T_Credit_Note_Invoice_Child_Detail tcnicd WITH (NOLOCK) ON tip.I_Invoice_Header_ID = tcnicd.I_Invoice_Header_ID
            INNER JOIN dbo.T_Invoice_Child_Detail AS ticd WITH (NOLOCK) ON tcnicd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
            INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
                AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Brand_ID = tbcd.I_Brand_ID
                AND tttm.I_Status_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
                AND tttm.I_Transaction_Nature_ID = 2
            INNER JOIN T_Student_Detail tsd ON tsd.I_Student_Detail_ID = tip.I_Student_Detail_ID
            WHERE tip.I_Status = 0
              AND DATEDIFF(dd,
                           CASE WHEN ticd.Dt_Installment_Date > tip.Dt_Upd_On THEN ticd.Dt_Installment_Date
                                ELSE tip.Dt_Upd_On END,
                           @dtExecutionDate) = 0
              AND ISNULL(ticd.Flag_IsAdvanceTax, 'N') <> 'Y'
              AND tbcd.I_Brand_ID = @iBrandID

            UNION ALL

            SELECT  tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID, tsd.S_Student_ID,
                    tcm.S_Cost_Center, ISNULL(tcnidt.N_Tax_Value,0), @dtExecutionDate, tcnicd.S_Invoice_Number, tttm.S_Transaction_Code
            FROM dbo.T_Invoice_Parent AS tip WITH (NOLOCK)
            INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
            INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
            INNER JOIN T_Credit_Note_Invoice_Child_Detail tcnicd WITH (NOLOCK) ON tip.I_Invoice_Header_ID = tcnicd.I_Invoice_Header_ID
            INNER JOIN dbo.T_Invoice_Child_Detail AS ticd WITH (NOLOCK) ON tcnicd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
            INNER JOIN dbo.T_Credit_Note_Invoice_Child_Detail_Tax AS tcnidt WITH (NOLOCK) ON ticd.I_Invoice_Detail_ID = tcnidt.I_Invoice_Detail_ID
            INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
                AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Brand_ID = tbcd.I_Brand_ID
                AND tcnidt.I_Tax_ID = tttm.I_Tax_ID AND tttm.I_Status_ID IS NULL AND tttm.I_Status = 1
                AND tttm.I_Transaction_Nature_ID = 2
            INNER JOIN T_Student_Detail tsd ON tsd.I_Student_Detail_ID = tip.I_Student_Detail_ID
            WHERE tip.I_Status = 0
              AND DATEDIFF(dd,
                           CASE WHEN ticd.Dt_Installment_Date > tip.Dt_Upd_On THEN ticd.Dt_Installment_Date
                                ELSE tip.Dt_Upd_On END,
                           @dtExecutionDate) = 0
              AND ISNULL(ticd.Flag_IsAdvanceTax, 'N') <> 'Y'
              AND tbcd.I_Brand_ID = @iBrandID

            UNION ALL

            SELECT  tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID, tsd.S_Student_ID,
                    tcm.S_Cost_Center, ISNULL(tcnidt.N_Tax_Value,0), @dtExecutionDate, tcnicd.S_Invoice_Number, tttm.S_Transaction_Code
            FROM dbo.T_Invoice_Parent AS tip WITH (NOLOCK)
            INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
            INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
            INNER JOIN T_Credit_Note_Invoice_Child_Detail tcnicd WITH (NOLOCK) ON tip.I_Invoice_Header_ID = tcnicd.I_Invoice_Header_ID
            INNER JOIN dbo.T_Invoice_Child_Detail AS ticd WITH (NOLOCK) ON tcnicd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
            INNER JOIN dbo.T_Credit_Note_Invoice_Child_Detail_Tax AS tcnidt WITH (NOLOCK) ON ticd.I_Invoice_Detail_ID = tcnidt.I_Invoice_Detail_ID
            INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
                AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Brand_ID = tbcd.I_Brand_ID
                AND tcnidt.I_Tax_ID = tttm.I_Tax_ID AND tttm.I_Status_ID IS NULL AND tttm.I_Status = 1
                AND tttm.I_Transaction_Nature_ID = 2
            INNER JOIN T_Student_Detail tsd ON tsd.I_Student_Detail_ID = tip.I_Student_Detail_ID
            WHERE DATEDIFF(dd, tcnicd.Dt_Crtd_On, @dtExecutionDate) = 0
              AND ISNULL(ticd.Flag_IsAdvanceTax, 'N') = 'Y'
              AND tbcd.I_Brand_ID = @iBrandID

            UNION ALL

            SELECT  tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID, tsd.S_Student_ID,
                    tcm.S_Cost_Center, ISNULL(trtd.N_Tax_Paid,0), @dtExecutionDate, tcnicd.S_Invoice_Number, tttm.S_Transaction_Code
            FROM dbo.T_Receipt_Header AS trh WITH (NOLOCK)
            INNER JOIN dbo.T_Receipt_Component_Detail AS trcd WITH (NOLOCK) ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
            INNER JOIN dbo.T_Receipt_Tax_Detail AS trtd WITH (NOLOCK) ON trcd.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID
            INNER JOIN dbo.T_Invoice_Child_Detail AS ticd WITH (NOLOCK) ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
            INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
            INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
            INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
                AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Brand_ID = tbcd.I_Brand_ID
                AND trtd.I_Tax_ID = tttm.I_Tax_ID AND tttm.I_Status_ID IS NULL AND tttm.I_Status = 1
                AND tttm.I_Transaction_Nature_ID = 2
            INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID = trh.I_Invoice_Header_ID
            INNER JOIN T_Credit_Note_Invoice_Child_Detail tcnicd ON ticd.I_Invoice_Detail_ID = tcnicd.I_Invoice_Detail_ID
            INNER JOIN T_Student_Detail tsd ON tsd.I_Student_Detail_ID = trh.I_Student_Detail_ID
            WHERE trh.I_Status = 0
              -- AND CONVERT(DATE,ticd.Dt_Installment_Date) < CONVERT(DATE, '2017-07-01')
              AND CONVERT(DATE,ticd.Dt_Installment_Date) >= CONVERT(DATE, '2017-07-01')
              AND CONVERT(DATE,ticd.Dt_Installment_Date) >= CONVERT(DATE,trh.Dt_Upd_On) -- RAJ
              AND CONVERT(DATE,trh.Dt_Receipt_Date) < CONVERT(DATE,ticd.Dt_Installment_Date)
              AND DATEDIFF(dd, trh.Dt_Upd_On, @dtExecutionDate) = 0
              AND trh.I_Invoice_Header_ID IS NOT NULL
              AND tbcd.I_Brand_ID = @iBrandID;

            SET @dtExecutionDate = DATEADD(dd, 1, @dtExecutionDate);
        END; -- WHILE loop

        -- return the data exactly as original script
        SELECT * FROM #temp;

        -- Clean up
        IF OBJECT_ID('tempdb..#temp') IS NOT NULL
            DROP TABLE #temp;

        COMMIT TRANSACTION;

        --SET @StatusFlag = 1;
        --SET @Message = 'Success';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        IF OBJECT_ID('tempdb..#temp') IS NOT NULL
            DROP TABLE #temp;

        --SET @StatusFlag = 0;
        --SET @Message = CONCAT(
        --    'Error: ', ERROR_NUMBER(), ' - ', ERROR_SEVERITY(), ' - ', ERROR_STATE(), ' - ',
        --    ERROR_PROCEDURE(), ' - ', ERROR_LINE(), ' - ', ERROR_MESSAGE()
        --);
    END CATCH;

    -- Return status info as a second resultset (local variables, not output params)
    --SELECT @StatusFlag AS StatusFlag, @Message AS Message;
END