CREATE PROCEDURE [REPORT].[uspGetCollectionRegisterBreakup_InvoiceNew]
    (
      @sHierarchyList VARCHAR(MAX) ,
      @iBrandID INT ,
      @startDate DATE ,
      @endDate DATE

    )
AS 
    BEGIN

        SELECT  RH.I_Centre_Id ,
                TCHND.S_Center_Name ,
                SD.I_Student_Detail_ID ,
                SD.S_Student_ID ,
                SD.S_First_Name + ' ' + ISNULL(SD.S_Middle_Name, '') + ' '
                + SD.S_Last_Name AS "NAME" ,
                FCM.S_Component_Name ,
                RH.S_Receipt_No ,
                ISNULL(RCD.N_Amount_Paid, 0.0) AS "Amount_Paid" ,
                SUM(ISNULL(RTD.N_Tax_Paid, 0.0)) AS "Tax_Paid" ,
--TM.S_Tax_Desc,
                DATENAME(m,RH.Dt_Receipt_Date)+CAST(DATEPART(YYYY,RH.Dt_Receipt_Date) AS VARCHAR) AS ReceiptDate ,
                RH.S_Bank_Name ,
                RH.S_ChequeDD_No ,
                RH.Dt_ChequeDD_Date ,
                RH.S_Narration ,
                PM.S_PaymentMode_Name ,
                RH.I_Status ,
                RH.Dt_Crtd_On ,
                RH.Dt_Upd_On ,
                TICD.Dt_Installment_Date ,
                NULL
        FROM    T_Receipt_Header RH
                LEFT JOIN T_Receipt_Component_Detail RCD ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
                INNER JOIN T_Student_Detail SD ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID
                INNER JOIN T_Invoice_Child_Detail ICD ON ICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
                INNER JOIN T_Fee_Component_Master FCM ON FCM.I_Fee_Component_ID = ICD.I_Fee_Component_ID
                LEFT JOIN T_Receipt_Tax_Detail RTD ON RCD.I_Receipt_Comp_Detail_ID = RTD.I_Receipt_Comp_Detail_ID
                LEFT JOIN T_Tax_Master TM ON TM.I_Tax_ID = RTD.I_Tax_ID
                INNER JOIN T_Center_Hierarchy_Name_Details TCHND ON TCHND.I_Center_ID = RH.I_Centre_Id
                LEFT JOIN T_PaymentMode_Master PM ON PM.I_PaymentMode_ID = RH.I_PaymentMode_ID
                INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
        WHERE   FCM.I_Brand_ID = @iBrandID
                AND RH.I_Centre_Id IN (
                SELECT  CenterList.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                   CAST(@iBrandID AS INT)) CenterList )
                AND DATEDIFF(dd, @startDate, Dt_Receipt_Date) >= 0
                AND DATEDIFF(dd, @endDate, Dt_Receipt_Date) <= 0
--and RCD.N_Amount_Paid>0.5
GROUP BY        RH.I_Centre_Id ,
                TCHND.S_Center_Name ,
                SD.I_Student_Detail_ID ,
                SD.S_Student_ID ,
                SD.S_First_Name + ' ' + ISNULL(SD.S_Middle_Name, '') + ' '
                + SD.S_Last_Name ,
                FCM.S_Component_Name ,
                RH.S_Receipt_No ,
                RCD.N_Amount_Paid ,
--SUM(ROUND(RTD.N_Tax_Paid,0.0)) AS "Tax_Paid",
--TM.S_Tax_Desc,
                DATENAME(m,RH.Dt_Receipt_Date)+CAST(DATEPART(YYYY,RH.Dt_Receipt_Date) AS VARCHAR) ,
                RH.S_Bank_Name ,
                RH.S_ChequeDD_No ,
                RH.Dt_ChequeDD_Date ,
                RH.S_Narration ,
                PM.S_PaymentMode_Name ,
                RH.I_Status ,
                RH.Dt_Crtd_On ,
                RH.Dt_Upd_On ,
                TICD.Dt_Installment_Date ,
                RH.S_Cancellation_Reason
        UNION ALL
        SELECT  RH.I_Centre_Id ,
                TCHND.S_Center_Name ,
                SD.I_Student_Detail_ID ,
                SD.S_Student_ID ,
                SD.S_First_Name + ' ' + ISNULL(SD.S_Middle_Name, '') + ' '
                + SD.S_Last_Name AS "NAME" ,
                FCM.S_Component_Name ,
                RH.S_Receipt_No ,
                -ISNULL(RCD.N_Amount_Paid, 0.0) AS "Amount_Paid" ,
                -SUM(ISNULL(RTD.N_Tax_Paid, 0.0)) ,
