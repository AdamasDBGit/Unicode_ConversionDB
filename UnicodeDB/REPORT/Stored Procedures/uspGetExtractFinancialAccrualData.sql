CREATE PROCEDURE [REPORT].[uspGetExtractFinancialAccrualData]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @dtStartDate DATE ,
      @dtEndDate DATE
    )
AS 
    BEGIN
	
        CREATE TABLE #temp
            (
              I_Brand_ID INT ,
              S_Brand_Name VARCHAR(MAX) ,
              I_Transaction_Type_ID INT ,
              I_Transaction_Nature_ID INT ,
              I_FeeComponent_ID INT ,
              S_FeeComponent_Name VARCHAR(MAX) ,
              I_Student_ID INT ,
              S_Student_ID VARCHAR(MAX) ,
              S_Student_Name VARCHAR(MAX) ,
              I_Enquiry_Regn_ID INT ,
              S_Cost_Center VARCHAR(MAX) ,
              N_Amount DECIMAL(14, 2) ,
              Transaction_Date DATE ,
              Instrument_Number VARCHAR(MAX) ,
              Bank_Account_Name VARCHAR(MAX) ,
              I_Centre_ID INT ,
              S_Centre_Name VARCHAR(MAX) ,
              I_Batch_ID INT ,
              S_Batch_Name VARCHAR(MAX) ,
              I_Course_ID INT ,
              S_Course_Name VARCHAR(MAX) ,
              ContactNo VARCHAR(MAX) ,
              StdAddress VARCHAR(MAX) ,
              I_PickupPoint_ID INT ,
              S_PickUpPoint_Name VARCHAR(MAX) ,
              I_Route_No INT ,
              S_Route_No VARCHAR(MAX)
            )
            
        
            
            
        DECLARE @dtExecutionDate DATE
        
        SET @dtExecutionDate = @dtStartDate
            
        WHILE ( DATEDIFF(dd, @dtExecutionDate, @dtEndDate) >= 0 ) 
            BEGIN    
                INSERT  INTO #temp
                        ( I_Brand_ID ,
                          S_Brand_Name ,
                          I_Transaction_Type_ID ,
                          I_Transaction_Nature_ID ,
                          I_FeeComponent_ID ,
                          S_FeeComponent_Name ,
                          I_Student_ID ,
                          S_Student_ID ,
                          S_Student_Name ,
                          I_Enquiry_Regn_ID ,
                          S_Cost_Center ,
                          N_Amount ,
                          Transaction_Date ,
                          Instrument_Number ,
                          Bank_Account_Name ,
                          I_Centre_ID ,
                          S_Centre_Name 
                    
                        )
                        SELECT  tbcd.I_Brand_ID ,
                                TCHND.S_Brand_Name ,
                                tttm.I_Transaction_Type_ID ,
                                tttm.I_Transaction_Nature_ID ,
                                TFCM.I_Fee_Component_ID ,
                                TFCM.S_Component_Name ,
                                tip.I_Student_Detail_ID ,
                                TSD.S_Student_ID ,
                                TSD.S_First_Name + ' ' + ISNULL(S_Middle_Name,
                                                              '') + ' '
                                + TSD.S_Last_Name ,
                                NULL ,
                                tcm.S_Cost_Center ,
                                ABS(ticd.N_Amount_Due) ,
                                @dtExecutionDate ,
                                NULL ,
                                NULL ,
                                TCHND.I_Center_ID ,
                                TCHND.S_Center_Name
                        FROM    dbo.T_Invoice_Parent AS tip
                                INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id
                                                              AND tcm.I_Status = 1
                                INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id
                                                              AND tbcd.I_Status = 1
                                INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID	
	--INNER JOIN dbo.T_Invoice_Batch_Map AS tibm ON tich.I_Invoice_Child_Header_ID = tibm.I_Invoice_Child_Header_ID AND tibm.I_Status = 1
                                INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID
                                INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tttm.I_Brand_ID = tbcd.I_Brand_ID
                                                              AND ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
                                                              AND tttm.I_Status_ID IS NULL
                                                              AND tttm.I_Payment_Mode_ID IS NULL
                                                              AND tttm.I_Tax_ID IS NULL
                                                              AND tttm.I_Status = 1
                                                              AND tttm.I_Transaction_Nature_ID = 1
                                INNER JOIN dbo.T_Fee_Component_Master TFCM ON tttm.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
                                                              AND ticd.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
                                INNER JOIN dbo.T_Student_Detail TSD ON tip.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON tbcd.I_Brand_ID = TCHND.I_Brand_ID
                                                              AND tbcd.I_Centre_Id = TCHND.I_Center_ID
                        WHERE   --DATEDIFF(dd,ticd.Dt_Installment_Date,@dtExecutionDate) = 0 
                                DATEDIFF(dd,
                                         CASE WHEN ticd.Dt_Installment_Date >= CONVERT(DATE, tip.Dt_Crtd_On)
                                              THEN ticd.Dt_Installment_Date
                                              ELSE CONVERT(DATE, tip.Dt_Crtd_On)
                                         END, @dtExecutionDate) = 0
                                AND tip.I_Status IN ( 1, 3, 0, 2 )
                                AND TCHND.I_Center_ID IN (
                                SELECT  FGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR )
                        UNION ALL
                        SELECT  tbcd.I_Brand_ID ,
                                TCHND.S_Brand_Name ,
                                tttm.I_Transaction_Type_ID ,
                                tttm.I_Transaction_Nature_ID ,
                                TFCM.I_Fee_Component_ID ,
                                TFCM.S_Component_Name ,
                                tip.I_Student_Detail_ID ,
                                TSD.S_Student_ID ,
                                TSD.S_First_Name + ' ' + ISNULL(S_Middle_Name,
                                                              '') + ' '
                                + TSD.S_Last_Name ,
                                NULL ,
                                tcm.S_Cost_Center ,
                                ABS(ticd.N_Amount_Due) ,
                                @dtExecutionDate ,
                                NULL ,
                                NULL ,
                                TCHND.I_Center_ID ,
                                TCHND.S_Center_Name
                        FROM    dbo.T_Invoice_Parent AS tip
                                INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id
                                                              AND tcm.I_Status = 1
                                INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id
                                                              AND tbcd.I_Status = 1
                                INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID	
	--INNER JOIN dbo.T_Invoice_Batch_Map AS tibm ON tich.I_Invoice_Child_Header_ID = tibm.I_Invoice_Child_Header_ID AND tibm.I_Status = 1
                                INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID
                                INNER JOIN dbo.T_Invoice_Detail_Tax AS tidt ON ticd.I_Invoice_Detail_ID = tidt.I_Invoice_Detail_ID
                                INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tttm.I_Brand_ID = tbcd.I_Brand_ID
                                                              AND ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
                                                              AND tidt.I_Tax_ID = tttm.I_Tax_ID
                                                              AND tttm.I_Payment_Mode_ID IS NULL
                                                              AND tttm.I_Status_ID IS NULL
                                                              AND tttm.I_Status = 1
                                                              AND tttm.I_Transaction_Nature_ID = 1
                                INNER JOIN dbo.T_Fee_Component_Master TFCM ON tttm.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
                                                              AND ticd.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
                                INNER JOIN dbo.T_Student_Detail TSD ON tip.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON tbcd.I_Brand_ID = TCHND.I_Brand_ID
                                                              AND tbcd.I_Centre_Id = TCHND.I_Center_ID
                        WHERE   --DATEDIFF(dd,ticd.Dt_Installment_Date,@dtExecutionDate) = 0 
                                DATEDIFF(dd,
                                         CASE WHEN ticd.Dt_Installment_Date >= CONVERT(DATE, tip.Dt_Crtd_On)
                                              THEN ticd.Dt_Installment_Date
                                              ELSE CONVERT(DATE, tip.Dt_Crtd_On)
                                         END, @dtExecutionDate) = 0
                                AND tip.I_Status IN ( 1, 3, 0, 2 )
                                AND TCHND.I_Center_ID IN (
                                SELECT  FGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR )
                UNION ALL                
                                
                SELECT  tbcd.I_Brand_ID ,
                        TCHND.S_Brand_Name ,
                        tttm.I_Transaction_Type_ID ,
                        tttm.I_Transaction_Nature_ID ,
                        TFCM.I_Fee_Component_ID ,
                        TFCM.S_Component_Name ,
                        tip.I_Student_Detail_ID ,
                        TSD.S_Student_ID ,
                        TSD.S_First_Name + ' ' + ISNULL(S_Middle_Name, '')
                        + ' ' + TSD.S_Last_Name ,
                        NULL ,
                        tcm.S_Cost_Center ,
                        ABS(ticd.N_Amount_Due) ,
                        @dtExecutionDate ,
                        NULL ,
                        NULL ,
                        TCHND.I_Center_ID ,
                        TCHND.S_Center_Name
                FROM    dbo.T_Invoice_Parent AS tip
                        INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id
                                                              AND tcm.I_Status = 1
                        INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id
                                                              AND tbcd.I_Status = 1
                        INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                        INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID
                        INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
                                                              AND tttm.I_Payment_Mode_ID IS NULL
                                                              AND tttm.I_Brand_ID = tbcd.I_Brand_ID
                                                              AND tttm.I_Status_ID IS NULL
                                                              AND tttm.I_Tax_ID IS NULL
                                                              AND tttm.I_Status = 1
                                                              AND tttm.I_Transaction_Nature_ID = 2
                        INNER JOIN dbo.T_Fee_Component_Master TFCM ON tttm.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
                                                              AND ticd.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
                        INNER JOIN dbo.T_Student_Detail TSD ON tip.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON tbcd.I_Brand_ID = TCHND.I_Brand_ID
                                                              AND tbcd.I_Centre_Id = TCHND.I_Center_ID
                WHERE   tip.I_Status = 0
                        AND DATEDIFF(dd,
                                     CASE WHEN ticd.Dt_Installment_Date > tip.Dt_Upd_On
                                          THEN ticd.Dt_Installment_Date
                                          ELSE tip.Dt_Upd_On
                                     END, @dtExecutionDate) = 0
                        AND TCHND.I_Center_ID IN (
                        SELECT  FGCFR.centerID
                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                           @iBrandID) FGCFR )
                UNION ALL
                SELECT  tbcd.I_Brand_ID ,
                        TCHND.S_Brand_Name ,
                        tttm.I_Transaction_Type_ID ,
                        tttm.I_Transaction_Nature_ID ,
                        TFCM.I_Fee_Component_ID ,
                        TFCM.S_Component_Name ,
                        tip.I_Student_Detail_ID ,
                        TSD.S_Student_ID ,
                        TSD.S_First_Name + ' ' + ISNULL(S_Middle_Name, '')
                        + ' ' + TSD.S_Last_Name ,
                        NULL ,
                        tcm.S_Cost_Center ,
                        ABS(ticd.N_Amount_Due) ,
                        @dtExecutionDate ,
                        NULL ,
                        NULL ,
                        TCHND.I_Center_ID ,
                        TCHND.S_Center_Name
                FROM    dbo.T_Invoice_Parent AS tip
                        INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id
                                                              AND tcm.I_Status = 1
                        INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id
                                                              AND tbcd.I_Status = 1
                        INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                        INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID
                        INNER JOIN dbo.T_Invoice_Detail_Tax AS tidt ON ticd.I_Invoice_Detail_ID = tidt.I_Invoice_Detail_ID
                        INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
                                                              AND tttm.I_Payment_Mode_ID IS NULL
                                                              AND tttm.I_Brand_ID = tbcd.I_Brand_ID
                                                              AND tidt.I_Tax_ID = tttm.I_Tax_ID
                                                              AND tttm.I_Status_ID IS NULL
                                                              AND tttm.I_Status = 1
                                                              AND tttm.I_Transaction_Nature_ID = 2
                        INNER JOIN dbo.T_Fee_Component_Master TFCM ON tttm.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
                                                              AND ticd.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
                        INNER JOIN dbo.T_Student_Detail TSD ON tip.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON tbcd.I_Brand_ID = TCHND.I_Brand_ID
                                                              AND tbcd.I_Centre_Id = TCHND.I_Center_ID
                WHERE   tip.I_Status = 0
                        AND DATEDIFF(dd,
                                     CASE WHEN ticd.Dt_Installment_Date > tip.Dt_Upd_On
                                          THEN ticd.Dt_Installment_Date
                                          ELSE tip.Dt_Upd_On
                                     END, @dtExecutionDate) = 0
                        AND TCHND.I_Center_ID IN (
                        SELECT  FGCFR.centerID
                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                           @iBrandID) FGCFR )      
                        
                        
                        
                SET @dtExecutionDate = DATEADD(dd, 1, @dtExecutionDate)
            END
                        
        SELECT  T1.I_Brand_ID ,
                T1.S_Brand_Name ,
                T1.I_Centre_ID ,
                T1.S_Centre_Name ,
                T1.I_Student_ID ,
                T1.S_Student_ID ,
                T1.I_FeeComponent_ID ,
                T1.S_FeeComponent_Name ,
                DATENAME(MONTH, T1.Transaction_Date) + ' '
                + CAST(DATEPART(YYYY, T1.Transaction_Date) AS VARCHAR) AS TransMonth,
                CASE WHEN T1.I_Transaction_Nature_ID=1 THEN 'Accrual'
                WHEN T1.I_Transaction_Nature_ID=2 THEN 'Accrual Cancellation'
                END AS TransactionNature,
                SUM(ISNULL(T1.N_Amount,0)) AS Amount
        FROM    #temp T1
        GROUP BY 
        T1.I_Brand_ID ,
                T1.S_Brand_Name ,
                T1.I_Centre_ID ,
                T1.S_Centre_Name ,
                T1.I_Student_ID ,
                T1.S_Student_ID ,
                T1.I_FeeComponent_ID ,
                T1.S_FeeComponent_Name ,
                DATENAME(MONTH, T1.Transaction_Date) + ' '
                + CAST(DATEPART(YYYY, T1.Transaction_Date) AS VARCHAR),
                CASE WHEN T1.I_Transaction_Nature_ID=1 THEN 'Accrual'
                WHEN T1.I_Transaction_Nature_ID=2 THEN 'Accrual Cancellation'
                END
	
    END
