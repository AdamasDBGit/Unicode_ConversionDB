CREATE PROCEDURE [dbo].[usp_ERP_Get_TaxRegister_ByDateRange_Oracle]
    @iBrandID INT,
    @dtStartDate DATETIME = NULL,
    @dtEndDate   DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @dtExecutionDate DATETIME;
    --DECLARE @StatusFlag INT;
    --DECLARE @Message VARCHAR(MAX);

    BEGIN TRY
        BEGIN TRANSACTION;

        CREATE TABLE #temp
        (
            BrandID int,
            TransactionTypeID int,
            StudentDetailID int,
            StudentID nvarchar(max),
            CostCentre nvarchar(max),
            Amount decimal(14,2),
            TransactionDate datetime,
            CreditNoteNo nvarchar(max),
            FeeComponent nvarchar(max)
        );

        SET @dtExecutionDate = @dtStartDate;  -- mm/dd/yyyy

        WHILE (DATEDIFF(dd, @dtExecutionDate, @dtEndDate) >= 0)
        BEGIN

            INSERT INTO #temp
            SELECT  tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID, tsd.S_Student_ID,
                    tcm.S_Cost_Center, ABS(ISNULL(ticd.N_Amount_Due,0)), @dtExecutionDate, ticd.S_Invoice_Number, tttm.S_Transaction_Code
            FROM dbo.T_Invoice_Parent AS tip
            INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
            INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
            --INNER JOIN dbo.T_Invoice_Batch_Map AS tibm ON tich.I_Invoice_Child_Header_ID = tibm.I_Invoice_Child_Header_ID AND tibm.I_Status = 1
            INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID
            INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tttm.I_Brand_ID = tbcd.I_Brand_ID 
                AND ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID AND tttm.I_Status_ID IS NULL 
                AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
                AND tttm.I_Transaction_Nature_ID = 1
            INNER JOIN T_Student_Detail tsd ON tsd.I_Student_Detail_ID = tip.I_Student_Detail_ID
            WHERE 
                DATEDIFF(dd,
                         CASE WHEN ticd.Dt_Installment_Date >= CONVERT(DATE, tip.Dt_Crtd_On) THEN ticd.Dt_Installment_Date
                              ELSE CONVERT(DATE, tip.Dt_Crtd_On) END,
                         @dtExecutionDate) = 0 
                AND tip.I_Status IN (1,3,0,2)
                AND ISNULL(ticd.Flag_IsAdvanceTax,'N') <> 'Y'
                AND tbcd.I_Brand_ID = @iBrandID

            UNION ALL

            SELECT  tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID, tsd.S_Student_ID,
                    tcm.S_Cost_Center,
                    (CASE WHEN ((ROUND(ABS(ISNULL(ticd.N_Amount_Due,0)),0) > ROUND(ABS(ISNULL(A.N_Amount_Paid,0)),0)) AND A.RcptSameDate=1) THEN CAST(ISNULL((((ROUND((ABS(ISNULL(ticd.N_Amount_Due,0))),0)-ROUND((ABS(ISNULL(A.N_Amount_Paid,0))),0))*
                        (SELECT tcfc.N_Tax_Rate FROM T_Tax_Country_Fee_Component AS tcfc
                         WHERE tcfc.I_Fee_Component_ID = ticd.I_Fee_Component_ID 
                           AND tidt.I_Tax_ID = tcfc.I_Tax_ID 
                           AND @dtExecutionDate BETWEEN Dt_Valid_From AND Dt_Valid_To))/100),0) AS decimal(18,2))

                     WHEN ((ROUND(ABS(ISNULL(ticd.N_Amount_Due,0)),0) = ROUND(ABS(ISNULL(A.N_Amount_Paid,0)),0)) AND A.RcptSameDate=1) 
                     THEN CAST(ISNULL((((ROUND((ABS(ISNULL(ticd.N_Amount_Due,0))),0)-ROUND((ABS(ISNULL(A.N_Amount_Paid,0))),0))*
                        (SELECT tcfc.N_Tax_Rate FROM T_Tax_Country_Fee_Component AS tcfc
                         WHERE tcfc.I_Fee_Component_ID = ticd.I_Fee_Component_ID 
                           AND tidt.I_Tax_ID = tcfc.I_Tax_ID 
                           AND @dtExecutionDate BETWEEN Dt_Valid_From AND Dt_Valid_To))/100),0) AS decimal(18,2))

                     WHEN ((ROUND(ABS(ISNULL(ticd.N_Amount_Due,0)),0) = ROUND(ABS(ISNULL(A.N_Amount_Paid,0)),0)) AND A.RcptSameDate=2) 
                     THEN CAST(ISNULL(((ROUND((ABS(ISNULL(ticd.N_Amount_Due,0))),0)*
                        (SELECT tcfc.N_Tax_Rate FROM T_Tax_Country_Fee_Component AS tcfc
                         WHERE tcfc.I_Fee_Component_ID = ticd.I_Fee_Component_ID 
                           AND tidt.I_Tax_ID = tcfc.I_Tax_ID 
                           AND @dtExecutionDate BETWEEN Dt_Valid_From AND Dt_Valid_To))/100),0) AS decimal(18,2))

                     WHEN ((ROUND(ABS(ISNULL(ticd.N_Amount_Due,0)),0) > ROUND(ABS(ISNULL(A.N_Amount_Paid,0)),0)) AND A.RcptSameDate=2) 
                     THEN CAST(ISNULL(((((ROUND((ABS(ISNULL(A.N_Amount_Paid,0))),0))+ROUND((ABS(ISNULL(ticd.N_Amount_Due,0))),0)-ROUND((ABS(ISNULL(A.N_Amount_Paid,0))),0))*
                        (SELECT tcfc.N_Tax_Rate FROM T_Tax_Country_Fee_Component AS tcfc
                         WHERE tcfc.I_Fee_Component_ID = ticd.I_Fee_Component_ID 
                           AND tidt.I_Tax_ID = tcfc.I_Tax_ID 
                           AND @dtExecutionDate BETWEEN Dt_Valid_From AND Dt_Valid_To))/100),0) AS decimal(18,2))

                     WHEN (( ROUND(ABS(ISNULL(A.N_Amount_Paid,0)),0) > ROUND(ABS(ISNULL(ticd.N_Amount_Due,0)),0)) AND A.RcptSameDate=2) 
                     THEN CAST(ISNULL(((ROUND((ABS(ISNULL(ticd.N_Amount_Due,0))),0)*
                        (SELECT tcfc.N_Tax_Rate FROM T_Tax_Country_Fee_Component AS tcfc
                         WHERE tcfc.I_Fee_Component_ID = ticd.I_Fee_Component_ID 
                           AND tidt.I_Tax_ID = tcfc.I_Tax_ID 
                           AND @dtExecutionDate BETWEEN Dt_Valid_From AND Dt_Valid_To))/100),0) AS decimal(18,2))

                     WHEN ROUND(ABS(ISNULL(A.N_Amount_Paid,0)),0) = 0 THEN
                     CAST(ISNULL((((ROUND(ABS(ISNULL(ticd.N_Amount_Due,0)),0))*
                        (SELECT tcfc.N_Tax_Rate FROM T_Tax_Country_Fee_Component AS tcfc
                         WHERE tcfc.I_Fee_COMPONENT_ID = ticd.I_Fee_Component_ID 
                           AND tidt.I_Tax_ID = tcfc.I_Tax_ID 
                           AND @dtExecutionDate BETWEEN Dt_Valid_From AND Dt_Valid_To))/100),0) AS decimal(18,2))
                     ELSE 0.00
                    END),
                    @dtExecutionDate, ticd.S_Invoice_Number, tttm.S_Transaction_Code
            FROM dbo.T_Invoice_Parent AS tip
            INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
            INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
            INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID
            INNER JOIN dbo.T_Invoice_Detail_Tax AS tidt ON ticd.I_Invoice_Detail_ID = tidt.I_Invoice_Detail_ID
            INNER JOIN T_Student_Detail tsd ON tsd.I_Student_Detail_ID = tip.I_Student_Detail_ID
            LEFT JOIN (
                SELECT RAmt.I_Invoice_Detail_ID, SUM(RAmt.N_Amount_Paid) AS N_Amount_Paid, (MAX(RAmt.RcptSameDate)) AS RcptSameDate
                FROM (
                    SELECT ticd1.I_Invoice_Detail_ID, ISNULL(trcd.N_Amount_Paid,0) AS N_Amount_Paid,
                        (CASE WHEN (CONVERT(DATE, MAX(trh.Dt_Receipt_Date)) < CONVERT(DATE, ticd1.Dt_Installment_Date)) THEN 1
                              WHEN (CONVERT(DATE, MAX(trh.Dt_Receipt_Date)) = CONVERT(DATE, ticd1.Dt_Installment_Date)) THEN 2 END) AS RcptSameDate
                    FROM dbo.T_Receipt_Header AS trh
                    INNER JOIN dbo.T_Receipt_Component_Detail AS trcd ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
                    INNER JOIN dbo.T_Receipt_Tax_Detail AS trtd ON trcd.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID
                    INNER JOIN dbo.T_Invoice_Child_Detail AS ticd1 ON trcd.I_Invoice_Detail_ID = ticd1.I_Invoice_Detail_ID
                    INNER JOIN T_Invoice_Child_Header AS ch ON ticd1.I_Invoice_Child_Header_ID = ch.I_Invoice_Child_HEADER_ID
                    INNER JOIN T_Invoice_Parent AS tip1 ON tip1.I_Invoice_Header_ID = ch.I_Invoice_HEADER_ID
                    WHERE (
                        (
                         (trh.I_Status = 1 AND (DATEDIFF(dd, CONVERT(DATE, trh.Dt_Receipt_Date), @dtExecutionDate) > 0))
                         OR (trh.I_Status = 0 AND ((DATEDIFF(dd, CONVERT(DATE, trh.Dt_Receipt_Date), @dtExecutionDate)) = 0))
                        )
                        OR
                        ((CONVERT(DATE, ticd1.Dt_Installment_Date) < (CASE WHEN CONVERT(DATE, trh.Dt_Upd_On) IS NULL THEN CONVERT(DATE, trh.Dt_Crtd_On) ELSE CONVERT(DATE, trh.Dt_Upd_On) END))
                         AND ((DATEDIFF(dd, CASE WHEN CONVERT(DATE, ticd1.Dt_Installment_Date) >= CONVERT(DATE, trh.Dt_Crtd_On) THEN CONVERT(DATE, ticd1.Dt_Installment_Date) ELSE CONVERT(DATE, trh.Dt_Crtd_On) END, @dtExecutionDate) = 0))
                        )
                    )
                    GROUP BY ticd1.I_Invoice_Detail_ID, ticd1.Dt_Installment_Date, trcd.N_Amount_Paid, trh.I_Receipt_Header_ID
                ) AS RAmt
                GROUP BY RAmt.I_Invoice_Detail_ID
            ) A
            ON ticd.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID
            INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tttm.I_Brand_ID = tbcd.I_Brand_ID
                AND ticd.I_Fee_Component_ID = tttm.I_Fee_COMPONENT_ID AND tidt.I_Tax_ID = tttm.I_Tax_ID 
                AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Status_ID IS NULL AND tttm.I_Status = 1
                AND tttm.I_Transaction_Nature_ID = 1
            WHERE
                DATEDIFF(dd,
                         CASE WHEN ticd.Dt_Installment_Date >= CONVERT(DATE, tip.Dt_Crtd_On) THEN ticd.Dt_Installment_Date
                              ELSE CONVERT(DATE, tip.Dt_Crtd_On) END,
                         @dtExecutionDate) = 0 
                AND tip.I_Status IN (1,3,0,2)
                AND ISNULL(ticd.Flag_IsAdvanceTax,'N') <> 'Y'
                AND tbcd.I_Brand_ID = @iBrandID

            UNION ALL

            SELECT  tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID, tsd.S_Student_ID,
                    tcm.S_Cost_Center, ABS(ISNULL(A.N_Tax_Value,0)), @dtExecutionDate, ticd.S_Invoice_Number, tttm.S_Transaction_Code
            FROM (
                SELECT taicd.I_Advance_Ref_Invoice_Child_Detail_ID, SUM(ISNULL(taidt.N_Tax_Value,0)) N_Tax_Value, taidt.I_Tax_ID
                FROM T_Invoice_Child_Detail icd
                INNER JOIN T_Advance_Invoice_Child_Detail_Mapping taicd ON icd.I_Invoice_Detail_ID = taicd.I_Advance_Ref_Invoice_CHILD_Detail_ID
                INNER JOIN T_Advance_Invoice_Detail_Tax_Mapping taidt ON taicd.I_Advance_Invoice_Child_Detail_Map_ID = taidt.I_Advance_Invoice_Detail_Map_ID
                WHERE ISNULL(icd.Flag_IsAdvanceTax,'N') = 'Y' 
                  AND DATEDIFF(dd, CONVERT(DATE, icd.Dt_Installment_Date), @dtExecutionDate) = 0
                GROUP BY taicd.I_Advance_Ref_Invoice_Child_Detail_ID, taidt.I_Tax_ID
            ) A
            INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON A.I_Advance_Ref_Invoice_Child_Detail_ID = ticd.I_Invoice_Detail_ID
            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON ticd.I_Invoice_Child_Header_ID = tich.I_Invoice_Child_HEADER_ID
            INNER JOIN dbo.T_Invoice_Parent AS tip ON tich.I_Invoice_HEADER_ID = tip.I_Invoice_Header_ID
            INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
            INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
            INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tttm.I_Brand_ID = tbcd.I_Brand_ID
                AND ticd.I_Fee_COMPONENT_ID = tttm.I_Fee_COMPONENT_ID AND A.I_Tax_ID = tttm.I_Tax_ID 
                AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Status_ID IS NULL AND tttm.I_Status = 1
                AND tttm.I_Transaction_Nature_ID = 1
            INNER JOIN T_Student_Detail tsd ON tsd.I_Student_Detail_ID = tip.I_Student_Detail_ID
            WHERE tbcd.I_Brand_ID = @iBrandID

            UNION ALL

            SELECT  tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID, tsd.S_Student_ID,
                    tcm.S_Cost_Center, ABS(ISNULL(tcnidt.N_Tax_Value,0)), @dtExecutionDate, ticd.S_Invoice_Number, tttm.S_Transaction_Code
            FROM dbo.T_Invoice_Parent AS tip
            INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
            INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
            INNER JOIN T_Credit_Note_Invoice_Child_Detail tcnicd ON tip.I_Invoice_Header_ID = tcnicd.I_Invoice_Header_ID
            INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tcnicd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
            INNER JOIN dbo.T_Credit_Note_Invoice_Child_Detail_Tax AS tcnidt ON ticd.I_Invoice_Detail_ID = tcnidt.I_Invoice_Detail_ID
            INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON ticd.I_Fee_COMPONENT_ID = tttm.I_Fee_COMPONENT_ID
                AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Brand_ID = tbcd.I_Brand_ID 
                AND tcnidt.I_Tax_ID = tttm.I_Tax_ID AND tttm.I_Status_ID IS NULL AND tttm.I_Status = 1
                AND tttm.I_Transaction_Nature_ID = 1
            INNER JOIN T_Student_Detail tsd ON tsd.I_Student_Detail_ID = tip.I_Student_Detail_ID
            WHERE DATEDIFF(dd, tcnicd.Dt_Crtd_On, @dtExecutionDate) = 0
              AND ISNULL(ticd.Flag_IsAdvanceTax,'N') = 'Y'
              AND tbcd.I_Brand_ID = @iBrandID;

            SET @dtExecutionDate = DATEADD(dd, 1, @dtExecutionDate);
        END; 

        SELECT * FROM #temp;

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

    --SELECT @StatusFlag AS StatusFlag, @Message AS Message;
END;