--TM.S_Tax_Desc,
                DATENAME(m,RH.Dt_Upd_On)+CAST(DATEPART(YYYY,RH.Dt_Upd_On) AS VARCHAR) AS ReceiptDate ,
                RH.S_Bank_Name ,
                RH.S_ChequeDD_No ,
                RH.Dt_ChequeDD_Date ,
                RH.S_Narration ,
                PM.S_PaymentMode_Name ,
                RH.I_Status ,
                RH.Dt_Crtd_On ,
                RH.Dt_Upd_On ,
                TICD.Dt_Installment_Date ,
                RH.S_Cancellation_Reason
        FROM    T_Receipt_Header RH
                LEFT JOIN T_Receipt_Component_Detail RCD ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
                INNER JOIN T_Student_Detail SD ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID
                INNER JOIN T_Invoice_Child_Detail ICD ON ICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
                INNER JOIN T_Fee_Component_Master FCM ON FCM.I_Fee_Component_ID = ICD.I_Fee_Component_ID
                LEFT JOIN T_Receipt_Tax_Detail RTD ON RCD.I_Receipt_Comp_Detail_ID = RTD.I_Receipt_Comp_Detail_ID
                LEFT JOIN T_Tax_Master TM ON TM.I_Tax_ID = RTD.I_Tax_ID
                INNER JOIN T_Center_Hierarchy_Name_Details TCHND ON TCHND.I_Center_ID = RH.I_Centre_Id
                LEFT JOIN T_PaymentMode_Master PM ON PM.I_PaymentMode_ID = RH.I_PaymentMode_ID
                INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
        WHERE   FCM.I_Brand_ID = @iBrandID
                AND RH.I_Centre_Id IN (
                SELECT  CenterList.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                   CAST(@iBrandID AS INT)) CenterList )
                AND DATEDIFF(dd, @startDate, RH.Dt_Upd_On) >= 0
                AND DATEDIFF(dd, @endDate, RH.Dt_Upd_On) <= 0
--and RCD.N_Amount_Paid>0.5
                AND RH.I_Status = 0
        GROUP BY RH.I_Centre_Id ,
                TCHND.S_Center_Name ,
                SD.I_Student_Detail_ID ,
                SD.S_Student_ID ,
                SD.S_First_Name + ' ' + ISNULL(SD.S_Middle_Name, '') + ' '
                + SD.S_Last_Name ,
                FCM.S_Component_Name ,
                RH.S_Receipt_No ,
                RCD.N_Amount_Paid ,
--SUM(ROUND(RTD.N_Tax_Paid,0.0)) AS "Tax_Paid",
--TM.S_Tax_Desc,
                DATENAME(m,RH.Dt_Receipt_Date)+CAST(DATEPART(YYYY,RH.Dt_Receipt_Date) AS VARCHAR) ,
                RH.S_Bank_Name ,
                RH.S_ChequeDD_No ,
                RH.Dt_ChequeDD_Date ,
                RH.S_Narration ,
                PM.S_PaymentMode_Name ,
                RH.I_Status ,
                RH.Dt_Crtd_On ,
                RH.Dt_Upd_On ,
                TICD.Dt_Installment_Date ,
                RH.S_Cancellation_Reason
        ORDER BY SD.S_First_Name + ' ' + ISNULL(SD.S_Middle_Name, '') + ' '
                + SD.S_Last_Name ,
                S_Receipt_No


    END
