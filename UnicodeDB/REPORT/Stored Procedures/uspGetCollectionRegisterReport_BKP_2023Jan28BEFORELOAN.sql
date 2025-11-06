
        
 CREATE PROCEDURE [REPORT].[uspGetCollectionRegisterReport_BKP_2023Jan28BEFORELOAN] 
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
        
        DECLARE @dtSDate DATETIME
        DECLARE @dtEDate DATETIME
        DECLARE @BrandID INT
        DECLARE @HierarchyList VARCHAR(MAX)
        DECLARE @Counsellor VARCHAR(20)
        
        SET @HierarchyList=@sHierarchyList
        SET @BrandID=@iBrandID
        SET @dtSDate=@dtStartDate
        SET @dtEDate=@dtEndDate
        SET @Counsellor=@sCounselorCond  

       DECLARE @iStartDate INT ,
            @iEndDate INT

        SET @iStartDate = CONVERT(INT, CONVERT(VARCHAR(8), @dtSDate, 112))

        SET @iEndDate = CONVERT(INT, CONVERT(VARCHAR(8), @dtEDate, 112))

        DECLARE @rtnTable1 TABLE
            (
              brandID INT ,
              hierarchyDetailID INT ,
              centerID INT ,
              centerCode VARCHAR(20) ,
              centerName VARCHAR(100)
            )
        INSERT  INTO @rtnTable1
                ( hierarchyDetailID ,
                  centerID ,
                  centerCode ,
                  centerName
                )
                SELECT  hierarchyDetailID ,
                        centerID ,
                        centerCode ,
                        centerName
                FROM    [dbo].[fnGetCentersForReports](@HierarchyList,
                                                       @BrandID)
        DECLARE @rtnTable2 TABLE
            (
              hierarchyDetailID INT ,
              instanceChain VARCHAR(5000)
            )
        INSERT  INTO @rtnTable2
                ( hierarchyDetailID ,
                  instanceChain
                )
                SELECT  hierarchyDetailID ,
                        instanceChain
                FROM    [dbo].[fnGetInstanceNameChainForReports](@HierarchyList,
                                                              @BrandID)
                                                              
        IF OBJECT_ID('tempdb..#CollectionRegister') IS NOT NULL 
            BEGIN
                DROP TABLE #CollectionRegister
            END     
			
        IF OBJECT_ID('tempdb..#StudentBatch') IS NOT NULL 
            BEGIN
                DROP TABLE #StudentBatch
            END
			
			                                               
         
        CREATE TABLE #CollectionRegister
            (
              Student_ID VARCHAR(500) ,
              Student_Name VARCHAR(200) ,
              S_Invoice_No VARCHAR(50) ,
              Dt_Invoice_Date DATETIME ,
              Invoice_Amount NUMERIC(18, 2) ,
              Tax_Amount NUMERIC(18, 2) ,
              N_Discount_Amount NUMERIC(18, 2) ,
              Counselor_Name VARCHAR(500) ,
              CenterCode VARCHAR(20) ,
              CenterName VARCHAR(100) ,
			  TypeofCentre VARCHAR(MAX),
              InstanceChain VARCHAR(5000) ,
              S_Currency_Code VARCHAR(20) ,
              Receipt_No VARCHAR(20) ,
              Receipt_Date DATETIME ,
              ReceiptMonthYear VARCHAR(20) ,
              I_Student_Detail_ID INT ,
              I_Enquiry_Regn_ID INT ,
              I_Invoice_Header_ID INT ,
              I_Receipt_Header_ID INT ,
              I_Status INT ,
              Receipt_Amount NUMERIC(18, 2) ,
              Receipt_Tax NUMERIC(18, 2) ,
              S_Receipt_Type_Desc VARCHAR(100) ,
              S_Form_No VARCHAR(100) ,
              Payment_Mode VARCHAR(50) ,
              S_Bank_Name VARCHAR(200) ,
              Instrument_No VARCHAR(20) ,
              Dt_ChequeDD_Date DATETIME ,
              Course_Fee NUMERIC(18, 2) ,
              Exam_Fee NUMERIC(18, 2) ,
              Others_Fee NUMERIC(18, 2) ,
              Tax_Component NUMERIC(18, 2) ,
              UudatedBy VARCHAR(500) ,
              Dt_Upd_On DATETIME ,
              S_Batch_Name VARCHAR(100) ,
              S_Course_Name VARCHAR(100) ,
              ConvenienceCharge DECIMAL(18, 4) ,
              ConvenienceChargeTax NUMERIC(18, 2) ,
              
              I_PaymentMode_ID INT ,
              S_Crtd_By VARCHAR(20),
              SettlementDate DATETIME,
              BankAccount VARCHAR(MAX)
            )
			
         
        IF @Counsellor = 'ALL' 
            BEGIN
                INSERT  INTO #CollectionRegister
                        SELECT  NULL AS Student_ID ,
                                NULL AS Student_Name ,  
   --RH.I_Student_Detail_ID as newStudID,  
   --TSBD.I_Status as newStatus,  
                                NULL AS S_Invoice_No ,
                                NULL AS Dt_Invoice_Date ,
                                0.00 AS Invoice_Amount ,
                                0.00 AS Tax_Amount ,
                                0.00 AS N_Discount_Amount ,
                                NULL AS Counselor_Name ,
                                FN1.CenterCode ,
                                FN1.CenterName ,
                                CASE WHEN FN1.centerCode LIKE 'IAS T%' THEN 'IAS'
                                WHEN FN1.centerCode LIKE 'Judiciary T%' THEN 'Judiciary'
                                WHEN FN1.centerCode='BRST' THEN 'AIPT'
                                WHEN FN1.centerCode LIKE 'FR-%' THEN 'Franchise'
                                ELSE 'Own' END AS TypeofCentre,
                                FN2.InstanceChain ,
                                CUM.S_Currency_Code ,
                                RH.S_Receipt_No AS Receipt_No ,
                                RH.Dt_Receipt_Date AS Receipt_Date ,
                                DATENAME(MONTH, RH.Dt_Receipt_Date) + ' '
                                + CAST(DATEPART(YYYY, RH.Dt_Receipt_Date) AS VARCHAR) AS ReceiptMonthYear ,
                                RH.I_Student_Detail_ID ,
                                RH.I_Enquiry_Regn_ID ,
                                RH.I_Invoice_Header_ID ,
                                RH.I_Receipt_Header_ID ,
                                RH.I_Status ,
                                ISNULL(RH.N_Receipt_Amount, 0.00) AS Receipt_Amount ,
                                ISNULL(RH.N_Tax_Amount, 0.00) AS Receipt_Tax ,
                                RT.S_Status_Desc AS S_Receipt_Type_Desc ,
                                NULL AS S_Form_No ,
                                PMM.S_PaymentMode_Name AS Payment_Mode ,
                                RH.S_Bank_Name ,
                                CASE WHEN [RH].[I_PaymentMode_ID] = 2
                                     THEN CAST([RH].[S_ChequeDD_No] AS VARCHAR(20))
                                     WHEN [RH].[I_PaymentMode_ID] = 3
                                     THEN CAST([RH].[S_ChequeDD_No] AS VARCHAR(20))
									 WHEN [RH].[I_PaymentMode_ID] = 27
                                     THEN CAST([RH].[S_ChequeDD_No] AS VARCHAR(20))
                                     ELSE ''
                                END AS Instrument_No ,
                                RH.Dt_ChequeDD_Date ,
                                Course_Fee = 0.00 ,
                                Exam_Fee = 0.00 ,
                                Others_Fee = 0.00 ,
                                Tax_Component = 0.00 ,
                                NULL AS UudatedBy ,
                                RH.Dt_Upd_On AS Dt_Upd_On ,
                                NULL AS S_Batch_Name ,
                                NULL AS S_Course_Name ,
                               -(  CAST(ISNULL(dbo.fnCalculateConvenienceCharge(ISNULL(RH.N_Receipt_Amount,
                                                              0.0)
                                                         + ISNULL(RH.N_Tax_Amount,
                                                              0.0), @BrandID,
                                                         RH.Dt_Receipt_Date,
                                                         RH.I_PaymentMode_ID),0.00) AS DECIMAL(18,4))) ,
                                0 ,
                                [RH].[I_PaymentMode_ID] ,
                                RH.S_Crtd_By,
                                RH.Dt_Deposit_Date,
                                RH.Bank_Account_Name
                                
                                
                        FROM    dbo.T_Receipt_Header RH
                                INNER JOIN @rtnTable1 FN1 ON RH.I_Centre_Id = FN1.CenterID
                                INNER JOIN @rtnTable2 FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
                                INNER JOIN dbo.T_PaymentMode_Master PMM WITH ( NOLOCK ) ON RH.I_PaymentMode_ID = PMM.I_PaymentMode_ID
                                INNER JOIN dbo.T_Status_Master RT WITH ( NOLOCK ) ON [S_Status_Type] = 'ReceiptType'
                                                              AND RH.I_Receipt_Type = RT.I_Status_Value
                                INNER JOIN dbo.T_Centre_Master CEM WITH ( NOLOCK ) ON FN1.CenterID = CEM.I_Centre_Id
                                INNER JOIN dbo.T_Country_Master COM WITH ( NOLOCK ) ON CEM.I_Country_ID = COM.I_Country_ID
                                INNER JOIN dbo.T_Currency_Master CUM WITH ( NOLOCK ) ON COM.I_Currency_ID = CUM.I_Currency_ID
                        WHERE   CAST(SUBSTRING(CAST(RH.Dt_Receipt_Date AS VARCHAR),
                                               1, 11) AS DATETIME) BETWEEN @dtSDate
                                                              AND
                                                              @dtEDate
						--CONVERT(DATE,RH.Dt_Receipt_Date) BETWEEN @dtSDate AND   @dtEDate
                        --AND ( TSBD.I_Status IS NULL
                        --      OR TSBD.I_Status = 1
                        --    )
                        UNION ALL
                        SELECT  NULL AS Student_ID ,
                                NULL AS Student_Name ,  
   --RH.I_Student_Detail_ID as newStudID,  
   --TSBD.I_Status as newStatus,  
                                NULL AS S_Invoice_No ,
                                NULL AS Dt_Invoice_Date ,
                                0.00 AS Invoice_Amount ,
                                0.00 AS Tax_Amount ,
                                0.00 AS N_Discount_Amount ,
                                NULL AS Counselor_Name ,
                                FN1.CenterCode ,
                                FN1.CenterName ,
                                CASE WHEN FN1.centerCode LIKE 'IAS T%' THEN 'IAS'
                                WHEN FN1.centerCode LIKE 'Judiciary T%' THEN 'Judiciary'
                                WHEN FN1.centerCode='BRST' THEN 'AIPT'
                                WHEN FN1.centerCode LIKE 'FR-%' THEN 'Franchise'
                                ELSE 'Own' END AS TypeofCentre,
                                FN2.InstanceChain ,
                                CUM.S_Currency_Code ,
                                RH.S_Receipt_No AS Receipt_No ,
                                RH.Dt_Receipt_Date AS Receipt_Date ,
                                DATENAME(MONTH, RH.Dt_Receipt_Date) + ' '
                                + CAST(DATEPART(YYYY, RH.Dt_Receipt_Date) AS VARCHAR) AS ReceiptMonthYear ,
                                RH.I_Student_Detail_ID ,
                                RH.I_Enquiry_Regn_ID ,
                                RH.I_Invoice_Header_ID ,
                                RH.I_Receipt_Header_ID ,
                                RH.I_Status ,
                                -ISNULL(RH.N_Receipt_Amount, 0.00) AS Receipt_Amount ,
                                -ISNULL(RH.N_Tax_Amount, 0.00) AS Receipt_Tax ,
                                RT.S_Status_Desc AS S_Receipt_Type_Desc ,
                                NULL AS S_Form_No ,
                                PMM.S_PaymentMode_Name AS Payment_Mode ,
                                RH.S_Bank_Name ,
                                CASE WHEN [RH].[I_PaymentMode_ID] = 2
                                     THEN CAST([RH].[S_ChequeDD_No] AS VARCHAR(20))
                                     WHEN [RH].[I_PaymentMode_ID] = 3
                                     THEN CAST([RH].[S_ChequeDD_No] AS VARCHAR(20))
									 WHEN [RH].[I_PaymentMode_ID] = 27
                                     THEN CAST([RH].[S_ChequeDD_No] AS VARCHAR(20))
                                     ELSE ''
                                END AS Instrument_No ,
                                RH.Dt_ChequeDD_Date ,
                                Course_Fee = 0.00 ,
                                Exam_Fee = 0.00 ,
                                Others_Fee = 0.00 ,
                                Tax_Component = 0.00 ,
                                NULL AS UudatedBy ,
                                RH.Dt_Upd_On AS Dt_Upd_On ,
                                NULL AS S_Batch_Name ,
                                NULL AS S_Course_Name ,                               
                                (  CAST(ISNULL(dbo.fnCalculateConvenienceCharge(ISNULL(RH.N_Receipt_Amount,
                                                              0.0)
                                                         + ISNULL(RH.N_Tax_Amount,
                                                              0.0), @BrandID,
                                                         RH.Dt_Receipt_Date,
                                                         RH.I_PaymentMode_ID),0.00) AS DECIMAL(18,4))),
                                0 ,
                                [RH].[I_PaymentMode_ID] ,
                                RH.S_Crtd_By,
                                RH.Dt_Deposit_Date,
                                RH.Bank_Account_Name
                        FROM    dbo.T_Receipt_Header RH
                                INNER JOIN @rtnTable1 FN1 ON RH.I_Centre_Id = FN1.CenterID
                                INNER JOIN @rtnTable2 FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
                                INNER JOIN dbo.T_PaymentMode_Master PMM WITH ( NOLOCK ) ON RH.I_PaymentMode_ID = PMM.I_PaymentMode_ID
                                INNER JOIN dbo.T_Status_Master RT WITH ( NOLOCK ) ON [S_Status_Type] = 'ReceiptType'
                                                              AND RH.I_Receipt_Type = RT.I_Status_Value
                                INNER JOIN dbo.T_Centre_Master CEM WITH ( NOLOCK ) ON FN1.CenterID = CEM.I_Centre_Id
                                INNER JOIN dbo.T_Country_Master COM WITH ( NOLOCK ) ON CEM.I_Country_ID = COM.I_Country_ID
                                INNER JOIN dbo.T_Currency_Master CUM WITH ( NOLOCK ) ON COM.I_Currency_ID = CUM.I_Currency_ID
                     
                        --LEFT OUTER JOIN dbo.T_Student_Batch_Details TSBD WITH ( NOLOCK ) ON RH.I_Student_Detail_ID = TSBD.I_Student_ID --and TSBD.I_Status!=2   
                        WHERE   CAST(SUBSTRING(CAST(RH.Dt_Upd_On AS VARCHAR),
                                               1, 11) AS DATETIME) BETWEEN @dtSDate
                                                              AND
                                                              @dtEDate
                                AND RH.I_Status = 0
                        --AND ( TSBD.I_Status IS NULL
                        --      OR TSBD.I_Status = 1
                        --    )  
            END 
        ELSE 
            BEGIN
                INSERT  INTO #CollectionRegister
                        SELECT  NULL AS Student_ID ,
                                NULL AS Student_Name ,  
   --RH.I_Student_Detail_ID as newStudID,  
   --TSBD.I_Status as newStatus,  
                                NULL AS S_Invoice_No ,
                                NULL AS Dt_Invoice_Date ,
                                0.00 AS Invoice_Amount ,
                                0.00 AS Tax_Amount ,
                                0.00 AS N_Discount_Amount ,
                                NULL AS Counselor_Name ,
                                FN1.CenterCode ,
                                FN1.CenterName ,
                                CASE WHEN FN1.centerCode LIKE 'IAS T%' THEN 'IAS'
                                WHEN FN1.centerCode LIKE 'Judiciary T%' THEN 'Judiciary'
                                WHEN FN1.centerCode='BRST' THEN 'AIPT'
                                WHEN FN1.centerCode LIKE 'FR-%' THEN 'Franchise'
                                ELSE 'Own' END AS TypeofCentre,
                                FN2.InstanceChain ,
                                CUM.S_Currency_Code ,
                                RH.S_Receipt_No AS Receipt_No ,
                                RH.Dt_Receipt_Date AS Receipt_Date ,
                                DATENAME(MONTH, RH.Dt_Receipt_Date) + ' '
                                + CAST(DATEPART(YYYY, RH.Dt_Receipt_Date) AS VARCHAR) AS ReceiptMonthYear ,
                                RH.I_Student_Detail_ID ,
                                RH.I_Enquiry_Regn_ID ,
                                RH.I_Invoice_Header_ID ,
                                RH.I_Receipt_Header_ID ,
                                RH.I_Status ,
                                ISNULL(RH.N_Receipt_Amount, 0.00) AS Receipt_Amount ,
                                ISNULL(RH.N_Tax_Amount, 0.00) AS Receipt_Tax ,
                                RT.S_Status_Desc AS S_Receipt_Type_Desc ,
                                NULL AS S_Form_No ,
                                PMM.S_PaymentMode_Name AS Payment_Mode ,
                                RH.S_Bank_Name ,
                                CASE WHEN [RH].[I_PaymentMode_ID] = 2
                                     THEN CAST([RH].[S_ChequeDD_No] AS VARCHAR(20))
                                     WHEN [RH].[I_PaymentMode_ID] = 3
                                     THEN CAST([RH].[S_ChequeDD_No] AS VARCHAR(20))
									 WHEN [RH].[I_PaymentMode_ID] = 27
                                     THEN CAST([RH].[S_ChequeDD_No] AS VARCHAR(20))
                                     ELSE ''
                                END AS Instrument_No ,
                                RH.Dt_ChequeDD_Date ,
                                Course_Fee = 0.00 ,
                                Exam_Fee = 0.00 ,
                                Others_Fee = 0.00 ,
                                Tax_Component = 0.00 ,
                                NULL AS UudatedBy ,
                                RH.Dt_Upd_On AS Dt_Upd_On ,
                                NULL AS S_Batch_Name ,
                                NULL AS S_Course_Name ,
                                 -CAST(ISNULL(dbo.fnCalculateConvenienceCharge(ISNULL(RH.N_Receipt_Amount,
                                                              0.0)
                                                         + ISNULL(RH.N_Tax_Amount,
                                                              0.0), @BrandID,
                                                         RH.Dt_Receipt_Date,
                                                         RH.I_PaymentMode_ID),0.00) AS DECIMAL(18,4)) ,
                                0 ,
                                [RH].[I_PaymentMode_ID] ,
                                RH.S_Crtd_By,
                                RH.Dt_Deposit_Date,
                                RH.Bank_Account_Name
                        FROM    dbo.T_Receipt_Header RH
                                INNER JOIN @rtnTable1 FN1 ON RH.I_Centre_Id = FN1.CenterID
                                INNER JOIN @rtnTable2 FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
                                INNER JOIN dbo.T_PaymentMode_Master PMM WITH ( NOLOCK ) ON RH.I_PaymentMode_ID = PMM.I_PaymentMode_ID
                                INNER JOIN dbo.T_Status_Master RT WITH ( NOLOCK ) ON [S_Status_Type] = 'ReceiptType'
                                                              AND RH.I_Receipt_Type = RT.I_Status_Value
                                INNER JOIN dbo.T_Centre_Master CEM WITH ( NOLOCK ) ON FN1.CenterID = CEM.I_Centre_Id
                                INNER JOIN dbo.T_Country_Master COM WITH ( NOLOCK ) ON CEM.I_Country_ID = COM.I_Country_ID
                                INNER JOIN dbo.T_Currency_Master CUM WITH ( NOLOCK ) ON COM.I_Currency_ID = CUM.I_Currency_ID
                        WHERE   CAST(SUBSTRING(CAST(RH.Dt_Receipt_Date AS VARCHAR),
                                               1, 11) AS DATETIME) BETWEEN @dtSDate
                                                              AND
                                                              @dtEDate
						--CONVERT(DATE,RH.Dt_Receipt_Date) BETWEEN @dtSDate AND   @dtEDate
                                AND RH.S_Crtd_By = @Counsellor
                        --AND ( TSBD.I_Status IS NULL
                        --      OR TSBD.I_Status = 1
                        --    )
                        UNION ALL
                        SELECT  NULL AS Student_ID ,
                                NULL AS Student_Name ,  
   --RH.I_Student_Detail_ID as newStudID,  
   --TSBD.I_Status as newStatus,  
                                NULL AS S_Invoice_No ,
                                NULL AS Dt_Invoice_Date ,
                                0.00 AS Invoice_Amount ,
                                0.00 AS Tax_Amount ,
                                0.00 AS N_Discount_Amount ,
                                NULL AS Counselor_Name ,
                                FN1.CenterCode ,
                                FN1.CenterName ,
                                CASE WHEN FN1.centerCode LIKE 'IAS T%' THEN 'IAS'
                                WHEN FN1.centerCode LIKE 'Judiciary T%' THEN 'Judiciary'
                                WHEN FN1.centerCode='BRST' THEN 'AIPT'
                                WHEN FN1.centerCode LIKE 'FR-%' THEN 'Franchise'
                                ELSE 'Own' END AS TypeofCentre,
                                FN2.InstanceChain ,
                                CUM.S_Currency_Code ,
                                RH.S_Receipt_No AS Receipt_No ,
                                RH.Dt_Receipt_Date AS Receipt_Date ,
                                DATENAME(MONTH, RH.Dt_Receipt_Date) + ' '
                                + CAST(DATEPART(YYYY, RH.Dt_Receipt_Date) AS VARCHAR) AS ReceiptMonthYear ,
                                RH.I_Student_Detail_ID ,
                                RH.I_Enquiry_Regn_ID ,
                                RH.I_Invoice_Header_ID ,
                                RH.I_Receipt_Header_ID ,
                                RH.I_Status ,
                                -ISNULL(RH.N_Receipt_Amount, 0.00) AS Receipt_Amount ,
                                -ISNULL(RH.N_Tax_Amount, 0.00) AS Receipt_Tax ,
                                RT.S_Status_Desc AS S_Receipt_Type_Desc ,
                                NULL AS S_Form_No ,
                                PMM.S_PaymentMode_Name AS Payment_Mode ,
                                RH.S_Bank_Name ,
                                CASE WHEN [RH].[I_PaymentMode_ID] = 2
                                     THEN CAST([RH].[S_ChequeDD_No] AS VARCHAR(20))
                                     WHEN [RH].[I_PaymentMode_ID] = 3
                                     THEN CAST([RH].[S_ChequeDD_No] AS VARCHAR(20))
									 WHEN [RH].[I_PaymentMode_ID] = 27
                                     THEN CAST([RH].[S_ChequeDD_No] AS VARCHAR(20))
                                     ELSE ''
                                END AS Instrument_No ,
                                RH.Dt_ChequeDD_Date ,
                                Course_Fee = 0.00 ,
                                Exam_Fee = 0.00 ,
                                Others_Fee = 0.00 ,
                                Tax_Component = 0.00 ,
                                NULL AS UudatedBy ,
                                RH.Dt_Upd_On AS Dt_Upd_On ,
                                NULL AS S_Batch_Name ,
                                NULL AS S_Course_Name ,
                                 CAST(ISNULL(dbo.fnCalculateConvenienceCharge(ISNULL(RH.N_Receipt_Amount,
                                                              0.0)
                                                         + ISNULL(RH.N_Tax_Amount,
                                                              0.0), @BrandID,
                                                         RH.Dt_Receipt_Date,
                                                         RH.I_PaymentMode_ID),0.00) AS DECIMAL(18,4)) ,
                                0 ,
                                [RH].[I_PaymentMode_ID] ,
                                RH.S_Crtd_By,
                                RH.Dt_Deposit_Date,
                                RH.Bank_Account_Name
                        FROM    dbo.T_Receipt_Header RH
                                INNER JOIN @rtnTable1 FN1 ON RH.I_Centre_Id = FN1.CenterID
                                INNER JOIN @rtnTable2 FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
                                INNER JOIN dbo.T_PaymentMode_Master PMM WITH ( NOLOCK ) ON RH.I_PaymentMode_ID = PMM.I_PaymentMode_ID
                                INNER JOIN dbo.T_Status_Master RT WITH ( NOLOCK ) ON [S_Status_Type] = 'ReceiptType'
                                                              AND RH.I_Receipt_Type = RT.I_Status_Value
                                INNER JOIN dbo.T_Centre_Master CEM WITH ( NOLOCK ) ON FN1.CenterID = CEM.I_Centre_Id
                                INNER JOIN dbo.T_Country_Master COM WITH ( NOLOCK ) ON CEM.I_Country_ID = COM.I_Country_ID
                                INNER JOIN dbo.T_Currency_Master CUM WITH ( NOLOCK ) ON COM.I_Currency_ID = CUM.I_Currency_ID
                     
                        --LEFT OUTER JOIN dbo.T_Student_Batch_Details TSBD WITH ( NOLOCK ) ON RH.I_Student_Detail_ID = TSBD.I_Student_ID --and TSBD.I_Status!=2   
                        WHERE   CAST(SUBSTRING(CAST(RH.Dt_Upd_On AS VARCHAR),
                                               1, 11) AS DATETIME) BETWEEN @dtSDate
                                                              AND
                                                              @dtEDate
                                AND RH.I_Status = 0
                                AND RH.S_Crtd_By = @Counsellor
                        --AND ( TSBD.I_Status IS NULL
                        --      OR TSBD.I_Status = 1
                        --    )  
            END
		
        UPDATE  T
        SET     T.Student_ID = SD.S_Student_ID ,
                T.Student_Name = LTRIM(ISNULL(SD.S_First_Name, '') + ' ')
                + LTRIM(ISNULL(SD.S_Middle_Name, '') + ' '
                        + ISNULL(SD.S_Last_Name, ''))
        FROM    #CollectionRegister T
                INNER JOIN dbo.T_Student_Detail SD WITH ( NOLOCK ) ON T.I_Student_Detail_ID = SD.I_Student_Detail_ID
			
        UPDATE  T
        SET     T.Student_ID = ERD.S_Enquiry_No ,
                T.Student_Name = LTRIM(ISNULL(ERD.S_First_Name, '') + ' ')
                + LTRIM(ISNULL(ERD.S_Middle_Name, '') + ' '
                        + ISNULL(ERD.S_Last_Name, '')) ,
                T.S_Form_No = ERD.S_Form_No
        FROM    #CollectionRegister T
                INNER JOIN dbo.T_Enquiry_Regn_Detail ERD WITH ( NOLOCK ) ON T.I_Enquiry_Regn_ID = ERD.I_Enquiry_Regn_ID
                                                              AND T.I_Student_Detail_ID IS NULL
		/* Commented on 10.12.2021
        UPDATE  T
        SET     T.S_Invoice_No = IP.S_Invoice_No ,
                T.Dt_Invoice_Date = IP.Dt_Invoice_Date ,
                T.Invoice_Amount = ISNULL(IP.N_Invoice_Amount, 0.00) ,
                T.Tax_Amount = ISNULL(IP.N_Tax_Amount, 0.00) ,
                T.N_Discount_Amount = ISNULL(IP.N_Discount_Amount, 0.00)
        FROM    #CollectionRegister T
                INNER JOIN T_Invoice_Parent IP WITH ( NOLOCK ) ON IP.I_Invoice_Header_ID = T.I_Invoice_Header_ID

		Commented on 10.12.2021 */


		UPDATE #CollectionRegister
        SET S_Invoice_No = z.S_Invoice_No ,
            Dt_Invoice_Date = z.Dt_Invoice_Date ,
            Invoice_Amount = ISNULL(z.N_Invoice_Amount, 0.00) ,
            Tax_Amount = ISNULL(z.N_Tax_Amount, 0.00) ,
            N_Discount_Amount = ISNULL(z.N_Discount_Amount, 0.00),
			S_Batch_Name=z.S_Batch_Name,
			S_Course_Name=z.S_Course_Name
        FROM  #CollectionRegister T  
		INNER JOIN
		(
		select distinct IP.I_Student_Detail_ID, IP.I_Invoice_Header_ID, IP.S_Invoice_No , IP.Dt_Invoice_Date ,IP.N_Invoice_Amount ,IP.N_Tax_Amount ,
		IP.N_Discount_Amount,T1.S_Batch_Name,T1.S_Course_Name
		FROM   T_Invoice_Parent IP WITH ( NOLOCK )
		INNER JOIN
		(
		select distinct ICH.I_Invoice_Header_ID,TCM.S_Course_Name,SBM.S_Batch_Name FROM T_Invoice_Child_Header ICH
		INNER JOIN T_Invoice_Batch_Map IBM  WITH (NOLOCK) ON ICH.I_Invoice_Child_Header_ID=IBM.I_Invoice_Child_Header_ID
		INNER JOIN T_Student_Batch_Master SBM WITH (NOLOCK) ON SBM.I_Batch_ID=IBM.I_Batch_ID
		INNER JOIN dbo.T_Course_Master TCM WITH ( NOLOCK ) ON SBM.I_Course_ID = TCM.I_Course_ID and ICH.I_Course_ID=TCM.I_Course_ID
		)T1 on T1.I_Invoice_Header_ID=IP.I_Invoice_Header_ID
		) as z on T.I_Invoice_Header_ID=z.I_Invoice_Header_ID and T.I_Student_Detail_ID=z.I_Student_Detail_ID


			
			/*Following fields 0 in new sp
			UPDATE RH
				SET RH.Course_Fee = (SELECT SUM(RCD.N_Amount_Paid) 
				FROM  dbo.T_Receipt_Component_Detail RCD  WITH ( NOLOCK ) 
             INNER JOIN dbo.T_Invoice_Child_Detail ICD WITH ( NOLOCK ) ON RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
			WHERE ICD.I_Fee_Component_ID =21
				AND RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID )			
			FROM  #CollectionRegister RH
			
			UPDATE RH
				SET RH.Exam_Fee = (SELECT SUM(RCD.N_Amount_Paid) 
				FROM  dbo.T_Receipt_Component_Detail RCD  WITH ( NOLOCK ) 
             INNER JOIN dbo.T_Invoice_Child_Detail ICD WITH ( NOLOCK ) ON RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
			WHERE ICD.I_Fee_Component_ID =4
				AND RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID )			
			FROM  #CollectionRegister RH
			
			UPDATE RH
				SET RH.Others_Fee = (SELECT SUM(RCD.N_Amount_Paid) 
				FROM  dbo.T_Receipt_Component_Detail RCD  WITH ( NOLOCK ) 
             INNER JOIN dbo.T_Invoice_Child_Detail ICD WITH ( NOLOCK ) ON RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
			WHERE ICD.I_Fee_Component_ID NOT IN (21,4)
				AND RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID )			
			FROM  #CollectionRegister RH
			
			UPDATE RH
				SET RH.Tax_Component = (SELECT SUM(RTD.N_Tax_Paid) 
				FROM  dbo.T_Receipt_Component_Detail RCD  WITH ( NOLOCK ) 
                    INNER JOIN T_Receipt_Tax_Detail RTD WITH ( NOLOCK ) ON RCD.I_Receipt_Comp_Detail_ID = RTD.I_Receipt_Comp_Detail_ID
			WHERE  RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID )			
			FROM  #CollectionRegister RH
			*/
			
		
                            
       UPDATE  #CollectionRegister
        SET     ConvenienceChargeTax = CAST(ISNULL(ROUND(dbo.fnCalculateConvenienceChargeTax(ConvenienceCharge,@BrandID,
                                                            Receipt_Date,
                                                            NULL),2),0.0) AS DECIMAL(14,2))


			
			
        UPDATE  T
        SET     T.Counselor_Name = LTRIM(ISNULL(UM.S_First_Name, '') + ' ')
                + LTRIM(ISNULL(UM.S_Middle_Name, '') + ' '
                        + ISNULL(UM.S_Last_Name, ''))
        FROM    #CollectionRegister T
                INNER JOIN dbo.T_User_Master UM WITH ( NOLOCK ) ON T.S_Crtd_By COLLATE DATABASE_DEFAULT= UM.S_Login_ID COLLATE DATABASE_DEFAULT
                --COLLATE SQL_Latin1_General_CP1_CS_AS
			 
        UPDATE  #CollectionRegister
        SET     UudatedBy = Counselor_Name
			 
			 /* UudatedBy observed to be same as Counselor_Name
			UPDATE T
				SET T.UudatedBy = LTRIM(ISNULL(TUM.S_First_Name, '') + ' ')
                        + LTRIM(ISNULL(TUM.S_Middle_Name, '') + ' '
                                + ISNULL(TUM.S_Last_Name, ''))
			FROM #CollectionRegister T 
			INNER JOIN dbo.T_User_Master TUM WITH ( NOLOCK ) ON T.S_Crtd_By = TUM.S_Login_ID
			*/
			
			
                        
        CREATE TABLE #StudentBatch
            (
              STDBATCHSEQ INT ,
              I_Student_Detail_ID INT ,
              S_Course_Name VARCHAR(100) ,
              S_Batch_Name VARCHAR(100)
            )
                        
                        -- 
        INSERT  INTO #StudentBatch
                ( STDBATCHSEQ ,
                  I_Student_Detail_ID ,
                  S_Course_Name ,
                  S_Batch_Name
                )
                SELECT  ROW_NUMBER() OVER ( PARTITION BY I_Student_Detail_ID ORDER BY I_Student_Batch_ID DESC ) AS STDBATCHSEQ ,
                        I_Student_Detail_ID ,
                                    --I_Student_Batch_ID ,
                                    --I_Status ,
                                    --I_Batch_ID,
                        S_Course_Name ,
                        S_Batch_Name
                FROM    ( SELECT    T.I_Student_Detail_ID ,
                                    tsbd.I_Student_Batch_ID ,
                                    tsbd.I_Status ,
                                    tsbd.I_Batch_ID ,
                                    TCM.S_Course_Name ,
                                    TSBM2.S_Batch_Name
                          FROM      #CollectionRegister T
                                    INNER JOIN dbo.T_Student_Batch_Details AS tsbd
                                    WITH ( NOLOCK ) ON tsbd.I_Student_ID = T.I_Student_Detail_ID
                                    INNER JOIN dbo.T_Student_Batch_Master TSBM2
                                    WITH ( NOLOCK ) ON tsbd.I_Batch_ID = TSBM2.I_Batch_ID
                                    INNER JOIN dbo.T_Course_Master TCM WITH ( NOLOCK ) ON TSBM2.I_Course_ID = TCM.I_Course_ID
                          WHERE     tsbd.I_Status IN ( 1, 2 )
                          UNION ALL
                          SELECT    T.I_Student_Detail_ID ,
                                    tsbd.I_Student_Batch_ID ,
                                    tsbd.I_Status ,
                                    tsbd.I_Batch_ID ,
                                    TCM.S_Course_Name ,
                                    TSBM2.S_Batch_Name
                          FROM      #CollectionRegister T
                                    INNER JOIN dbo.T_Student_Batch_Details AS tsbd
                                    WITH ( NOLOCK ) ON tsbd.I_Student_ID = T.I_Student_Detail_ID
                                    INNER JOIN dbo.T_Student_Batch_Master TSBM2
                                    WITH ( NOLOCK ) ON tsbd.I_Batch_ID = TSBM2.I_Batch_ID
                                    INNER JOIN dbo.T_Course_Master TCM WITH ( NOLOCK ) ON TSBM2.I_Course_ID = TCM.I_Course_ID
                          WHERE     tsbd.I_Status IS NULL
                        ) AS T
        /* Commented on 10.12.2021
		
        DELETE  FROM #StudentBatch
        WHERE   STDBATCHSEQ > 1
                          
        UPDATE  T
        SET     T.S_Batch_Name = SB.S_Batch_Name ,
                T.S_Course_Name = SB.S_Course_Name
        FROM    #CollectionRegister T
                INNER JOIN #StudentBatch SB ON T.I_Student_Detail_ID = SB.I_Student_Detail_ID

		Commented on 10.12.2021 */
                        
        DECLARE @TotalReceipt_Amount DECIMAL(18, 2) ,
            @TotalReceipt_Tax DECIMAL(18, 2) ,
            @TotalReceptAmountTax DECIMAL(18, 2) ,
            @TotalConvenienceCharge DECIMAL(18, 2) ,
            @TotalConvenienceChargeTax DECIMAL(18, 2)
					    
        SELECT  @TotalReceipt_Amount = SUM(Receipt_Amount) ,
                @TotalReceipt_Tax = SUM(Receipt_Tax) ,
                @TotalReceptAmountTax = SUM(Receipt_Amount) + SUM(Receipt_Tax) ,
                @TotalConvenienceCharge = SUM(ROUND(ConvenienceCharge,2)) ,
                @TotalConvenienceChargeTax = SUM(ConvenienceChargeTax)
        FROM    #CollectionRegister
            	
			
        SELECT  Student_ID ,
                Student_Name ,
                S_Invoice_No 
				--,Dt_Invoice_Date
                ,
                CAST(DATEPART(dd, Dt_Invoice_Date) AS VARCHAR) + '/'
                + CAST(Dt_Invoice_Date AS CHAR(3)) + '/'
                + CAST(DATEPART(YYYY, Dt_Invoice_Date) AS VARCHAR) Dt_Invoice_Date ,
                Invoice_Amount ,
                Tax_Amount ,
                N_Discount_Amount ,
                Counselor_Name ,
                CenterCode ,
                CenterName ,
                TypeofCentre,
                InstanceChain ,
                S_Currency_Code ,
                Receipt_No ,
                CAST(DATEPART(dd, Receipt_Date) AS VARCHAR) + '/'
                + CAST(Receipt_Date AS CHAR(3)) + '/'
                + CAST(DATEPART(YYYY, Receipt_Date) AS VARCHAR) Receipt_Date , 
				--Receipt_Date, 
                
                ReceiptMonthYear ,
                I_Student_Detail_ID ,
                I_Enquiry_Regn_ID ,
                I_Invoice_Header_ID ,
                I_Receipt_Header_ID ,
                I_Status ,
                Receipt_Amount ,
                Receipt_Tax ,
                S_Receipt_Type_Desc ,
                S_Form_No ,
                Payment_Mode ,
                S_Bank_Name ,
                Instrument_No 
				--,Dt_ChequeDD_Date
                ,
                CAST(DATEPART(dd, Dt_ChequeDD_Date) AS VARCHAR) + '/'
                + CAST(Dt_ChequeDD_Date AS CHAR(3)) + '/'
                + CAST(DATEPART(YYYY, Dt_ChequeDD_Date) AS VARCHAR) Dt_ChequeDD_Date ,
                Course_Fee ,
                Exam_Fee ,
                Others_Fee ,
                Tax_Component ,
                UudatedBy 
				--,Dt_Upd_On
                ,
                CAST(DATEPART(dd, Dt_Upd_On) AS VARCHAR) + '/'
                + CAST(Dt_Upd_On AS CHAR(3)) + '/'
                + CAST(DATEPART(YYYY, Dt_Upd_On) AS VARCHAR) Dt_Upd_On ,
                S_Batch_Name ,
                S_Course_Name ,
                CAST(ConvenienceCharge AS DECIMAL(18, 2)) AS ConvenienceCharge,
                ConvenienceChargeTax ,
                Receipt_Amount + Receipt_Tax TotalReceptAmount ,
                @TotalReceipt_Amount TotalReceipt_Amount ,
                @TotalReceipt_Tax TotalReceipt_Tax ,
                @TotalReceptAmountTax TotalReceptAmountTax ,
                @TotalConvenienceCharge TotalConvenienceCharge ,
                @TotalConvenienceChargeTax TotalConvenienceChargeTax,
                CAST(DATEPART(dd, SettlementDate) AS VARCHAR) + '/'
                + CAST(SettlementDate AS CHAR(3)) + '/'
                + CAST(DATEPART(YYYY, SettlementDate) AS VARCHAR) AS SettlementDate,
				BankAccount
                --,S_Crtd_By
        FROM    #CollectionRegister 
		order by CONVERT(DATETIME,Receipt_Date) ASC
		
		--OPTION (RECOMPILE)
           
        DROP TABLE #CollectionRegister
            
        DROP TABLE #StudentBatch
        
        

        --    END  

    END TRY  
    BEGIN CATCH  

        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT  


        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()  


        RAISERROR(@ErrMsg, @ErrSeverity, 1)  


    END CATCH  
    
