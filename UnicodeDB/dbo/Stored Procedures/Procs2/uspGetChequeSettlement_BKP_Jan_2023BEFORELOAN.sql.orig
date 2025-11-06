
CREATE PROCEDURE [dbo].[uspGetChequeSettlement_BKP_Jan_2023BEFORELOAN]  --[uspGetChequeSettlement] null,NULL,794,1     
    (
      @dtDateTo DATETIME = NULL ,
      @dtDateFrom DATETIME = NULL ,    
   --@iCenterID INT,
      @sHierarchyDetailID VARCHAR(MAX) ,
      @iBrandID INT = NULL ,
      @IsSettlement BIT 
    )
AS 
    BEGIN          
        SET NOCOUNT ON ;          
        IF @IsSettlement = 0 
            BEGIN    
                SELECT  RH.N_Receipt_Amount + RH.N_Tax_Amount AS N_Receipt_Amount ,
                        RH.I_Receipt_Header_ID ,
                        SD.S_First_Name ,
                        SD.S_Middle_Name ,
                        SD.S_Last_Name ,
                        RH.I_Enquiry_Regn_ID ,
                        RH.I_Student_Detail_ID ,
                        RH.S_Receipt_No ,
                        RH.I_Receipt_Type ,
                        RH.I_Centre_Id ,
                        RH.I_PaymentMode_ID ,
                        CASE WHEN RH.I_PaymentMode_ID=27 THEN ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS')+'('+RH.S_Bank_Name+')' 
						ELSE ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS') END as  S_ChequeDD_No,
                        RH.Bank_Account_Name ,
                        RH.Dt_Deposit_Date
                FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )
                        INNER JOIN dbo.T_Student_Detail SD WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = RH.I_Student_Detail_ID
                WHERE   RH.I_PaymentMode_ID IN ( 2, 3,27 )
                        AND RH.I_Centre_Id IN (
                        SELECT  fnCenter.centerID
                        FROM    fnGetCentersForReports(@sHierarchyDetailID,
                                                       @iBrandID) fnCenter )--(select chnd.I_Center_ID from T_Center_Hierarchy_Name_Details chnd where chnd.I_Hierarchy_Detail_ID=@iHierarchyDetailID)
                        AND ( RH.Bank_Account_Name IS NULL
                              OR RH.Dt_Deposit_Date IS NULL
                            )
                        AND RH.Dt_Receipt_Date BETWEEN @dtDateFrom
                                               AND     @dtDateTo
                        AND RH.I_Status = 1
                UNION ALL
                SELECT  RH.N_Receipt_Amount + RH.N_Tax_Amount AS N_Receipt_Amount ,
                        RH.I_Receipt_Header_ID ,
                        TERD.S_First_Name ,
                        TERD.S_Middle_Name ,
                        TERD.S_Last_Name ,
                        RH.I_Enquiry_Regn_ID ,
                        RH.I_Student_Detail_ID ,
                        RH.S_Receipt_No ,
                        RH.I_Receipt_Type ,
                        RH.I_Centre_Id ,
                        RH.I_PaymentMode_ID ,
                        CASE WHEN RH.I_PaymentMode_ID=27 THEN ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS')+'('+RH.S_Bank_Name+')' 
						ELSE ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS') END as  S_ChequeDD_No,
                        RH.Bank_Account_Name ,
                        RH.Dt_Deposit_Date
                FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )
                        INNER JOIN dbo.T_Enquiry_Regn_Detail TERD WITH ( NOLOCK ) ON TERD.I_Enquiry_Regn_ID = RH.I_Enquiry_Regn_ID
                WHERE   RH.I_PaymentMode_ID IN ( 2, 3,27 )
                        AND RH.I_Centre_Id IN (
                        SELECT  fnCenter.centerID
                        FROM    fnGetCentersForReports(@sHierarchyDetailID,
                                                       @iBrandID) fnCenter ) --(select chnd.I_Center_ID from T_Center_Hierarchy_Name_Details chnd where chnd.I_Hierarchy_Detail_ID=@iHierarchyDetailID)
                        AND ( RH.Bank_Account_Name IS NULL
                              OR RH.Dt_Deposit_Date IS NULL
                            )
                        AND RH.Dt_Receipt_Date BETWEEN @dtDateFrom
                                               AND     @dtDateTo
                        AND RH.I_Status = 1 
  
  
            END    
        ELSE 
            BEGIN    
                SELECT  RH.N_Receipt_Amount + RH.N_Tax_Amount AS N_Receipt_Amount ,
                        RH.I_Receipt_Header_ID ,
                        SD.S_First_Name ,
                        SD.S_Middle_Name ,
                        SD.S_Last_Name ,
                        RH.I_Enquiry_Regn_ID ,
                        RH.I_Student_Detail_ID ,
                        RH.S_Receipt_No ,
                        RH.I_Receipt_Type ,
                        RH.I_Centre_Id ,
                        RH.I_PaymentMode_ID ,
                        CASE WHEN RH.I_PaymentMode_ID=27 THEN ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS')+'('+RH.S_Bank_Name+')' 
						ELSE ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS') END as  S_ChequeDD_No,
                        RH.Bank_Account_Name ,
                        RH.Dt_Deposit_Date
                FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )
                        INNER JOIN dbo.T_Student_Detail SD WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = RH.I_Student_Detail_ID
                WHERE   RH.I_PaymentMode_ID IN ( 2, 3,27 )
                        AND RH.I_Centre_Id IN (
                        SELECT  fnCenter.centerID
                        FROM    fnGetCentersForReports(@sHierarchyDetailID,
                                                       @iBrandID) fnCenter )--(select chnd.I_Center_ID from T_Center_Hierarchy_Name_Details chnd where chnd.I_Hierarchy_Detail_ID=@iHierarchyDetailID)    
                        AND DATEDIFF(dd, Dt_Deposit_Date, @dtDateFrom) <= 0
                        AND DATEDIFF(dd, Dt_Deposit_Date, @dtDateTo) >= 0 
                        AND RH.I_Status=1
                        
                 UNION ALL
                 
                 SELECT  RH.N_Receipt_Amount + RH.N_Tax_Amount AS N_Receipt_Amount ,
                        RH.I_Receipt_Header_ID ,
                        TERD.S_First_Name ,
                        TERD.S_Middle_Name ,
                        TERD.S_Last_Name ,
                        RH.I_Enquiry_Regn_ID ,
                        RH.I_Student_Detail_ID ,
                        RH.S_Receipt_No ,
                        RH.I_Receipt_Type ,
                        RH.I_Centre_Id ,
                        RH.I_PaymentMode_ID ,
                        CASE WHEN RH.I_PaymentMode_ID=27 THEN ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS')+'('+RH.S_Bank_Name+')' 
						ELSE ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS') END as  S_ChequeDD_No,
                        RH.Bank_Account_Name ,
                        RH.Dt_Deposit_Date
                FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )
                        INNER JOIN dbo.T_Enquiry_Regn_Detail TERD WITH ( NOLOCK ) ON TERD.I_Enquiry_Regn_ID = RH.I_Enquiry_Regn_ID
                WHERE   RH.I_PaymentMode_ID IN ( 2, 3, 27 )
                        AND RH.I_Centre_Id IN (
                        SELECT  fnCenter.centerID
                        FROM    fnGetCentersForReports(@sHierarchyDetailID,
                                                       @iBrandID) fnCenter )--(select chnd.I_Center_ID from T_Center_Hierarchy_Name_Details chnd where chnd.I_Hierarchy_Detail_ID=@iHierarchyDetailID)    
                        AND DATEDIFF(dd, Dt_Deposit_Date, @dtDateFrom) <= 0
                        AND DATEDIFF(dd, Dt_Deposit_Date, @dtDateTo) >= 0
                        AND RH.I_Status=1                 
            END    
    END 
  
