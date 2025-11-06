CREATE PROCEDURE [REPORT].[uspGetCollectionRegisterReportNew] --195,61,'12/1/2007','1/1/2008','ALL'  
    (
      -- Add the parameters for the stored procedure here  
      @sHierarchyList VARCHAR(MAX) ,
      @iBrandID INT ,
      @dtStartDate DATETIME ,
      @dtEndDate DATETIME ,
      @sCounselorCond VARCHAR(20)
    )
AS 
    BEGIN TRY  
  
        SET NOCOUNT ON  
  
        IF @sCounselorCond = 'ALL' 
            BEGIN  
    
                SELECT  Student_ID = CASE WHEN RH.I_Student_Detail_ID IS NOT NULL
                                          THEN SD.S_Student_ID
                                          ELSE ERD.S_Enquiry_No
                                     END ,
                        Student_Name = CASE WHEN RH.I_Student_Detail_ID IS NOT NULL
                                            THEN LTRIM(ISNULL(SD.S_First_Name,
                                                              '') + ' ')
                                                 + LTRIM(ISNULL(SD.S_Middle_Name,
                                                              '') + ' '
                                                         + ISNULL(SD.S_Last_Name,
                                                              ''))
                                            ELSE LTRIM(ISNULL(ERD.S_First_Name,
                                                              '') + ' ')
                                                 + LTRIM(ISNULL(ERD.S_Middle_Name,
                                                              '') + ' '
                                                         + ISNULL(ERD.S_Last_Name,
                                                              ''))
                                       END ,  
   --RH.I_Student_Detail_ID as newStudID,  
   --TSBD.I_Status as newStatus,  
                        IP.S_Invoice_No ,
                        IP.Dt_Invoice_Date ,
                        ISNULL(IP.N_Invoice_Amount, 0.00) AS Invoice_Amount ,
                        ISNULL(IP.N_Tax_Amount, 0.00) AS Tax_Amount ,
                        ISNULL(IP.N_Discount_Amount, 0.00) AS N_Discount_Amount ,
                        Counselor_Name = LTRIM(ISNULL(UM.S_First_Name, '')
                                               + ' ')
                        + LTRIM(ISNULL(UM.S_Middle_Name, '') + ' '
                                + ISNULL(UM.S_Last_Name, '')) ,
                        FN1.CenterCode ,
                        FN1.CenterName ,
                        FN2.InstanceChain ,
                        CUM.S_Currency_Code ,
                        RH.S_Receipt_No AS Receipt_No ,
                        RH.Dt_Receipt_Date AS Receipt_Date ,
                        RH.I_Student_Detail_ID ,
                        RH.I_Enquiry_Regn_ID ,
                        RH.I_Invoice_Header_ID ,
                        RH.I_Receipt_Header_ID ,
                        RH.I_Status ,
                        ISNULL(RH.N_Receipt_Amount, 0.00) AS Receipt_Amount ,
                        ISNULL(RH.N_Tax_Amount, 0.00) AS Receipt_Tax ,
                        RT.S_Status_Desc AS S_Receipt_Type_Desc ,
                        ERD.S_Form_No AS S_Form_No ,
                        PMM.S_PaymentMode_Name AS Payment_Mode ,
                        RH.S_Bank_Name ,
                        CASE WHEN [RH].[I_PaymentMode_ID] = 2
                             THEN CAST([RH].[S_ChequeDD_No] AS VARCHAR(20))
                             WHEN [RH].[I_PaymentMode_ID] = 3
                             THEN CAST([RH].[S_ChequeDD_No] AS VARCHAR(20))
                             ELSE ''
                        END AS Instrument_No ,
                        RH.Dt_ChequeDD_Date ,
                        Course_Fee = ISNULL(( SELECT    SUM(ISNULL(RCD.N_Amount_Paid,
                                                              0.00))
                                              FROM      dbo.T_Receipt_Component_Detail RCD
                                                        WITH ( NOLOCK )
                                                        INNER JOIN dbo.T_Invoice_Child_Detail ICD
                                                        WITH ( NOLOCK ) ON RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
                                              WHERE     ICD.I_Fee_Component_ID = 21
                                                        AND RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
                                            ), 0.00) ,
                        Exam_Fee = ISNULL(( SELECT  SUM(ISNULL(RCD.N_Amount_Paid,
                                                              0.00))
                                            FROM    dbo.T_Receipt_Component_Detail RCD
                                                    WITH ( NOLOCK )
                                                    INNER JOIN dbo.T_Invoice_Child_Detail ICD
                                                    WITH ( NOLOCK ) ON RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
                                            WHERE   ICD.I_Fee_Component_ID = 4
                                                    AND RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
                                          ), 0.00) ,
                        Others_Fee = ISNULL(( SELECT    SUM(ISNULL(RCD.N_Amount_Paid,
                                                              0.00))
                                              FROM      dbo.T_Receipt_Component_Detail RCD
                                                        WITH ( NOLOCK )
                                                        INNER JOIN dbo.T_Invoice_Child_Detail ICD
                                                        WITH ( NOLOCK ) ON RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
                                              WHERE     ICD.I_Fee_Component_ID NOT IN (
                                                        21, 4 )
                                                        AND RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
                                            ), 0.00) ,
                        Tax_Component = ISNULL(( SELECT SUM(ISNULL(RTD.N_Tax_Paid,
                                                              0.00))
                                                 FROM   dbo.T_Receipt_Component_Detail RCD
                                                        WITH ( NOLOCK )
                                                        INNER JOIN dbo.T_Receipt_Tax_Detail RTD
                                                        WITH ( NOLOCK ) ON RCD.I_Receipt_Comp_Detail_ID = RTD.I_Receipt_Comp_Detail_ID
                                                 WHERE  RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
                                               ), 0.00) ,
                        UudatedBy = LTRIM(ISNULL(TUM.S_First_Name, '') + ' ')
                        + LTRIM(ISNULL(TUM.S_Middle_Name, '') + ' '
                                + ISNULL(TUM.S_Last_Name, '')) ,
                        RH.Dt_Crtd_On AS Dt_Upd_On ,
                        TSBM.S_Batch_Name ,
                        TSBD.S_Course_Name ,
                        dbo.fnCalculateConvenienceCharge(ISNULL(RH.N_Receipt_Amount,
                                                              0.0)
                                                         + ISNULL(RH.N_Tax_Amount,
                                                              0.0), @iBrandID,
                                                         RH.Dt_Receipt_Date,
                                                         RH.I_PaymentMode_ID) AS ConvenienceCharge ,
                        dbo.fnCalculateConvenienceChargeTax(dbo.fnCalculateConvenienceCharge(ISNULL(RH.N_Receipt_Amount,
                                                              0.0)
                                                              + ISNULL(RH.N_Tax_Amount,
                                                              0.0), @iBrandID,
                                                              RH.Dt_Receipt_Date,
                                                              RH.I_PaymentMode_ID),
                                                            @iBrandID,
                                                            RH.Dt_Receipt_Date,
                                                            NULL) AS ConvenienceChargeTax
                FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )
                        LEFT OUTER JOIN dbo.T_User_Master UM WITH ( NOLOCK ) ON RH.S_Crtd_By = UM.S_Login_ID
                        INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) FN1 ON RH.I_Centre_Id = FN1.CenterID
                        INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,
                                                              @iBrandID) FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
                        INNER JOIN dbo.T_PaymentMode_Master PMM WITH ( NOLOCK ) ON RH.I_PaymentMode_ID = PMM.I_PaymentMode_ID
                        INNER JOIN dbo.T_Status_Master RT WITH ( NOLOCK ) ON [S_Status_Type] = 'ReceiptType'
                                                              AND RH.I_Receipt_Type = RT.I_Status_Value
                        INNER JOIN dbo.T_Centre_Master CEM WITH ( NOLOCK ) ON FN1.CenterID = CEM.I_Centre_Id
                        INNER JOIN dbo.T_Country_Master COM WITH ( NOLOCK ) ON CEM.I_Country_ID = COM.I_Country_ID
                        INNER JOIN dbo.T_Currency_Master CUM WITH ( NOLOCK ) ON COM.I_Currency_ID = CUM.I_Currency_ID
                        LEFT OUTER JOIN dbo.T_Invoice_Parent IP WITH ( NOLOCK ) ON RH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID
                        LEFT OUTER JOIN dbo.T_Student_Detail SD WITH ( NOLOCK ) ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID
                        --LEFT OUTER JOIN dbo.T_Student_Batch_Details TSBD WITH ( NOLOCK ) ON RH.I_Student_Detail_ID = TSBD.I_Student_ID --and TSBD.I_Status!=2   
                        OUTER APPLY ( SELECT TOP 1
                                                tsbd.I_Student_Batch_ID ,
                                                tsbd.I_Status ,
                                                tsbd.I_Batch_ID ,
                                                TCM.S_Course_Name
                                      FROM      dbo.T_Student_Batch_Details AS tsbd
                                                INNER JOIN dbo.T_Student_Batch_Master TSBM2 ON tsbd.I_Batch_ID = TSBM2.I_Batch_ID
                                                INNER JOIN dbo.T_Course_Master TCM ON TSBM2.I_Course_ID = TCM.I_Course_ID
                                      WHERE     tsbd.I_Student_ID = RH.I_Student_Detail_ID
                                                AND tsbd.I_Status IN ( 1, 2 )
                                                OR tsbd.I_Status IS NULL
                                      ORDER BY  tsbd.I_Student_Batch_ID DESC
                                    ) tsbd
                        LEFT OUTER JOIN dbo.T_Student_Batch_Master TSBM WITH ( NOLOCK ) ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                        LEFT OUTER JOIN dbo.T_Enquiry_Regn_Detail ERD WITH ( NOLOCK ) ON RH.I_Enquiry_Regn_ID = ERD.I_Enquiry_Regn_ID
                        LEFT OUTER JOIN DBO.T_User_Master TUM ON RH.S_Crtd_By = TUM.S_Login_ID
                WHERE   CAST(SUBSTRING(CAST(RH.Dt_Receipt_Date AS VARCHAR), 1,
                                       11) AS DATETIME) BETWEEN @dtStartDate
                                                        AND   @dtEndDate
                        AND ISNULL(IP.I_Invoice_Header_ID, '') = ISNULL(RH.I_Invoice_Header_ID,
                                                              '')
                        --AND ( TSBD.I_Status IS NULL
                        --      OR TSBD.I_Status = 1
                        --    )
                UNION ALL
                SELECT  Student_ID = CASE WHEN RH.I_Student_Detail_ID IS NOT NULL
                                          THEN SD.S_Student_ID
                                          ELSE ERD.S_Enquiry_No
                                     END ,
                        Student_Name = CASE WHEN RH.I_Student_Detail_ID IS NOT NULL
                                            THEN LTRIM(ISNULL(SD.S_First_Name,
                                                              '') + ' ')
                                                 + LTRIM(ISNULL(SD.S_Middle_Name,
                                                              '') + ' '
                                                         + ISNULL(SD.S_Last_Name,
                                                              ''))
                                            ELSE LTRIM(ISNULL(ERD.S_First_Name,
                                                              '') + ' ')
                                                 + LTRIM(ISNULL(ERD.S_Middle_Name,
                                                              '') + ' '
                                                         + ISNULL(ERD.S_Last_Name,
                                                              ''))
                                       END ,  
   --RH.I_Student_Detail_ID as newStudID,  
   --TSBD.I_Status as newStatus,  
                        IP.S_Invoice_No ,
                        IP.Dt_Invoice_Date ,
                        ISNULL(IP.N_Invoice_Amount, 0.00) AS Invoice_Amount ,
                        ISNULL(IP.N_Tax_Amount, 0.00) AS Tax_Amount ,
                        ISNULL(IP.N_Discount_Amount, 0.00) AS N_Discount_Amount ,
                        Counselor_Name = LTRIM(ISNULL(UM.S_First_Name, '')
                                               + ' ')
                        + LTRIM(ISNULL(UM.S_Middle_Name, '') + ' '
                                + ISNULL(UM.S_Last_Name, '')) ,
                        FN1.CenterCode ,
                        FN1.CenterName ,
                        FN2.InstanceChain ,
                        CUM.S_Currency_Code ,
                        RH.S_Receipt_No AS Receipt_No ,
                        RH.Dt_Receipt_Date AS Receipt_Date ,
                        RH.I_Student_Detail_ID ,
                        RH.I_Enquiry_Regn_ID ,
                        RH.I_Invoice_Header_ID ,
                        RH.I_Receipt_Header_ID ,
                        RH.I_Status ,
                        -ISNULL(RH.N_Receipt_Amount, 0.00) AS Receipt_Amount ,
                        -ISNULL(RH.N_Tax_Amount, 0.00) AS Receipt_Tax ,
                        RT.S_Status_Desc AS S_Receipt_Type_Desc ,
                        ERD.S_Form_No AS S_Form_No ,
                        PMM.S_PaymentMode_Name AS Payment_Mode ,
                        RH.S_Bank_Name ,
                        CASE WHEN [RH].[I_PaymentMode_ID] = 2
                             THEN CAST([RH].[S_ChequeDD_No] AS VARCHAR(20))
                             WHEN [RH].[I_PaymentMode_ID] = 3
                             THEN CAST([RH].[S_ChequeDD_No] AS VARCHAR(20))
                             ELSE ''
                        END AS Instrument_No ,
                        RH.Dt_ChequeDD_Date ,
                        Course_Fee = -ISNULL(( SELECT   SUM(ISNULL(RCD.N_Amount_Paid,
                                                              0.00))
                                               FROM     dbo.T_Receipt_Component_Detail RCD
                                                        WITH ( NOLOCK )
                                                        INNER JOIN dbo.T_Invoice_Child_Detail ICD
                                                        WITH ( NOLOCK ) ON RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
                                               WHERE    ICD.I_Fee_Component_ID = 21
                                                        AND RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
                                             ), 0.00) ,
                        Exam_Fee = -ISNULL(( SELECT SUM(ISNULL(RCD.N_Amount_Paid,
                                                              0.00))
                                             FROM   dbo.T_Receipt_Component_Detail RCD
                                                    WITH ( NOLOCK )
                                                    INNER JOIN dbo.T_Invoice_Child_Detail ICD
                                                    WITH ( NOLOCK ) ON RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
                                             WHERE  ICD.I_Fee_Component_ID = 4
                                                    AND RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
                                           ), 0.00) ,
                        Others_Fee = -ISNULL(( SELECT   SUM(ISNULL(RCD.N_Amount_Paid,
                                                              0.00))
                                               FROM     dbo.T_Receipt_Component_Detail RCD
                                                        WITH ( NOLOCK )
                                                        INNER JOIN dbo.T_Invoice_Child_Detail ICD
                                                        WITH ( NOLOCK ) ON RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
                                               WHERE    ICD.I_Fee_Component_ID NOT IN (
                                                        21, 4 )
                                                        AND RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
                                             ), 0.00) ,
                        Tax_Component = -ISNULL(( SELECT    SUM(ISNULL(RTD.N_Tax_Paid,
                                                              0.00))
                                                  FROM      dbo.T_Receipt_Component_Detail RCD
                                                            WITH ( NOLOCK )
                                                            INNER JOIN dbo.T_Receipt_Tax_Detail RTD
                                                            WITH ( NOLOCK ) ON RCD.I_Receipt_Comp_Detail_ID = RTD.I_Receipt_Comp_Detail_ID
                                                  WHERE     RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
                                                ), 0.00) ,
                        UudatedBy = LTRIM(ISNULL(TUM.S_First_Name, '') + ' ')
                        + LTRIM(ISNULL(TUM.S_Middle_Name, '') + ' '
                                + ISNULL(TUM.S_Last_Name, '')) ,
                        RH.Dt_Crtd_On AS Dt_Upd_On ,
                        TSBM.S_Batch_Name ,
                        TSBD.S_Course_Name ,
                        dbo.fnCalculateConvenienceCharge(ISNULL(RH.N_Receipt_Amount,
                                                              0.0)
                                                         + ISNULL(RH.N_Tax_Amount,
                                                              0.0), @iBrandID,
                                                         RH.Dt_Receipt_Date,
                                                         RH.I_PaymentMode_ID) AS ConvenienceCharge,
                                                         dbo.fnCalculateConvenienceChargeTax(dbo.fnCalculateConvenienceCharge(ISNULL(RH.N_Receipt_Amount,
                                                              0.0)
                                                              + ISNULL(RH.N_Tax_Amount,
                                                              0.0), @iBrandID,
                                                              RH.Dt_Receipt_Date,
                                                              RH.I_PaymentMode_ID),
                                                            @iBrandID,
                                                            RH.Dt_Receipt_Date,
                                                            NULL) AS ConvenienceChargeTax
                FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )
                        LEFT OUTER JOIN dbo.T_User_Master UM WITH ( NOLOCK ) ON RH.S_Crtd_By = UM.S_Login_ID
                        INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) FN1 ON RH.I_Centre_Id = FN1.CenterID
                        INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,
                                                              @iBrandID) FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
                        INNER JOIN dbo.T_PaymentMode_Master PMM WITH ( NOLOCK ) ON RH.I_PaymentMode_ID = PMM.I_PaymentMode_ID
                        INNER JOIN dbo.T_Status_Master RT WITH ( NOLOCK ) ON [S_Status_Type] = 'ReceiptType'
                                                              AND RH.I_Receipt_Type = RT.I_Status_Value
                        INNER JOIN dbo.T_Centre_Master CEM WITH ( NOLOCK ) ON FN1.CenterID = CEM.I_Centre_Id
                        INNER JOIN dbo.T_Country_Master COM WITH ( NOLOCK ) ON CEM.I_Country_ID = COM.I_Country_ID
                        INNER JOIN dbo.T_Currency_Master CUM WITH ( NOLOCK ) ON COM.I_Currency_ID = CUM.I_Currency_ID
                        LEFT OUTER JOIN dbo.T_Invoice_Parent IP WITH ( NOLOCK ) ON RH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID
                        LEFT OUTER JOIN dbo.T_Student_Detail SD WITH ( NOLOCK ) ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID
                        --LEFT OUTER JOIN dbo.T_Student_Batch_Details TSBD WITH ( NOLOCK ) ON RH.I_Student_Detail_ID = TSBD.I_Student_ID --and TSBD.I_Status!=2   
                        OUTER APPLY ( SELECT TOP 1
                                                tsbd.I_Student_Batch_ID ,
                                                tsbd.I_Status ,
                                                tsbd.I_Batch_ID ,
                                                TCM.S_Course_Name
                                      FROM      dbo.T_Student_Batch_Details AS tsbd
                                                INNER JOIN dbo.T_Student_Batch_Master TSBM2 ON tsbd.I_Batch_ID = TSBM2.I_Batch_ID
                                                INNER JOIN dbo.T_Course_Master TCM ON TSBM2.I_Course_ID = TCM.I_Course_ID
                                      WHERE     tsbd.I_Student_ID = RH.I_Student_Detail_ID
                                                AND tsbd.I_Status IN ( 1, 2 )
                                                OR tsbd.I_Status IS NULL
                                      ORDER BY  tsbd.I_Student_Batch_ID DESC
                                    ) tsbd
                        LEFT OUTER JOIN dbo.T_Student_Batch_Master TSBM WITH ( NOLOCK ) ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                        LEFT OUTER JOIN dbo.T_Enquiry_Regn_Detail ERD WITH ( NOLOCK ) ON RH.I_Enquiry_Regn_ID = ERD.I_Enquiry_Regn_ID
                        LEFT OUTER JOIN DBO.T_User_Master TUM ON RH.S_Crtd_By = TUM.S_Login_ID
                WHERE   CAST(SUBSTRING(CAST(RH.Dt_Upd_On AS VARCHAR), 1, 11) AS DATETIME) BETWEEN @dtStartDate
                                                              AND
                                                              @dtEndDate
                        AND ISNULL(IP.I_Invoice_Header_ID, '') = ISNULL(RH.I_Invoice_Header_ID,
                                                              '')
                        AND RH.I_Status = 0
                        --AND ( TSBD.I_Status IS NULL
                        --      OR TSBD.I_Status = 1
                        --    )  
  
  
            END  
  
        ELSE 
            BEGIN  
                SELECT  Student_ID = CASE WHEN RH.I_Student_Detail_ID IS NOT NULL
                                          THEN SD.S_Student_ID
                                          ELSE ERD.S_Enquiry_No
                                     END ,
                        Student_Name = CASE WHEN RH.I_Student_Detail_ID IS NOT NULL
                                            THEN LTRIM(ISNULL(SD.S_First_Name,
                                                              '') + ' ')
                                                 + LTRIM(ISNULL(SD.S_Middle_Name,
                                                              '') + ' '
                                                         + ISNULL(SD.S_Last_Name,
                                                              ''))
                                            ELSE LTRIM(ISNULL(ERD.S_First_Name,
                                                              '') + ' ')
                                                 + LTRIM(ISNULL(ERD.S_Middle_Name,
                                                              '') + ' '
                                                         + ISNULL(ERD.S_Last_Name,
                                                              ''))
                                       END ,
                        IP.S_Invoice_No ,
                        IP.Dt_Invoice_Date ,
                        ISNULL(IP.N_Invoice_Amount, 0.00) AS Invoice_Amount ,
                        ISNULL(IP.N_Tax_Amount, 0.00) AS Tax_Amount ,
                        ISNULL(IP.N_Discount_Amount, 0.00) AS N_Discount_Amount ,
                        Counselor_Name = LTRIM(ISNULL(UM.S_First_Name, '')
                                               + ' ')
                        + LTRIM(ISNULL(UM.S_Middle_Name, '') + ' '
                                + ISNULL(UM.S_Last_Name, '')) ,
                        FN1.CenterCode ,
                        FN1.CenterName ,
                        FN2.InstanceChain ,
                        CUM.S_Currency_Code ,
                        RH.S_Receipt_No AS Receipt_No ,
                        RH.Dt_Receipt_Date AS Receipt_Date ,
                        RH.I_Student_Detail_ID ,
                        RH.I_Enquiry_Regn_ID ,
                        RH.I_Invoice_Header_ID ,
                        RH.I_Receipt_Header_ID ,
                        RH.I_Status ,
                        ISNULL(RH.N_Receipt_Amount, 0.00) AS Receipt_Amount ,
                        ISNULL(RH.N_Tax_Amount, 0.00) AS Receipt_Tax ,
                        RT.S_Status_Desc AS S_Receipt_Type_Desc ,
                        ERD.S_Form_No AS S_Form_No ,
                        PMM.S_PaymentMode_Name AS Payment_Mode ,
                        RH.S_Bank_Name ,
                        CASE WHEN [RH].[I_PaymentMode_ID] = 2
                             THEN CAST([RH].[S_ChequeDD_No] AS VARCHAR(20))
                             WHEN [RH].[I_PaymentMode_ID] = 3
                             THEN CAST([RH].[S_ChequeDD_No] AS VARCHAR(20))
                             ELSE ''
                        END AS Instrument_No ,
                        RH.Dt_ChequeDD_Date ,
                        Course_Fee = ISNULL(( SELECT    SUM(ISNULL(RCD.N_Amount_Paid,
                                                              0.00))
                                              FROM      dbo.T_Receipt_Component_Detail RCD
                                                        WITH ( NOLOCK )
                                                        INNER JOIN dbo.T_Invoice_Child_Detail ICD
                                                        WITH ( NOLOCK ) ON RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
                                              WHERE     ICD.I_Fee_Component_ID = 21
                                                        AND RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
                                            ), 0.00) ,
                        Exam_Fee = ISNULL(( SELECT  SUM(ISNULL(RCD.N_Amount_Paid,
                                                              0.00))
                                            FROM    dbo.T_Receipt_Component_Detail RCD
                                                    WITH ( NOLOCK )
                                                    INNER JOIN dbo.T_Invoice_Child_Detail ICD
                                                    WITH ( NOLOCK ) ON RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
                                            WHERE   ICD.I_Fee_Component_ID = 4
                                                    AND RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
                                          ), 0.00) ,
                        Others_Fee = ISNULL(( SELECT    SUM(ISNULL(RCD.N_Amount_Paid,
                                                              0.00))
                                              FROM      dbo.T_Receipt_Component_Detail RCD
                                                        WITH ( NOLOCK )
                                                        INNER JOIN dbo.T_Invoice_Child_Detail ICD
                                                        WITH ( NOLOCK ) ON RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
                                              WHERE     ICD.I_Fee_Component_ID NOT IN (
                                                        21, 4 )
                                                        AND RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
                                            ), 0.00) ,
                        Tax_Component = ISNULL(( SELECT SUM(ISNULL(RTD.N_Tax_Paid,
                                                              0.00))
                                                 FROM   dbo.T_Receipt_Component_Detail RCD
                                                        WITH ( NOLOCK )
                                                        INNER JOIN dbo.T_Receipt_Tax_Detail RTD
                                                        WITH ( NOLOCK ) ON RCD.I_Receipt_Comp_Detail_ID = RTD.I_Receipt_Comp_Detail_ID
                                                 WHERE  RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
                                               ), 0.00) ,
                        UudatedBy = LTRIM(ISNULL(TUM.S_First_Name, '') + ' ')
                        + LTRIM(ISNULL(TUM.S_Middle_Name, '') + ' '
                                + ISNULL(TUM.S_Last_Name, '')) ,
                        RH.Dt_Crtd_On AS Dt_Upd_On ,
                        TSBM.S_Batch_Name ,
                        TSBD.S_Course_Name ,
                        dbo.fnCalculateConvenienceCharge(ISNULL(RH.N_Receipt_Amount,
                                                              0.0)
                                                         + ISNULL(RH.N_Tax_Amount,
                                                              0.0), @iBrandID,
                                                         RH.Dt_Receipt_Date,
                                                         RH.I_PaymentMode_ID) AS ConvenienceCharge,
                                                         dbo.fnCalculateConvenienceChargeTax(dbo.fnCalculateConvenienceCharge(ISNULL(RH.N_Receipt_Amount,
                                                              0.0)
                                                              + ISNULL(RH.N_Tax_Amount,
                                                              0.0), @iBrandID,
                                                              RH.Dt_Receipt_Date,
                                                              RH.I_PaymentMode_ID),
                                                            @iBrandID,
                                                            RH.Dt_Receipt_Date,
                                                            NULL) AS ConvenienceChargeTax
                FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )
                        LEFT OUTER JOIN dbo.T_User_Master UM WITH ( NOLOCK ) ON RH.S_Crtd_By = UM.S_Login_ID
                        INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) FN1 ON RH.I_Centre_Id = FN1.CenterID
                        INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,
                                                              @iBrandID) FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
                        INNER JOIN dbo.T_PaymentMode_Master PMM WITH ( NOLOCK ) ON RH.I_PaymentMode_ID = PMM.I_PaymentMode_ID
                        INNER JOIN dbo.T_Status_Master RT WITH ( NOLOCK ) ON [S_Status_Type] = 'ReceiptType'
                                                              AND RH.I_Receipt_Type = RT.I_Status_Value
                        INNER JOIN dbo.T_Centre_Master CEM WITH ( NOLOCK ) ON FN1.CenterID = CEM.I_Centre_Id
                        INNER JOIN dbo.T_Country_Master COM WITH ( NOLOCK ) ON CEM.I_Country_ID = COM.I_Country_ID
                        INNER JOIN dbo.T_Currency_Master CUM WITH ( NOLOCK ) ON COM.I_Currency_ID = CUM.I_Currency_ID
                        LEFT OUTER JOIN dbo.T_Invoice_Parent IP WITH ( NOLOCK ) ON RH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID
                        LEFT OUTER JOIN dbo.T_Student_Detail SD WITH ( NOLOCK ) ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID
                        --LEFT OUTER JOIN dbo.T_Student_Batch_Details TSBD WITH ( NOLOCK ) ON RH.I_Student_Detail_ID = TSBD.I_Student_ID --and TSBD.I_Status!=2   
                        OUTER APPLY ( SELECT TOP 1
                                                tsbd.I_Student_Batch_ID ,
                                                tsbd.I_Status ,
                                                tsbd.I_Batch_ID ,
                                                TCM.S_Course_Name
                                      FROM      dbo.T_Student_Batch_Details AS tsbd
                                                INNER JOIN dbo.T_Student_Batch_Master TSBM2 ON tsbd.I_Batch_ID = TSBM2.I_Batch_ID
                                                INNER JOIN dbo.T_Course_Master TCM ON TSBM2.I_Course_ID = TCM.I_Course_ID
                                      WHERE     tsbd.I_Student_ID = RH.I_Student_Detail_ID
                                                AND tsbd.I_Status IN ( 1, 2 )
                                                OR tsbd.I_Status IS NULL
                                      ORDER BY  tsbd.I_Student_Batch_ID DESC
                                    ) tsbd
                        LEFT OUTER JOIN dbo.T_Student_Batch_Master TSBM WITH ( NOLOCK ) ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                        LEFT OUTER JOIN dbo.T_Enquiry_Regn_Detail ERD WITH ( NOLOCK ) ON RH.I_Enquiry_Regn_ID = ERD.I_Enquiry_Regn_ID
                        LEFT OUTER JOIN DBO.T_User_Master TUM ON RH.S_Crtd_By = TUM.S_Login_ID
                WHERE   CAST(SUBSTRING(CAST(RH.Dt_Receipt_Date AS VARCHAR), 1,
                                       11) AS DATETIME) BETWEEN @dtStartDate
                                                        AND   @dtEndDate
                        AND ISNULL(IP.I_Invoice_Header_ID, '') = ISNULL(RH.I_Invoice_Header_ID,
                                                              '')
                        AND RH.S_Crtd_By = @sCounselorCond
                        --AND ( TSBD.I_Status IS NULL
                        --      OR TSBD.I_Status = 1
                        --    )
                UNION ALL
                SELECT  Student_ID = CASE WHEN RH.I_Student_Detail_ID IS NOT NULL
                                          THEN SD.S_Student_ID
                                          ELSE ERD.S_Enquiry_No
                                     END ,
                        Student_Name = CASE WHEN RH.I_Student_Detail_ID IS NOT NULL
                                            THEN LTRIM(ISNULL(SD.S_First_Name,
                                                              '') + ' ')
                                                 + LTRIM(ISNULL(SD.S_Middle_Name,
                                                              '') + ' '
                                                         + ISNULL(SD.S_Last_Name,
                                                              ''))
                                            ELSE LTRIM(ISNULL(ERD.S_First_Name,
                                                              '') + ' ')
                                                 + LTRIM(ISNULL(ERD.S_Middle_Name,
                                                              '') + ' '
                                                         + ISNULL(ERD.S_Last_Name,
                                                              ''))
                                       END ,
                        IP.S_Invoice_No ,
                        IP.Dt_Invoice_Date ,
                        ISNULL(IP.N_Invoice_Amount, 0.00) AS Invoice_Amount ,
                        ISNULL(IP.N_Tax_Amount, 0.00) AS Tax_Amount ,
                        ISNULL(IP.N_Discount_Amount, 0.00) AS N_Discount_Amount ,
                        Counselor_Name = LTRIM(ISNULL(UM.S_First_Name, '')
                                               + ' ')
                        + LTRIM(ISNULL(UM.S_Middle_Name, '') + ' '
                                + ISNULL(UM.S_Last_Name, '')) ,
                        FN1.CenterCode ,
                        FN1.CenterName ,
                        FN2.InstanceChain ,
                        CUM.S_Currency_Code ,
                        RH.S_Receipt_No AS Receipt_No ,
                        RH.Dt_Receipt_Date AS Receipt_Date ,
                        RH.I_Student_Detail_ID ,
                        RH.I_Enquiry_Regn_ID ,
                        RH.I_Invoice_Header_ID ,
                        RH.I_Receipt_Header_ID ,
                        RH.I_Status ,
                        -ISNULL(RH.N_Receipt_Amount, 0.00) AS Receipt_Amount ,
                        -ISNULL(RH.N_Tax_Amount, 0.00) AS Receipt_Tax ,
                        RT.S_Status_Desc AS S_Receipt_Type_Desc ,
                        ERD.S_Form_No AS S_Form_No ,
                        PMM.S_PaymentMode_Name AS Payment_Mode ,
                        RH.S_Bank_Name ,
                        CASE WHEN [RH].[I_PaymentMode_ID] = 2
                             THEN CAST([RH].[S_ChequeDD_No] AS VARCHAR(20))
                             WHEN [RH].[I_PaymentMode_ID] = 3
                             THEN CAST([RH].[S_ChequeDD_No] AS VARCHAR(20))
                             ELSE ''
                        END AS Instrument_No ,
                        RH.Dt_ChequeDD_Date ,
                        Course_Fee = -ISNULL(( SELECT   SUM(ISNULL(RCD.N_Amount_Paid,
                                                              0.00))
                                               FROM     dbo.T_Receipt_Component_Detail RCD
                                                        WITH ( NOLOCK )
                                                        INNER JOIN dbo.T_Invoice_Child_Detail ICD
                                                        WITH ( NOLOCK ) ON RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
                                               WHERE    ICD.I_Fee_Component_ID = 21
                                                        AND RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
                                             ), 0.00) ,
                        Exam_Fee = -ISNULL(( SELECT SUM(ISNULL(RCD.N_Amount_Paid,
                                                              0.00))
                                             FROM   dbo.T_Receipt_Component_Detail RCD
                                                    WITH ( NOLOCK )
                                                    INNER JOIN dbo.T_Invoice_Child_Detail ICD
                                                    WITH ( NOLOCK ) ON RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
                                             WHERE  ICD.I_Fee_Component_ID = 4
                                                    AND RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
                                           ), 0.00) ,
                        Others_Fee = -ISNULL(( SELECT   SUM(ISNULL(RCD.N_Amount_Paid,
                                                              0.00))
                                               FROM     dbo.T_Receipt_Component_Detail RCD
                                                        WITH ( NOLOCK )
                                                        INNER JOIN dbo.T_Invoice_Child_Detail ICD
                                                        WITH ( NOLOCK ) ON RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
                                               WHERE    ICD.I_Fee_Component_ID NOT IN (
                                                        21, 4 )
                                                        AND RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
                                             ), 0.00) ,
                        Tax_Component = -ISNULL(( SELECT    SUM(ISNULL(RTD.N_Tax_Paid,
                                                              0.00))
                                                  FROM      dbo.T_Receipt_Component_Detail RCD
                                                            WITH ( NOLOCK )
                                                            INNER JOIN dbo.T_Receipt_Tax_Detail RTD
                                                            WITH ( NOLOCK ) ON RCD.I_Receipt_Comp_Detail_ID = RTD.I_Receipt_Comp_Detail_ID
                                                  WHERE     RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
                                                ), 0.00) ,
                        UudatedBy = LTRIM(ISNULL(TUM.S_First_Name, '') + ' ')
                        + LTRIM(ISNULL(TUM.S_Middle_Name, '') + ' '
                                + ISNULL(TUM.S_Last_Name, '')) ,
                        RH.Dt_Crtd_On AS Dt_Upd_On ,
                        TSBM.S_Batch_Name ,
                        TSBD.S_Course_Name ,
                        dbo.fnCalculateConvenienceCharge(ISNULL(RH.N_Receipt_Amount,
                                                              0.0)
                                                         + ISNULL(RH.N_Tax_Amount,
                                                              0.0), @iBrandID,
                                                         RH.Dt_Receipt_Date,
                                                         RH.I_PaymentMode_ID) AS ConvenienceCharge,
                                                         dbo.fnCalculateConvenienceChargeTax(dbo.fnCalculateConvenienceCharge(ISNULL(RH.N_Receipt_Amount,
                                                              0.0)
                                                              + ISNULL(RH.N_Tax_Amount,
                                                              0.0), @iBrandID,
                                                              RH.Dt_Receipt_Date,
                                                              RH.I_PaymentMode_ID),
                                                            @iBrandID,
                                                            RH.Dt_Receipt_Date,
                                                            NULL) AS ConvenienceChargeTax
                FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )
                        LEFT OUTER JOIN dbo.T_User_Master UM WITH ( NOLOCK ) ON RH.S_Crtd_By = UM.S_Login_ID
                        INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) FN1 ON RH.I_Centre_Id = FN1.CenterID
                        INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,
                                                              @iBrandID) FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
                        INNER JOIN dbo.T_PaymentMode_Master PMM WITH ( NOLOCK ) ON RH.I_PaymentMode_ID = PMM.I_PaymentMode_ID
                        INNER JOIN dbo.T_Status_Master RT WITH ( NOLOCK ) ON [S_Status_Type] = 'ReceiptType'
                                                              AND RH.I_Receipt_Type = RT.I_Status_Value
                        INNER JOIN dbo.T_Centre_Master CEM WITH ( NOLOCK ) ON FN1.CenterID = CEM.I_Centre_Id
                        INNER JOIN dbo.T_Country_Master COM WITH ( NOLOCK ) ON CEM.I_Country_ID = COM.I_Country_ID
                        INNER JOIN dbo.T_Currency_Master CUM WITH ( NOLOCK ) ON COM.I_Currency_ID = CUM.I_Currency_ID
                        LEFT OUTER JOIN dbo.T_Invoice_Parent IP WITH ( NOLOCK ) ON RH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID
                        LEFT OUTER JOIN dbo.T_Student_Detail SD WITH ( NOLOCK ) ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID
                        --LEFT OUTER JOIN dbo.T_Student_Batch_Details TSBD WITH ( NOLOCK ) ON RH.I_Student_Detail_ID = TSBD.I_Student_ID --and TSBD.I_Status!=2   
                        OUTER APPLY ( SELECT TOP 1
                                                tsbd.I_Student_Batch_ID ,
                                                tsbd.I_Status ,
                                                tsbd.I_Batch_ID ,
                                                TCM.S_Course_Name
                                      FROM      dbo.T_Student_Batch_Details AS tsbd
                                                INNER JOIN dbo.T_Student_Batch_Master TSBM2 ON tsbd.I_Batch_ID = TSBM2.I_Batch_ID
                                                INNER JOIN dbo.T_Course_Master TCM ON TSBM2.I_Course_ID = TCM.I_Course_ID
                                      WHERE     tsbd.I_Student_ID = RH.I_Student_Detail_ID
                                                AND tsbd.I_Status IN ( 1, 2 )
                                                OR tsbd.I_Status IS NULL
                                      ORDER BY  tsbd.I_Student_Batch_ID DESC
                                    ) tsbd
                        LEFT OUTER JOIN dbo.T_Student_Batch_Master TSBM WITH ( NOLOCK ) ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                        LEFT OUTER JOIN dbo.T_Enquiry_Regn_Detail ERD WITH ( NOLOCK ) ON RH.I_Enquiry_Regn_ID = ERD.I_Enquiry_Regn_ID
                        LEFT OUTER JOIN DBO.T_User_Master TUM ON RH.S_Crtd_By = TUM.S_Login_ID
                WHERE   CAST(SUBSTRING(CAST(RH.Dt_Upd_On AS VARCHAR), 1, 11) AS DATETIME) BETWEEN @dtStartDate
                                                              AND
                                                              @dtEndDate
                        AND ISNULL(IP.I_Invoice_Header_ID, '') = ISNULL(RH.I_Invoice_Header_ID,
                                                              '')
                        AND RH.I_Status = 0
                        AND RH.S_Crtd_By = @sCounselorCond
                        --AND ( TSBD.I_Status IS NULL
                        --      OR TSBD.I_Status = 1
                        --    )  
            END  
  
    END TRY  
  
    BEGIN CATCH  
  
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT  
  
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()  
  
        RAISERROR(@ErrMsg, @ErrSeverity, 1)  
  
    END CATCH
