CREATE PROCEDURE [REPORT].[uspGetCollectionRegisterBreakup_OnAccount]
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
                + SD.S_Last_Name AS NAME ,
                SM.S_Status_Desc ,
                RH.S_Receipt_No ,
                RH.N_Receipt_Amount ,
                RH.N_Tax_Amount ,
                RH.Dt_Receipt_Date ,
                RH.S_Bank_Name ,
                RH.S_ChequeDD_No ,
                RH.Dt_ChequeDD_Date ,
                PM.S_PaymentMode_Name ,
                RH.S_Narration ,
                RH.I_Status ,
                RH.Dt_Crtd_On ,
                RH.Dt_Upd_On,
                ISNULL(TIOAD.S_Invoice_Number,'') AS InvoiceNumber
        FROM    T_Receipt_Header RH
                LEFT JOIN T_Status_Master SM ON SM.I_Status_Value = RH.I_Receipt_Type
                INNER JOIN T_Student_Detail SD ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID
                INNER JOIN T_Center_Hierarchy_Name_Details TCHND ON TCHND.I_Center_ID = RH.I_Centre_Id
                INNER JOIN T_PaymentMode_Master PM ON PM.I_PaymentMode_ID = RH.I_PaymentMode_ID
                LEFT JOIN dbo.T_Invoice_OnAccount_Details AS TIOAD ON TIOAD.I_Receipt_Header_ID = RH.I_Receipt_Header_ID AND (TIOAD.S_Invoice_Type='RI' OR TIOAD.S_Invoice_Type='BS')
        WHERE   S_Status_Type = 'ReceiptType'
                AND RH.I_Receipt_Type <> 2
                AND SM.I_Brand_ID = @iBrandID
                AND RH.I_Centre_Id IN (
                SELECT  CenterList.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                   CAST(@iBrandID AS INT)) CenterList )
                AND DATEDIFF(dd, @startDate, RH.Dt_Receipt_Date) >= 0
                AND DATEDIFF(dd, @endDate, RH.Dt_Receipt_Date) <= 0
        UNION ALL
        SELECT  RH.I_Centre_Id ,
                TCHND.S_Center_Name ,
                SD.I_Student_Detail_ID ,
                SD.S_Student_ID ,
                SD.S_First_Name + ' ' + ISNULL(SD.S_Middle_Name, '') + ' '
                + SD.S_Last_Name AS NAME ,
                SM.S_Status_Desc ,
                RH.S_Receipt_No ,
                -RH.N_Receipt_Amount ,
                -RH.N_Tax_Amount ,
                RH.Dt_Receipt_Date ,
                RH.S_Bank_Name ,
                RH.S_ChequeDD_No ,
                RH.Dt_ChequeDD_Date ,
                PM.S_PaymentMode_Name ,
                RH.S_Narration ,
                RH.I_Status ,
                RH.Dt_Crtd_On ,
                RH.Dt_Upd_On,
                ISNULL(TIOAD.S_Invoice_Number,'') AS InvoiceNumber
        FROM    T_Receipt_Header RH
                LEFT JOIN T_Status_Master SM ON SM.I_Status_Value = RH.I_Receipt_Type
                INNER JOIN T_Student_Detail SD ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID
                INNER JOIN T_Center_Hierarchy_Name_Details TCHND ON TCHND.I_Center_ID = RH.I_Centre_Id
                INNER JOIN T_PaymentMode_Master PM ON PM.I_PaymentMode_ID = RH.I_PaymentMode_ID
                LEFT JOIN dbo.T_Invoice_OnAccount_Details AS TIOAD ON TIOAD.I_Receipt_Header_ID = RH.I_Receipt_Header_ID AND (TIOAD.S_Invoice_Type='RC')
        WHERE   S_Status_Type = 'ReceiptType'
                AND RH.I_Receipt_Type <> 2
                AND SM.I_Brand_ID = @iBrandID
                AND RH.I_Status = 0
                AND RH.I_Centre_Id IN (
                SELECT  CenterList.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                   CAST(@iBrandID AS INT)) CenterList )
                AND DATEDIFF(dd, @startDate, RH.Dt_Upd_On) >= 0
                AND DATEDIFF(dd, @endDate, RH.Dt_Upd_On) <= 0
        UNION ALL
        SELECT  RH.I_Centre_Id ,
                TCHND.S_Center_Name ,
                TERD.I_Enquiry_Regn_ID ,
                NULL ,
                TERD.S_First_Name + ' ' + ISNULL(TERD.S_Middle_Name, '') + ' '
                + TERD.S_Last_Name AS NAME ,
                SM.S_Status_Desc ,
                RH.S_Receipt_No ,
                RH.N_Receipt_Amount ,
                RH.N_Tax_Amount ,
                RH.Dt_Receipt_Date ,
                RH.S_Bank_Name ,
                RH.S_ChequeDD_No ,
                RH.Dt_ChequeDD_Date ,
                PM.S_PaymentMode_Name ,
                RH.S_Narration ,
                RH.I_Status ,
                RH.Dt_Crtd_On ,
                RH.Dt_Upd_On,
                ISNULL(TIOAD.S_Invoice_Number,'') AS InvoiceNumber
        FROM    T_Receipt_Header RH
                LEFT JOIN T_Status_Master SM ON SM.I_Status_Value = RH.I_Receipt_Type
                INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON RH.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
                INNER JOIN T_Center_Hierarchy_Name_Details TCHND ON TCHND.I_Center_ID = RH.I_Centre_Id
                INNER JOIN T_PaymentMode_Master PM ON PM.I_PaymentMode_ID = RH.I_PaymentMode_ID
                LEFT JOIN dbo.T_Invoice_OnAccount_Details AS TIOAD ON TIOAD.I_Receipt_Header_ID = RH.I_Receipt_Header_ID AND (TIOAD.S_Invoice_Type='RI' OR TIOAD.S_Invoice_Type='BS')
        WHERE   S_Status_Type = 'ReceiptType'
                AND RH.I_Receipt_Type <> 2
                AND SM.I_Brand_ID = @iBrandID
                AND RH.I_Centre_Id IN (
                SELECT  CenterList.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                   CAST(@iBrandID AS INT)) CenterList )
                AND DATEDIFF(dd, @startDate, RH.Dt_Receipt_Date) >= 0
                AND DATEDIFF(dd, @endDate, RH.Dt_Receipt_Date) <= 0
        UNION ALL
        SELECT  RH.I_Centre_Id ,
                TCHND.S_Center_Name ,
                TERD.I_Enquiry_Regn_ID ,
                NULL ,
                TERD.S_First_Name + ' ' + ISNULL(TERD.S_Middle_Name, '') + ' '
                + TERD.S_Last_Name AS NAME ,
                SM.S_Status_Desc ,
                RH.S_Receipt_No ,
                -RH.N_Receipt_Amount ,
                -RH.N_Tax_Amount ,
                RH.Dt_Receipt_Date ,
                RH.S_Bank_Name ,
                RH.S_ChequeDD_No ,
                RH.Dt_ChequeDD_Date ,
                PM.S_PaymentMode_Name ,
                RH.S_Narration ,
                RH.I_Status ,
                RH.Dt_Crtd_On ,
                RH.Dt_Upd_On,
                ISNULL(TIOAD.S_Invoice_Number,'') AS InvoiceNumber
        FROM    T_Receipt_Header RH
                LEFT JOIN T_Status_Master SM ON SM.I_Status_Value = RH.I_Receipt_Type
                INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TERD.I_Enquiry_Regn_ID = RH.I_Enquiry_Regn_ID
                INNER JOIN T_Center_Hierarchy_Name_Details TCHND ON TCHND.I_Center_ID = RH.I_Centre_Id
                INNER JOIN T_PaymentMode_Master PM ON PM.I_PaymentMode_ID = RH.I_PaymentMode_ID
                LEFT JOIN dbo.T_Invoice_OnAccount_Details AS TIOAD ON TIOAD.I_Receipt_Header_ID = RH.I_Receipt_Header_ID AND (TIOAD.S_Invoice_Type='RC')
        WHERE   S_Status_Type = 'ReceiptType'
                AND RH.I_Receipt_Type <> 2
                AND SM.I_Brand_ID = @iBrandID
                AND RH.I_Status = 0
                AND RH.I_Centre_Id IN (
                SELECT  CenterList.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                   CAST(@iBrandID AS INT)) CenterList )
                AND DATEDIFF(dd, @startDate, RH.Dt_Upd_On) >= 0
                AND DATEDIFF(dd, @endDate, RH.Dt_Upd_On) <= 0
        ORDER BY
--RH.I_Status,
--RH.Dt_Crtd_On,
                SD.S_First_Name + ' ' + ISNULL(SD.S_Middle_Name, '') + ' '
                + SD.S_Last_Name ,
                RH.S_Receipt_No

    END
