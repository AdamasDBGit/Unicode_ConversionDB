

/*****Created by Akash Saha on 5.6.2017*****/

CREATE PROCEDURE [REPORT].[uspGetChequeAndCardDetailsReport]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @dtStartDate DATE ,
      @dtEndDate DATE
    )
AS
    BEGIN
	
	--settled--
        SELECT  TBM.S_Brand_Name ,
                TCHND.S_Center_Name ,
                TSD.S_Student_ID AS StudentOrEnquiryID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TRH.I_Receipt_Header_ID ,
                TRH.S_Receipt_No ,
                TRH.Dt_Crtd_On AS ReceiptDate ,
                TRH.Dt_Upd_On AS UpdateDate ,
                TRH.S_ChequeDD_No AS InstrumentNo ,
                TRH.S_Bank_Name ,
                TRH.S_Branch_Name ,
                TRH.Dt_ChequeDD_Date ,
                TRH.Bank_Account_Name ,
                TRH.Dt_Deposit_Date AS DepositDate ,
                ISNULL(TRH.N_Receipt_Amount, 0) + ISNULL(TRH.N_Tax_Amount, 0) AS TotalAmount ,
                'SettledChequeDD' AS Category
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Brand_Center_Details TBCD ON TRH.I_Centre_Id = TBCD.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_PaymentMode_Master TPMM ON TRH.I_PaymentMode_ID = TPMM.I_PaymentMode_ID
                INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
        WHERE   TRH.I_PaymentMode_ID IN ( 2, 3, 4,27 )
                AND ( CONVERT(DATE, TRH.Dt_Deposit_Date) BETWEEN @dtStartDate
                                                         AND  @dtEndDate )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
        UNION ALL
        SELECT  TBM.S_Brand_Name ,
                TCHND.S_Center_Name ,
                CAST(TSD.I_Enquiry_Regn_ID AS VARCHAR) AS StudentOrEnquiryID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TRH.I_Receipt_Header_ID ,
                TRH.S_Receipt_No ,
                TRH.Dt_Crtd_On AS ReceiptDate ,
                TRH.Dt_Upd_On AS UpdateDate ,
                TRH.S_ChequeDD_No AS InstrumentNo ,
                TRH.S_Bank_Name ,
                TRH.S_Branch_Name ,
                TRH.Dt_ChequeDD_Date ,
                TRH.Bank_Account_Name ,
                TRH.Dt_Deposit_Date AS DepositDate ,
                ISNULL(TRH.N_Receipt_Amount, 0) + ISNULL(TRH.N_Tax_Amount, 0) AS TotalAmount ,
                'SettledChequeDD' AS Category
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Brand_Center_Details TBCD ON TRH.I_Centre_Id = TBCD.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_PaymentMode_Master TPMM ON TRH.I_PaymentMode_ID = TPMM.I_PaymentMode_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail TSD ON TRH.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
        WHERE   TRH.I_PaymentMode_ID IN ( 2, 3, 4,27 )
                AND ( CONVERT(DATE, TRH.Dt_Deposit_Date) BETWEEN @dtStartDate
                                                         AND  @dtEndDate )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
        UNION ALL                                   
                                                   
                                                   
                                                   
                --bounce--
        SELECT  TBM.S_Brand_Name ,
                TCHND.S_Center_Name ,
                TSD.S_Student_ID AS StudentOrEnquiryID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TRH.I_Receipt_Header_ID ,
                TRH.S_Receipt_No ,
                TRH.Dt_Crtd_On AS ReceiptDate ,
                TRH.Dt_Upd_On AS UpdateDate ,
                TRH.S_ChequeDD_No AS InstrumentNo ,
                TRH.S_Bank_Name ,
                TRH.S_Branch_Name ,
                TRH.Dt_ChequeDD_Date ,
                TRH.Bank_Account_Name ,
                TRH.Dt_Deposit_Date AS DepositDate ,
                ISNULL(TRH.N_Receipt_Amount, 0) + ISNULL(TRH.N_Tax_Amount, 0) AS TotalAmount ,
                'BounceChequeDD' AS Category
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Brand_Center_Details TBCD ON TRH.I_Centre_Id = TBCD.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_PaymentMode_Master TPMM ON TRH.I_PaymentMode_ID = TPMM.I_PaymentMode_ID
                INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
        WHERE   TRH.I_PaymentMode_ID IN ( 2, 3, 4,27 )
                AND ( CONVERT(DATE, TRH.Dt_Upd_On) BETWEEN @dtStartDate
                                                   AND     @dtEndDate )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND TRH.I_Status = 0
                AND TRH.Dt_Deposit_Date IS NOT NULL
        UNION ALL
        SELECT  TBM.S_Brand_Name ,
                TCHND.S_Center_Name ,
                CAST(TSD.I_Enquiry_Regn_ID AS VARCHAR) AS StudentOrEnquiryID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TRH.I_Receipt_Header_ID ,
                TRH.S_Receipt_No ,
                TRH.Dt_Crtd_On AS ReceiptDate ,
                TRH.Dt_Upd_On AS UpdateDate ,
                TRH.S_ChequeDD_No AS InstrumentNo ,
                TRH.S_Bank_Name ,
                TRH.S_Branch_Name ,
                TRH.Dt_ChequeDD_Date ,
                TRH.Bank_Account_Name ,
                TRH.Dt_Deposit_Date AS DepositDate ,
                ISNULL(TRH.N_Receipt_Amount, 0) + ISNULL(TRH.N_Tax_Amount, 0) AS TotalAmount ,
                'BounceChequeDD' AS Category
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Brand_Center_Details TBCD ON TRH.I_Centre_Id = TBCD.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_PaymentMode_Master TPMM ON TRH.I_PaymentMode_ID = TPMM.I_PaymentMode_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail TSD ON TRH.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
        WHERE   TRH.I_PaymentMode_ID IN ( 2, 3, 4,27 )
                AND ( CONVERT(DATE, TRH.Dt_Upd_On) BETWEEN @dtStartDate
                                                   AND     @dtEndDate )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND TRH.I_Status = 0
                AND TRH.Dt_Deposit_Date IS NOT NULL
        UNION ALL
                
                --unsettled
        SELECT  TBM.S_Brand_Name ,
                TCHND.S_Center_Name ,
                TSD.S_Student_ID AS StudentOrEnquiryID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TRH.I_Receipt_Header_ID ,
                TRH.S_Receipt_No ,
                TRH.Dt_Crtd_On AS ReceiptDate ,
                TRH.Dt_Upd_On AS UpdateDate ,
                TRH.S_ChequeDD_No AS InstrumentNo ,
                TRH.S_Bank_Name ,
                TRH.S_Branch_Name ,
                TRH.Dt_ChequeDD_Date ,
                TRH.Bank_Account_Name ,
                TRH.Dt_Deposit_Date AS DepositDate ,
                ISNULL(TRH.N_Receipt_Amount, 0) + ISNULL(TRH.N_Tax_Amount, 0) AS TotalAmount ,
                'UnsettledChequeDD' AS Category
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Brand_Center_Details TBCD ON TRH.I_Centre_Id = TBCD.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_PaymentMode_Master TPMM ON TRH.I_PaymentMode_ID = TPMM.I_PaymentMode_ID
                INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
        WHERE   TRH.I_PaymentMode_ID IN ( 2, 3, 4,27 )
                AND ( CONVERT(DATE, TRH.Dt_Receipt_Date) BETWEEN @dtStartDate
                                                         AND  @dtEndDate )
                AND ( TRH.Dt_Deposit_Date IS NULL
                      OR CONVERT(DATE, TRH.Dt_Deposit_Date) > @dtEndDate
                    )
                AND ( TRH.I_Status = 1
                      OR ( TRH.I_Status = 0
                           AND CONVERT(DATE, TRH.Dt_Upd_On) > @dtEndDate
                         )
                    )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                --AND TRH.I_Status=0 AND TRH.Dt_Deposit_Date IS NOT NULL                                   
        UNION ALL
        SELECT  TBM.S_Brand_Name ,
                TCHND.S_Center_Name ,
                CAST(TSD.I_Enquiry_Regn_ID AS VARCHAR) AS StudentOrEnquiryID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TRH.I_Receipt_Header_ID ,
                TRH.S_Receipt_No ,
                TRH.Dt_Crtd_On AS ReceiptDate ,
                TRH.Dt_Upd_On AS UpdateDate ,
                TRH.S_ChequeDD_No AS InstrumentNo ,
                TRH.S_Bank_Name ,
                TRH.S_Branch_Name ,
                TRH.Dt_ChequeDD_Date ,
                TRH.Bank_Account_Name ,
                TRH.Dt_Deposit_Date AS DepositDate ,
                ISNULL(TRH.N_Receipt_Amount, 0) + ISNULL(TRH.N_Tax_Amount, 0) AS TotalAmount ,
                'UnsettledChequeDD' AS Category
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Brand_Center_Details TBCD ON TRH.I_Centre_Id = TBCD.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_PaymentMode_Master TPMM ON TRH.I_PaymentMode_ID = TPMM.I_PaymentMode_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail TSD ON TRH.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
        WHERE   TRH.I_PaymentMode_ID IN ( 2, 3, 4,27 )
                AND ( CONVERT(DATE, TRH.Dt_Receipt_Date) BETWEEN @dtStartDate
                                                         AND  @dtEndDate )
                AND ( TRH.Dt_Deposit_Date IS NULL
                      OR CONVERT(DATE, TRH.Dt_Deposit_Date) > @dtEndDate
                    )
                AND ( TRH.I_Status = 1
                      OR ( TRH.I_Status = 0
                           AND CONVERT(DATE, TRH.Dt_Upd_On) > @dtEndDate
                         )
                    )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                --AND TRH.I_Status=0 AND TRH.Dt_Deposit_Date IS NOT NULL
        UNION ALL
                
                --Collection Prior Current Month
        SELECT  TBM.S_Brand_Name ,
                TCHND.S_Center_Name ,
                TSD.S_Student_ID AS StudentOrEnquiryID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TRH.I_Receipt_Header_ID ,
                TRH.S_Receipt_No ,
                TRH.Dt_Crtd_On AS ReceiptDate ,
                TRH.Dt_Upd_On AS UpdateDate ,
                TRH.S_ChequeDD_No AS InstrumentNo ,
                TRH.S_Bank_Name ,
                TRH.S_Branch_Name ,
                TRH.Dt_ChequeDD_Date ,
                TRH.Bank_Account_Name ,
                TRH.Dt_Deposit_Date AS DepositDate ,
                ISNULL(TRH.N_Receipt_Amount, 0) + ISNULL(TRH.N_Tax_Amount, 0) AS TotalAmount ,
                'CollectionPriorChequeDD' AS Category
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Brand_Center_Details TBCD ON TRH.I_Centre_Id = TBCD.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_PaymentMode_Master TPMM ON TRH.I_PaymentMode_ID = TPMM.I_PaymentMode_ID
                INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
        WHERE   TRH.I_PaymentMode_ID IN ( 2, 3, 4,27 )
                AND ( CONVERT(DATE, TRH.Dt_Receipt_Date) < @dtStartDate )
                AND ( CONVERT(DATE, TRH.Dt_Deposit_Date) BETWEEN @dtStartDate
                                                         AND  @dtEndDate )
                AND ( TRH.I_Status = 1
                      OR ( TRH.I_Status = 0
                           AND CONVERT(DATE, TRH.Dt_Upd_On) >= @dtStartDate
                         )
                    )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                --AND TRH.I_Status=0 AND TRH.Dt_Deposit_Date IS NOT NULL                                   
        UNION ALL
        SELECT  TBM.S_Brand_Name ,
                TCHND.S_Center_Name ,
                CAST(TSD.I_Enquiry_Regn_ID AS VARCHAR) AS StudentOrEnquiryID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TRH.I_Receipt_Header_ID ,
                TRH.S_Receipt_No ,
                TRH.Dt_Crtd_On AS ReceiptDate ,
                TRH.Dt_Upd_On AS UpdateDate ,
                TRH.S_ChequeDD_No AS InstrumentNo ,
                TRH.S_Bank_Name ,
                TRH.S_Branch_Name ,
                TRH.Dt_ChequeDD_Date ,
                TRH.Bank_Account_Name ,
                TRH.Dt_Deposit_Date AS DepositDate ,
                ISNULL(TRH.N_Receipt_Amount, 0) + ISNULL(TRH.N_Tax_Amount, 0) AS TotalAmount ,
                'CollectionPriorChequeDD' AS Category
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Brand_Center_Details TBCD ON TRH.I_Centre_Id = TBCD.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_PaymentMode_Master TPMM ON TRH.I_PaymentMode_ID = TPMM.I_PaymentMode_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail TSD ON TRH.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
        WHERE   TRH.I_PaymentMode_ID IN ( 2, 3, 4,27 )
                AND ( CONVERT(DATE, TRH.Dt_Receipt_Date) < @dtStartDate )
                AND ( CONVERT(DATE, TRH.Dt_Deposit_Date) BETWEEN @dtStartDate
                                                         AND  @dtEndDate )
                AND ( TRH.I_Status = 1
                      OR ( TRH.I_Status = 0
                           AND CONVERT(DATE, TRH.Dt_Upd_On) >= @dtStartDate
                         )
                    )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
        UNION ALL
         
         --Collection Reversal
        SELECT  TBM.S_Brand_Name ,
                TCHND.S_Center_Name ,
                TSD.S_Student_ID AS StudentOrEnquiryID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TRH.I_Receipt_Header_ID ,
                TRH.S_Receipt_No ,
                TRH.Dt_Crtd_On AS ReceiptDate ,
                TRH.Dt_Upd_On AS UpdateDate ,
                TRH.S_ChequeDD_No AS InstrumentNo ,
                TRH.S_Bank_Name ,
                TRH.S_Branch_Name ,
                TRH.Dt_ChequeDD_Date ,
                TRH.Bank_Account_Name ,
                TRH.Dt_Deposit_Date AS DepositDate ,
                ISNULL(TRH.N_Receipt_Amount, 0) + ISNULL(TRH.N_Tax_Amount, 0) AS TotalAmount ,
                'CollectionReversalChequeDD' AS Category
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Brand_Center_Details TBCD ON TRH.I_Centre_Id = TBCD.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_PaymentMode_Master TPMM ON TRH.I_PaymentMode_ID = TPMM.I_PaymentMode_ID
                INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
        WHERE   TRH.I_PaymentMode_ID IN ( 2, 3, 4,27 )
                AND ( CONVERT(DATE, TRH.Dt_Receipt_Date) < @dtStartDate )
                AND TRH.Dt_Deposit_Date IS NULL
                AND ( (TRH.I_Status = 0
                      AND CONVERT(DATE, TRH.Dt_Upd_On) BETWEEN @dtStartDate
                                                       AND    @dtEndDate)
                    )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                --AND TRH.I_Status=0 AND TRH.Dt_Deposit_Date IS NOT NULL                                   
        UNION ALL
        SELECT  TBM.S_Brand_Name ,
                TCHND.S_Center_Name ,
                CAST(TSD.I_Enquiry_Regn_ID AS VARCHAR) AS StudentOrEnquiryID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TRH.I_Receipt_Header_ID ,
                TRH.S_Receipt_No ,
                TRH.Dt_Crtd_On AS ReceiptDate ,
                TRH.Dt_Upd_On AS UpdateDate ,
                TRH.S_ChequeDD_No AS InstrumentNo ,
                TRH.S_Bank_Name ,
                TRH.S_Branch_Name ,
                TRH.Dt_ChequeDD_Date ,
                TRH.Bank_Account_Name ,
                TRH.Dt_Deposit_Date AS DepositDate ,
                ISNULL(TRH.N_Receipt_Amount, 0) + ISNULL(TRH.N_Tax_Amount, 0) AS TotalAmount ,
                'CollectionReversalChequeDD' AS Category
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Brand_Center_Details TBCD ON TRH.I_Centre_Id = TBCD.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_PaymentMode_Master TPMM ON TRH.I_PaymentMode_ID = TPMM.I_PaymentMode_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail TSD ON TRH.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
        WHERE   TRH.I_PaymentMode_ID IN ( 2, 3, 4,27 )
                AND ( CONVERT(DATE, TRH.Dt_Receipt_Date) < @dtStartDate )
                AND TRH.Dt_Deposit_Date IS NULL
                AND ( (TRH.I_Status = 0
                      AND CONVERT(DATE, TRH.Dt_Upd_On) BETWEEN @dtStartDate
                                                       AND    @dtEndDate)
                    )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
        UNION ALL
         
         --settled DebitCredit
        SELECT  TBM.S_Brand_Name ,
                TCHND.S_Center_Name ,
                TSD.S_Student_ID AS StudentOrEnquiryID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TRH.I_Receipt_Header_ID ,
                TRH.S_Receipt_No ,
                TRH.Dt_Crtd_On AS ReceiptDate ,
                TRH.Dt_Upd_On AS UpdateDate ,
                TRH.S_ChequeDD_No AS InstrumentNo ,
                TRH.S_Bank_Name ,
                TRH.S_Branch_Name ,
                TRH.Dt_ChequeDD_Date ,
                TRH.Bank_Account_Name ,
                TRH.Dt_Deposit_Date AS DepositDate ,
                dbo.fnGetReceiptAmtExcldConvenienceCharge(( ISNULL(TRH.N_Receipt_Amount,
                                                              0)
                                                            + ISNULL(TRH.N_Tax_Amount,
                                                              0) ),
                                                          TBM.I_Brand_ID,
                                                          TRH.Dt_Receipt_Date,
                                                          TRH.I_PaymentMode_ID,
                                                          NULL) AS TotalAmount ,
                'SettledDebitCredit' AS Category
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Brand_Center_Details TBCD ON TRH.I_Centre_Id = TBCD.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_PaymentMode_Master TPMM ON TRH.I_PaymentMode_ID = TPMM.I_PaymentMode_ID
                INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
        WHERE   TRH.I_PaymentMode_ID IN ( 13,14,15,16,17,19,20,21,22,23,24,25 )
                AND ( CONVERT(DATE, TRH.Dt_Deposit_Date) >= @dtStartDate
                                                         AND CONVERT(DATE, TRH.Dt_Deposit_Date)< DATEADD(d,1,@dtEndDate) )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
        UNION ALL
        SELECT  TBM.S_Brand_Name ,
                TCHND.S_Center_Name ,
                CAST(TSD.I_Enquiry_Regn_ID AS VARCHAR) AS StudentOrEnquiryID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TRH.I_Receipt_Header_ID ,
                TRH.S_Receipt_No ,
                TRH.Dt_Crtd_On AS ReceiptDate ,
                TRH.Dt_Upd_On AS UpdateDate ,
                TRH.S_ChequeDD_No AS InstrumentNo ,
                TRH.S_Bank_Name ,
                TRH.S_Branch_Name ,
                TRH.Dt_ChequeDD_Date ,
                TRH.Bank_Account_Name ,
                TRH.Dt_Deposit_Date AS DepositDate ,
                dbo.fnGetReceiptAmtExcldConvenienceCharge(( ISNULL(TRH.N_Receipt_Amount,
                                                              0)
                                                            + ISNULL(TRH.N_Tax_Amount,
                                                              0) ),
                                                          TBM.I_Brand_ID,
                                                          TRH.Dt_Receipt_Date,
                                                          TRH.I_PaymentMode_ID,
                                                          NULL) AS TotalAmount ,
                'SettledDebitCredit' AS Category
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Brand_Center_Details TBCD ON TRH.I_Centre_Id = TBCD.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_PaymentMode_Master TPMM ON TRH.I_PaymentMode_ID = TPMM.I_PaymentMode_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail TSD ON TRH.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
        WHERE   TRH.I_PaymentMode_ID IN ( 13,14,15,16,17,19,20,21,22,23,24,25 )
                AND ( CONVERT(DATE, TRH.Dt_Deposit_Date) >= @dtStartDate
                                                         AND CONVERT(DATE, TRH.Dt_Deposit_Date)< DATEADD(d,1,@dtEndDate) )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
        UNION ALL                                   
                                                   
                                                   
                                                   
                --bounce DebitCredit
        SELECT  TBM.S_Brand_Name ,
                TCHND.S_Center_Name ,
                TSD.S_Student_ID AS StudentOrEnquiryID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TRH.I_Receipt_Header_ID ,
                TRH.S_Receipt_No ,
                TRH.Dt_Crtd_On AS ReceiptDate ,
                TRH.Dt_Upd_On AS UpdateDate ,
                TRH.S_ChequeDD_No AS InstrumentNo ,
                TRH.S_Bank_Name ,
                TRH.S_Branch_Name ,
                TRH.Dt_ChequeDD_Date ,
                TRH.Bank_Account_Name ,
                TRH.Dt_Deposit_Date AS DepositDate ,
                dbo.fnGetReceiptAmtExcldConvenienceCharge(( ISNULL(TRH.N_Receipt_Amount,
                                                              0)
                                                            + ISNULL(TRH.N_Tax_Amount,
                                                              0) ),
                                                          TBM.I_Brand_ID,
                                                          TRH.Dt_Receipt_Date,
                                                          TRH.I_PaymentMode_ID,
                                                          NULL) AS TotalAmount ,
                'BounceDebitCredit' AS Category
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Brand_Center_Details TBCD ON TRH.I_Centre_Id = TBCD.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_PaymentMode_Master TPMM ON TRH.I_PaymentMode_ID = TPMM.I_PaymentMode_ID
                INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
        WHERE   TRH.I_PaymentMode_ID IN ( 13,14,15,16,17,19,20,21,22,23,24,25)
                AND ( CONVERT(DATE, TRH.Dt_Upd_On) BETWEEN @dtStartDate
                                                   AND     @dtEndDate )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND TRH.I_Status = 0
                AND TRH.Dt_Deposit_Date IS NOT NULL
        UNION ALL
        SELECT  TBM.S_Brand_Name ,
                TCHND.S_Center_Name ,
                CAST(TSD.I_Enquiry_Regn_ID AS VARCHAR) AS StudentOrEnquiryID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TRH.I_Receipt_Header_ID ,
                TRH.S_Receipt_No ,
                TRH.Dt_Crtd_On AS ReceiptDate ,
                TRH.Dt_Upd_On AS UpdateDate ,
                TRH.S_ChequeDD_No AS InstrumentNo ,
                TRH.S_Bank_Name ,
                TRH.S_Branch_Name ,
                TRH.Dt_ChequeDD_Date ,
                TRH.Bank_Account_Name ,
                TRH.Dt_Deposit_Date AS DepositDate ,
                dbo.fnGetReceiptAmtExcldConvenienceCharge(( ISNULL(TRH.N_Receipt_Amount,
                                                              0)
                                                            + ISNULL(TRH.N_Tax_Amount,
                                                              0) ),
                                                          TBM.I_Brand_ID,
                                                          TRH.Dt_Receipt_Date,
                                                          TRH.I_PaymentMode_ID,
                                                          NULL) AS TotalAmount ,
                'BounceDebitCredit' AS Category
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Brand_Center_Details TBCD ON TRH.I_Centre_Id = TBCD.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_PaymentMode_Master TPMM ON TRH.I_PaymentMode_ID = TPMM.I_PaymentMode_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail TSD ON TRH.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
        WHERE   TRH.I_PaymentMode_ID IN ( 13,14,15,16,17,19,20,21,22,23,24,25)
                AND ( CONVERT(DATE, TRH.Dt_Upd_On) BETWEEN @dtStartDate
                                                   AND     @dtEndDate )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND TRH.I_Status = 0
                AND TRH.Dt_Deposit_Date IS NOT NULL
        UNION ALL
                
                --unsettled DebitCredit
        SELECT  TBM.S_Brand_Name ,
                TCHND.S_Center_Name ,
                TSD.S_Student_ID AS StudentOrEnquiryID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TRH.I_Receipt_Header_ID ,
                TRH.S_Receipt_No ,
                TRH.Dt_Crtd_On AS ReceiptDate ,
                TRH.Dt_Upd_On AS UpdateDate ,
                TRH.S_ChequeDD_No AS InstrumentNo ,
                TRH.S_Bank_Name ,
                TRH.S_Branch_Name ,
                TRH.Dt_ChequeDD_Date ,
                TRH.Bank_Account_Name ,
                TRH.Dt_Deposit_Date AS DepositDate ,
                dbo.fnGetReceiptAmtExcldConvenienceCharge(( ISNULL(TRH.N_Receipt_Amount,
                                                              0)
                                                            + ISNULL(TRH.N_Tax_Amount,
                                                              0) ),
                                                          TBM.I_Brand_ID,
                                                          TRH.Dt_Receipt_Date,
                                                          TRH.I_PaymentMode_ID,
                                                          NULL) AS TotalAmount ,
                'UnsettledDebitCredit' AS Category
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Brand_Center_Details TBCD ON TRH.I_Centre_Id = TBCD.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_PaymentMode_Master TPMM ON TRH.I_PaymentMode_ID = TPMM.I_PaymentMode_ID
                INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
        WHERE   TRH.I_PaymentMode_ID IN ( 13,14,15,16,17,19,20,21,22,23,24,25)
                AND ( CONVERT(DATE, TRH.Dt_Receipt_Date) BETWEEN @dtStartDate
                                                         AND  @dtEndDate )
                AND ( TRH.Dt_Deposit_Date IS NULL
                      OR CONVERT(DATE, TRH.Dt_Deposit_Date) > @dtEndDate
                    )
                AND ( TRH.I_Status = 1
                      OR ( TRH.I_Status = 0
                           AND CONVERT(DATE, TRH.Dt_Upd_On) > @dtEndDate
                         )
                    )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                --AND TRH.I_Status=0 AND TRH.Dt_Deposit_Date IS NOT NULL                                   
        UNION ALL
        SELECT  TBM.S_Brand_Name ,
                TCHND.S_Center_Name ,
                CAST(TSD.I_Enquiry_Regn_ID AS VARCHAR) AS StudentOrEnquiryID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TRH.I_Receipt_Header_ID ,
                TRH.S_Receipt_No ,
                TRH.Dt_Crtd_On AS ReceiptDate ,
                TRH.Dt_Upd_On AS UpdateDate ,
                TRH.S_ChequeDD_No AS InstrumentNo ,
                TRH.S_Bank_Name ,
                TRH.S_Branch_Name ,
                TRH.Dt_ChequeDD_Date ,
                TRH.Bank_Account_Name ,
                TRH.Dt_Deposit_Date AS DepositDate ,
                dbo.fnGetReceiptAmtExcldConvenienceCharge(( ISNULL(TRH.N_Receipt_Amount,
                                                              0)
                                                            + ISNULL(TRH.N_Tax_Amount,
                                                              0) ),
                                                          TBM.I_Brand_ID,
                                                          TRH.Dt_Receipt_Date,
                                                          TRH.I_PaymentMode_ID,
                                                          NULL) AS TotalAmount ,
                'UnsettledDebitCredit' AS Category
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Brand_Center_Details TBCD ON TRH.I_Centre_Id = TBCD.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_PaymentMode_Master TPMM ON TRH.I_PaymentMode_ID = TPMM.I_PaymentMode_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail TSD ON TRH.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
        WHERE   TRH.I_PaymentMode_ID IN ( 13,14,15,16,17,19,20,21,22,23,24,25)
                AND ( CONVERT(DATE, TRH.Dt_Receipt_Date) BETWEEN @dtStartDate
                                                         AND  @dtEndDate )
                AND ( TRH.Dt_Deposit_Date IS NULL
                      OR CONVERT(DATE, TRH.Dt_Deposit_Date) > @dtEndDate
                    )
                AND ( TRH.I_Status = 1
                      OR ( TRH.I_Status = 0
                           AND CONVERT(DATE, TRH.Dt_Upd_On) > @dtEndDate
                         )
                    )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                --AND TRH.I_Status=0 AND TRH.Dt_Deposit_Date IS NOT NULL
        UNION ALL
                
                --Collection Prior Current Month DebitCredit
        SELECT  TBM.S_Brand_Name ,
                TCHND.S_Center_Name ,
                TSD.S_Student_ID AS StudentOrEnquiryID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TRH.I_Receipt_Header_ID ,
                TRH.S_Receipt_No ,
                TRH.Dt_Crtd_On AS ReceiptDate ,
                TRH.Dt_Upd_On AS UpdateDate ,
                TRH.S_ChequeDD_No AS InstrumentNo ,
                TRH.S_Bank_Name ,
                TRH.S_Branch_Name ,
                TRH.Dt_ChequeDD_Date ,
                TRH.Bank_Account_Name ,
                TRH.Dt_Deposit_Date AS DepositDate ,
                dbo.fnGetReceiptAmtExcldConvenienceCharge(( ISNULL(TRH.N_Receipt_Amount,
                                                              0)
                                                            + ISNULL(TRH.N_Tax_Amount,
                                                              0) ),
                                                          TBM.I_Brand_ID,
                                                          TRH.Dt_Receipt_Date,
                                                          TRH.I_PaymentMode_ID,
                                                          NULL) AS TotalAmount ,
                'CollectionPriorDebitCredit' AS Category
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Brand_Center_Details TBCD ON TRH.I_Centre_Id = TBCD.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_PaymentMode_Master TPMM ON TRH.I_PaymentMode_ID = TPMM.I_PaymentMode_ID
                INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
        WHERE   TRH.I_PaymentMode_ID IN ( 13,14,15,16,17,19,20,21,22,23,24,25)
                AND ( CONVERT(DATE, TRH.Dt_Receipt_Date) < @dtStartDate )
                AND ( CONVERT(DATE, TRH.Dt_Deposit_Date) BETWEEN @dtStartDate
                                                         AND  @dtEndDate )
                AND ( TRH.I_Status = 1
                      OR ( TRH.I_Status = 0
                           AND CONVERT(DATE, TRH.Dt_Upd_On) >= @dtStartDate
                         )
                    )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                --AND TRH.I_Status=0 AND TRH.Dt_Deposit_Date IS NOT NULL                                   
        UNION ALL
        SELECT  TBM.S_Brand_Name ,
                TCHND.S_Center_Name ,
                CAST(TSD.I_Enquiry_Regn_ID AS VARCHAR) AS StudentOrEnquiryID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TRH.I_Receipt_Header_ID ,
                TRH.S_Receipt_No ,
                TRH.Dt_Crtd_On AS ReceiptDate ,
                TRH.Dt_Upd_On AS UpdateDate ,
                TRH.S_ChequeDD_No AS InstrumentNo ,
                TRH.S_Bank_Name ,
                TRH.S_Branch_Name ,
                TRH.Dt_ChequeDD_Date ,
                TRH.Bank_Account_Name ,
                TRH.Dt_Deposit_Date AS DepositDate ,
                dbo.fnGetReceiptAmtExcldConvenienceCharge(( ISNULL(TRH.N_Receipt_Amount,
                                                              0)
                                                            + ISNULL(TRH.N_Tax_Amount,
                                                              0) ),
                                                          TBM.I_Brand_ID,
                                                          TRH.Dt_Receipt_Date,
                                                          TRH.I_PaymentMode_ID,
                                                          NULL) AS TotalAmount ,
                'CollectionPriorDebitCredit' AS Category
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Brand_Center_Details TBCD ON TRH.I_Centre_Id = TBCD.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_PaymentMode_Master TPMM ON TRH.I_PaymentMode_ID = TPMM.I_PaymentMode_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail TSD ON TRH.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
        WHERE   TRH.I_PaymentMode_ID IN ( 13,14,15,16,17,19,20,21,22,23,24,25 )
                AND ( CONVERT(DATE, TRH.Dt_Receipt_Date) < @dtStartDate )
                AND ( CONVERT(DATE, TRH.Dt_Deposit_Date) BETWEEN @dtStartDate
                                                         AND  @dtEndDate )
                AND ( TRH.I_Status = 1
                      OR ( TRH.I_Status = 0
                           AND CONVERT(DATE, TRH.Dt_Upd_On) >= @dtStartDate
                         )
                    )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
        UNION ALL
         
         --Collection Reversal DebitCredit
        SELECT  TBM.S_Brand_Name ,
                TCHND.S_Center_Name ,
                TSD.S_Student_ID AS StudentOrEnquiryID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TRH.I_Receipt_Header_ID ,
                TRH.S_Receipt_No ,
                TRH.Dt_Crtd_On AS ReceiptDate ,
                TRH.Dt_Upd_On AS UpdateDate ,
                TRH.S_ChequeDD_No AS InstrumentNo ,
                TRH.S_Bank_Name ,
                TRH.S_Branch_Name ,
                TRH.Dt_ChequeDD_Date ,
                TRH.Bank_Account_Name ,
                TRH.Dt_Deposit_Date AS DepositDate ,
                dbo.fnGetReceiptAmtExcldConvenienceCharge(( ISNULL(TRH.N_Receipt_Amount,
                                                              0)
                                                            + ISNULL(TRH.N_Tax_Amount,
                                                              0) ),
                                                          TBM.I_Brand_ID,
                                                          TRH.Dt_Receipt_Date,
                                                          TRH.I_PaymentMode_ID,
                                                          NULL) AS TotalAmount ,
                'CollectionReversalDebitCredit' AS Category
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Brand_Center_Details TBCD ON TRH.I_Centre_Id = TBCD.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_PaymentMode_Master TPMM ON TRH.I_PaymentMode_ID = TPMM.I_PaymentMode_ID
                INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
        WHERE   TRH.I_PaymentMode_ID IN ( 13,14,15,16,17,19,20,21,22,23,24,25)
                AND ( CONVERT(DATE, TRH.Dt_Receipt_Date) < @dtStartDate )
                AND TRH.Dt_Deposit_Date IS NULL
                AND ( (TRH.I_Status = 0
                      AND CONVERT(DATE, TRH.Dt_Upd_On) BETWEEN @dtStartDate
                                                       AND    @dtEndDate)
                    )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                --AND TRH.I_Status=0 AND TRH.Dt_Deposit_Date IS NOT NULL                                   
        UNION ALL
        SELECT  TBM.S_Brand_Name ,
                TCHND.S_Center_Name ,
                CAST(TSD.I_Enquiry_Regn_ID AS VARCHAR) AS StudentOrEnquiryID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TRH.I_Receipt_Header_ID ,
                TRH.S_Receipt_No ,
                TRH.Dt_Crtd_On AS ReceiptDate ,
                TRH.Dt_Upd_On AS UpdateDate ,
                TRH.S_ChequeDD_No AS InstrumentNo ,
                TRH.S_Bank_Name ,
                TRH.S_Branch_Name ,
                TRH.Dt_ChequeDD_Date ,
                TRH.Bank_Account_Name ,
                TRH.Dt_Deposit_Date AS DepositDate ,
                dbo.fnGetReceiptAmtExcldConvenienceCharge(( ISNULL(TRH.N_Receipt_Amount,
                                                              0)
                                                            + ISNULL(TRH.N_Tax_Amount,
                                                              0) ),
                                                          TBM.I_Brand_ID,
                                                          TRH.Dt_Receipt_Date,
                                                          TRH.I_PaymentMode_ID,
                                                          NULL) AS TotalAmount ,
                'CollectionReversalDebitCredit' AS Category
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Brand_Center_Details TBCD ON TRH.I_Centre_Id = TBCD.I_Centre_Id
                INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_PaymentMode_Master TPMM ON TRH.I_PaymentMode_ID = TPMM.I_PaymentMode_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail TSD ON TRH.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
        WHERE   TRH.I_PaymentMode_ID IN ( 13,14,15,16,17,19,20,21,22,23,24,25)
                AND ( CONVERT(DATE, TRH.Dt_Receipt_Date) < @dtStartDate )
                AND TRH.Dt_Deposit_Date IS NULL
                AND ( (TRH.I_Status = 0
                      AND CONVERT(DATE, TRH.Dt_Upd_On) BETWEEN @dtStartDate
                                                       AND    @dtEndDate)
                    )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )                                                                                     
                
                                                                                                                         
	
    END
