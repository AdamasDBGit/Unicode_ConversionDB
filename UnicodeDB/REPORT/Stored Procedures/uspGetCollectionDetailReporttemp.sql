CREATE PROCEDURE [REPORT].[uspGetCollectionDetailReporttemp]
    (
      @dtUptoDate DATETIME ,
      @sHierarchyListID VARCHAR(MAX) ,
      @iBrandID INT
    )
AS
    BEGIN

        DECLARE @dtStartDate DATE
--DECLARE @TotYTDCol DECIMAL(14,2)=0.0
--DECLARE @TotMTDCol DECIMAL(14,2)=0.0
--DECLARE @ODCol DECIMAL(14,2)=0.0
 
        SET @dtStartDate = DATEADD(dd, 0,
                                   DATEDIFF(dd, 0,
                                            DATEADD(mm,
                                                    -( ( ( 12 + DATEPART(m,
                                                              @dtUptoDate) ) - 4 )
                                                       % 12 ), @dtUptoDate)
                                            - DATEPART(d,
                                                       DATEADD(mm,
                                                              -( ( ( 12
                                                              + DATEPART(m,
                                                              @dtUptoDate) ) - 4 )
                                                              % 12 ),
                                                              @dtUptoDate)) + 1))


--SET @dtStartDate='2017-08-10'    
--SET @dtUptoDate = '2017-11-14'
--SET @iBrandID=109
--SET @sHierarchyListID='54'   


        CREATE TABLE #FINDATA
            (
              I_Brand_ID INT ,
              S_Brand_Name VARCHAR(MAX) ,
              I_Center_ID INT ,
              S_Center_Name VARCHAR(MAX) ,
              TypeofCentre VARCHAR(MAX) ,
              TransactionDate DATETIME ,
              MonthYear VARCHAR(MAX) ,
              I_Course_ID INT ,
              S_Course_Name VARCHAR(MAX) ,
              FinancialRange VARCHAR(10) ,
              Category VARCHAR(MAX) ,
              NValue DECIMAL(14, 2) ,
              I_FeeComponent_ID INT ,
              FeeComponentName VARCHAR(MAX) ,
              TypeofComp VARCHAR(10),
              Sequence INT,
              ParentCategory VARCHAR(MAX),
              FSequence INT
            )
    
    
        IF ( @iBrandID = 111
             OR @iBrandID = 109
           )
            BEGIN                                                         
            
                INSERT  INTO #FINDATA
                        ( I_Brand_ID ,
                          S_Brand_Name ,
                          I_Center_ID ,
                          S_Center_Name ,
                          TypeofCentre ,
                          TransactionDate ,
                          MonthYear ,
                          I_Course_ID ,
                          S_Course_Name ,
                          I_FeeComponent_ID ,
                          FeeComponentName ,
                          TypeofComp ,
                          NValue 
                        )
                        SELECT  TCHND.I_Brand_ID ,
                                TCHND.S_Brand_Name ,
                                TCHND.I_Center_ID ,
                                TCHND.S_Center_Name ,
                                CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'
                                     THEN 'Judiciary'
                                     WHEN TCM2.S_Center_Code LIKE 'IAS T%'
                                     THEN 'IAS'
                                     WHEN TCM2.S_Center_Code = 'BRST'
                                     THEN 'AIPT'
                                     WHEN TCM2.S_Center_Code LIKE 'FR-%'
                                     THEN 'Franchise'
                                     ELSE 'Own'
                                END AS TypeofCentre ,
                                CONVERT(DATE, TRH.Dt_Crtd_On) AS TransactionDate ,
                                DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '
                                + CAST(DATEPART(YYYY, TRH.Dt_Crtd_On) AS VARCHAR) AS MonthYear ,
                                TCM.I_Course_ID ,
                                TCM.S_Course_Name ,
                                TICD.I_Fee_Component_ID ,
                                TFCM.S_Component_Name ,
                                TFCM.S_Type_Of_Component ,
                                SUM(ISNULL(TRCD.N_Amount_Paid, 0.0)) AS VALUE
                        FROM    dbo.T_Receipt_Header TRH WITH ( NOLOCK )
                                INNER JOIN dbo.T_Receipt_Component_Detail TRCD
                                WITH ( NOLOCK ) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                INNER JOIN dbo.T_Invoice_Child_Detail TICD
                                WITH ( NOLOCK ) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                INNER JOIN dbo.T_Invoice_Child_Header TICH
                                WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND
                                WITH ( NOLOCK ) ON TRH.I_Centre_Id = TCHND.I_Center_ID
                                INNER JOIN dbo.T_Centre_Master AS TCM2 WITH ( NOLOCK ) ON TCM2.I_Centre_Id = TCHND.I_Center_ID
                                                              AND TCM2.I_Centre_Id = TRH.I_Centre_Id
                        --INNER JOIN dbo.T_Student_Course_Detail TSCD WITH ( NOLOCK ) ON TRH.I_Student_Detail_ID = TSCD.I_Student_Detail_ID
                                LEFT JOIN dbo.T_Course_Master TCM WITH ( NOLOCK ) ON TICH.I_Course_ID = TCM.I_Course_ID
                                INNER JOIN dbo.T_Fee_Component_Master AS TFCM ON TFCM.I_Fee_Component_ID = TICD.I_Fee_Component_ID
                        WHERE   TRH.I_Status IN ( 0, 1 )
                                AND TRH.I_Receipt_Type = 2
                                AND ( TRH.Dt_Crtd_On >= @dtStartDate
                                      AND TRH.Dt_Crtd_On < DATEADD(d, 1,
                                                              @dtUptoDate)
                                    )
                                AND TRH.I_Centre_Id IN (
                                SELECT  FGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR )
                        GROUP BY TCHND.I_Brand_ID ,
                                TCHND.S_Brand_Name ,
                                TCHND.I_Center_ID ,
                                TCHND.S_Center_Name ,
                                CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'
                                     THEN 'Judiciary'
                                     WHEN TCM2.S_Center_Code LIKE 'IAS T%'
                                     THEN 'IAS'
                                     WHEN TCM2.S_Center_Code = 'BRST'
                                     THEN 'AIPT'
                                     WHEN TCM2.S_Center_Code LIKE 'FR-%'
                                     THEN 'Franchise'
                                     ELSE 'Own'
                                END ,
                                DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '
                                + CAST(DATEPART(YYYY, TRH.Dt_Crtd_On) AS VARCHAR) ,
                                CONVERT(DATE, TRH.Dt_Crtd_On) ,
                                TCM.I_Course_ID ,
                                TCM.S_Course_Name ,
                                TICD.I_Fee_Component_ID ,
                                TFCM.S_Component_Name ,
                                TFCM.S_Type_Of_Component
                        UNION ALL
                        SELECT  TCHND.I_Brand_ID ,
                                TCHND.S_Brand_Name ,
                                TCHND.I_Center_ID ,
                                TCHND.S_Center_Name ,
                                CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'
                                     THEN 'Judiciary'
                                     WHEN TCM2.S_Center_Code LIKE 'IAS T%'
                                     THEN 'IAS'
                                     WHEN TCM2.S_Center_Code = 'BRST'
                                     THEN 'AIPT'
                                     WHEN TCM2.S_Center_Code LIKE 'FR-%'
                                     THEN 'Franchise'
                                     ELSE 'Own'
                                END AS TypeofCentre ,
                                CONVERT(DATE, TRH.Dt_Upd_On) AS TransactionDate ,
                                DATENAME(MONTH, TRH.Dt_Upd_On) + ' '
                                + CAST(DATEPART(YYYY, TRH.Dt_Upd_On) AS VARCHAR) AS MonthYear ,
                                TCM.I_Course_ID ,
                                TCM.S_Course_Name ,
                                TICD.I_Fee_Component_ID ,
                                TFCM.S_Component_Name ,
                                TFCM.S_Type_Of_Component ,
                                -SUM(ISNULL(TRCD.N_Amount_Paid, 0.0)) AS VALUE
                        FROM    dbo.T_Receipt_Header TRH WITH ( NOLOCK )
                                INNER JOIN dbo.T_Receipt_Component_Detail TRCD
                                WITH ( NOLOCK ) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                INNER JOIN dbo.T_Invoice_Child_Detail TICD
                                WITH ( NOLOCK ) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                INNER JOIN dbo.T_Invoice_Child_Header TICH
                                WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND
                                WITH ( NOLOCK ) ON TRH.I_Centre_Id = TCHND.I_Center_ID
                                INNER JOIN dbo.T_Centre_Master AS TCM2 ON TCM2.I_Centre_Id = TCHND.I_Center_ID
                                                              AND TCM2.I_Centre_Id = TRH.I_Centre_Id
                        --INNER JOIN dbo.T_Student_Course_Detail TSCD WITH ( NOLOCK ) ON TRH.I_Student_Detail_ID = TSCD.I_Student_Detail_ID
                                LEFT JOIN dbo.T_Course_Master TCM WITH ( NOLOCK ) ON TICH.I_Course_ID = TCM.I_Course_ID
                                INNER JOIN dbo.T_Fee_Component_Master AS TFCM ON TFCM.I_Fee_Component_ID = TICD.I_Fee_Component_ID
                        WHERE   TRH.I_Status = 0
                                AND TRH.I_Receipt_Type = 2
                                AND ( TRH.Dt_Upd_On >= @dtStartDate
                                      AND TRH.Dt_Upd_On < DATEADD(d, 1,
                                                              @dtUptoDate)
                                    )
                                AND TRH.I_Centre_Id IN (
                                SELECT  FGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR )
                        GROUP BY TCHND.I_Brand_ID ,
                                TCHND.S_Brand_Name ,
                                TCHND.I_Center_ID ,
                                TCHND.S_Center_Name ,
                                CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'
                                     THEN 'Judiciary'
                                     WHEN TCM2.S_Center_Code LIKE 'IAS T%'
                                     THEN 'IAS'
                                     WHEN TCM2.S_Center_Code = 'BRST'
                                     THEN 'AIPT'
                                     WHEN TCM2.S_Center_Code LIKE 'FR-%'
                                     THEN 'Franchise'
                                     ELSE 'Own'
                                END ,
                                DATENAME(MONTH, TRH.Dt_Upd_On) + ' '
                                + CAST(DATEPART(YYYY, TRH.Dt_Upd_On) AS VARCHAR) ,
                                CONVERT(DATE, TRH.Dt_Upd_On) ,
                                TCM.I_Course_ID ,
                                TCM.S_Course_Name ,
                                TICD.I_Fee_Component_ID ,
                                TFCM.S_Component_Name ,
                                TFCM.S_Type_Of_Component
                        
            END
                        
        ELSE
            BEGIN                                                         
            
                INSERT  INTO #FINDATA
                        ( I_Brand_ID ,
                          S_Brand_Name ,
                          I_Center_ID ,
                          S_Center_Name ,
                          TypeofCentre ,
                          TransactionDate ,
                          MonthYear ,
                          I_Course_ID ,
                          S_Course_Name ,
                          I_FeeComponent_ID ,
                          FeeComponentName ,
                          TypeofComp ,
                          NValue 
                        )
                        SELECT  TCHND.I_Brand_ID ,
                                TCHND.S_Brand_Name ,
                                TCHND.I_Center_ID ,
                                TCHND.S_Center_Name ,
                                CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'
                                     THEN 'Judiciary'
                                     WHEN TCM2.S_Center_Code LIKE 'IAS T%'
                                     THEN 'IAS'
                                     WHEN TCM2.S_Center_Code = 'BRST'
                                     THEN 'AIPT'
                                     WHEN TCM2.S_Center_Code LIKE 'FR-%'
                                     THEN 'Franchise'
                                     ELSE 'Own'
                                END AS TypeofCentre ,
                                CONVERT(DATE, TRH.Dt_Crtd_On) AS TransactionDate ,
                                DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '
                                + CAST(DATEPART(YYYY, TRH.Dt_Crtd_On) AS VARCHAR) AS MonthYear ,
                                TCM.I_Course_ID ,
                                TCM.S_Course_Name ,
                                TICD.I_Fee_Component_ID ,
                                TFCM.S_Component_Name ,
                                TFCM.S_Type_Of_Component ,
                                ROUND(SUM(ISNULL(TRCD.N_Amount_Paid, 0.0)), 0) AS VALUE
                        FROM    dbo.T_Receipt_Header TRH WITH ( NOLOCK )
                                INNER JOIN dbo.T_Receipt_Component_Detail TRCD
                                WITH ( NOLOCK ) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                INNER JOIN dbo.T_Invoice_Child_Detail TICD
                                WITH ( NOLOCK ) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                INNER JOIN dbo.T_Invoice_Child_Header TICH
                                WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND
                                WITH ( NOLOCK ) ON TRH.I_Centre_Id = TCHND.I_Center_ID
                                INNER JOIN dbo.T_Centre_Master AS TCM2 WITH ( NOLOCK ) ON TCM2.I_Centre_Id = TCHND.I_Center_ID
                                                              AND TCM2.I_Centre_Id = TRH.I_Centre_Id
                        --INNER JOIN dbo.T_Student_Course_Detail TSCD WITH ( NOLOCK ) ON TRH.I_Student_Detail_ID = TSCD.I_Student_Detail_ID
                                LEFT JOIN dbo.T_Course_Master TCM WITH ( NOLOCK ) ON TICH.I_Course_ID = TCM.I_Course_ID
                                INNER JOIN dbo.T_Fee_Component_Master AS TFCM ON TFCM.I_Fee_Component_ID = TICD.I_Fee_Component_ID
                        WHERE   TRH.I_Status IN ( 0, 1 )
                                AND TRH.I_Receipt_Type = 2
                                AND ( TRH.Dt_Crtd_On >= @dtStartDate
                                      AND TRH.Dt_Crtd_On < DATEADD(d, 1,
                                                              @dtUptoDate)
                                    )
                                AND TRH.I_Centre_Id IN (
                                SELECT  FGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR )
                        GROUP BY TCHND.I_Brand_ID ,
                                TCHND.S_Brand_Name ,
                                TCHND.I_Center_ID ,
                                TCHND.S_Center_Name ,
                                CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'
                                     THEN 'Judiciary'
                                     WHEN TCM2.S_Center_Code LIKE 'IAS T%'
                                     THEN 'IAS'
                                     WHEN TCM2.S_Center_Code = 'BRST'
                                     THEN 'AIPT'
                                     WHEN TCM2.S_Center_Code LIKE 'FR-%'
                                     THEN 'Franchise'
                                     ELSE 'Own'
                                END ,
                                DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '
                                + CAST(DATEPART(YYYY, TRH.Dt_Crtd_On) AS VARCHAR) ,
                                CONVERT(DATE, TRH.Dt_Crtd_On) ,
                                TCM.I_Course_ID ,
                                TCM.S_Course_Name ,
                                TICD.I_Fee_Component_ID ,
                                TFCM.S_Component_Name ,
                                TFCM.S_Type_Of_Component
                        UNION ALL
                        SELECT  TCHND.I_Brand_ID ,
                                TCHND.S_Brand_Name ,
                                TCHND.I_Center_ID ,
                                TCHND.S_Center_Name ,
                                CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'
                                     THEN 'Judiciary'
                                     WHEN TCM2.S_Center_Code LIKE 'IAS T%'
                                     THEN 'IAS'
                                     WHEN TCM2.S_Center_Code = 'BRST'
                                     THEN 'AIPT'
                                     WHEN TCM2.S_Center_Code LIKE 'FR-%'
                                     THEN 'Franchise'
                                     ELSE 'Own'
                                END AS TypeofCentre ,
                                CONVERT(DATE, TRH.Dt_Upd_On) AS TransactionDate ,
                                DATENAME(MONTH, TRH.Dt_Upd_On) + ' '
                                + CAST(DATEPART(YYYY, TRH.Dt_Upd_On) AS VARCHAR) AS MonthYear ,
                                TCM.I_Course_ID ,
                                TCM.S_Course_Name ,
                                TICD.I_Fee_Component_ID ,
                                TFCM.S_Component_Name ,
                                TFCM.S_Type_Of_Component ,
                                -ROUND(SUM(ISNULL(TRCD.N_Amount_Paid, 0.0)), 0) AS VALUE
                        FROM    dbo.T_Receipt_Header TRH WITH ( NOLOCK )
                                INNER JOIN dbo.T_Receipt_Component_Detail TRCD
                                WITH ( NOLOCK ) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                INNER JOIN dbo.T_Invoice_Child_Detail TICD
                                WITH ( NOLOCK ) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                INNER JOIN dbo.T_Invoice_Child_Header TICH
                                WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND
                                WITH ( NOLOCK ) ON TRH.I_Centre_Id = TCHND.I_Center_ID
                                INNER JOIN dbo.T_Centre_Master AS TCM2 ON TCM2.I_Centre_Id = TCHND.I_Center_ID
                                                              AND TCM2.I_Centre_Id = TRH.I_Centre_Id
                        --INNER JOIN dbo.T_Student_Course_Detail TSCD WITH ( NOLOCK ) ON TRH.I_Student_Detail_ID = TSCD.I_Student_Detail_ID
                                LEFT JOIN dbo.T_Course_Master TCM WITH ( NOLOCK ) ON TICH.I_Course_ID = TCM.I_Course_ID
                                INNER JOIN dbo.T_Fee_Component_Master AS TFCM ON TFCM.I_Fee_Component_ID = TICD.I_Fee_Component_ID
                        WHERE   TRH.I_Status = 0
                                AND TRH.I_Receipt_Type = 2
                                AND ( TRH.Dt_Upd_On >= @dtStartDate
                                      AND TRH.Dt_Upd_On < DATEADD(d, 1,
                                                              @dtUptoDate)
                                    )
                                AND TRH.I_Centre_Id IN (
                                SELECT  FGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR )
                        GROUP BY TCHND.I_Brand_ID ,
                                TCHND.S_Brand_Name ,
                                TCHND.I_Center_ID ,
                                TCHND.S_Center_Name ,
                                CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'
                                     THEN 'Judiciary'
                                     WHEN TCM2.S_Center_Code LIKE 'IAS T%'
                                     THEN 'IAS'
                                     WHEN TCM2.S_Center_Code = 'BRST'
                                     THEN 'AIPT'
                                     WHEN TCM2.S_Center_Code LIKE 'FR-%'
                                     THEN 'Franchise'
                                     ELSE 'Own'
                                END ,
                                DATENAME(MONTH, TRH.Dt_Upd_On) + ' '
                                + CAST(DATEPART(YYYY, TRH.Dt_Upd_On) AS VARCHAR) ,
                                CONVERT(DATE, TRH.Dt_Upd_On) ,
                                TCM.I_Course_ID ,
                                TCM.S_Course_Name ,
                                TICD.I_Fee_Component_ID ,
                                TFCM.S_Component_Name ,
                                TFCM.S_Type_Of_Component
                        
            END
            

 
        UPDATE  #FINDATA
        SET     Category = CASE WHEN TypeofComp = 'M' THEN 'MTF Collection'
                                ELSE 'Fresh Collection'
                           END
                           
                           
                           
      IF (@iBrandID IN (109,111))
      
      BEGIN
                           
                           
       INSERT INTO #FINDATA
               ( I_Brand_ID ,
                 S_Brand_Name ,
                 I_Center_ID ,
                 S_Center_Name ,
                 TypeofCentre ,
                 TransactionDate ,
                 MonthYear ,
                 I_Course_ID ,
                 S_Course_Name ,
                 Category ,
                 NValue
               )
           
       SELECT  TCHND.I_Brand_ID,TCHND.S_Brand_Name,TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'
                                     THEN 'Judiciary'
                                     WHEN TCM2.S_Center_Code LIKE 'IAS T%'
                                     THEN 'IAS'
                                     WHEN TCM2.S_Center_Code = 'BRST'
                                     THEN 'AIPT'
                                     WHEN TCM2.S_Center_Code LIKE 'FR-%'
                                     THEN 'Franchise'
                                     ELSE 'Own'
                                END AS TypeofCentre,
                ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On),                
                DATENAME(MONTH, ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On)) + ' '
                + CAST(DATEPART(YYYY, ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On)) AS VARCHAR) AS MonthYear ,
                TCM.I_Course_ID ,
                TCM.S_Course_Name ,
                'PreEnquiry/Enquiry' AS Category ,
                COUNT(DISTINCT TERD.I_Enquiry_Regn_ID) AS Value
        FROM    dbo.T_Enquiry_Regn_Detail TERD
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TERD.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_Information_Source_Master TISM ON TERD.I_Info_Source_ID = TISM.I_Info_Source_ID 
                INNER JOIN dbo.T_Enquiry_Course TEC ON TERD.I_Enquiry_Regn_ID = TEC.I_Enquiry_Regn_ID
                INNER JOIN dbo.T_Course_Master TCM ON TEC.I_Course_ID = TCM.I_Course_ID
                INNER JOIN dbo.T_Centre_Master AS TCM2 ON TCM2.I_Centre_Id = TCHND.I_Center_ID
        WHERE   TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND TERD.Dt_Crtd_On >= @dtStartDate
                AND TERD.Dt_Crtd_On < DATEADD(d, 1, @dtUptoDate)
                AND TISM.I_Info_Source_ID != 3
        GROUP BY TCHND.I_Brand_ID,TCHND.S_Brand_Name,TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'
                                     THEN 'Judiciary'
                                     WHEN TCM2.S_Center_Code LIKE 'IAS T%'
                                     THEN 'IAS'
                                     WHEN TCM2.S_Center_Code = 'BRST'
                                     THEN 'AIPT'
                                     WHEN TCM2.S_Center_Code LIKE 'FR-%'
                                     THEN 'Franchise'
                                     ELSE 'Own'
                                END,
                ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On),                
                DATENAME(MONTH, ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On)) + ' '
                + CAST(DATEPART(YYYY, ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On)) AS VARCHAR) ,
                TCM.I_Course_ID ,
                TCM.S_Course_Name 
                
                
        UNION ALL
        
        
        SELECT   TCHND.I_Brand_ID,TCHND.S_Brand_Name,TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'
                                     THEN 'Judiciary'
                                     WHEN TCM2.S_Center_Code LIKE 'IAS T%'
                                     THEN 'IAS'
                                     WHEN TCM2.S_Center_Code = 'BRST'
                                     THEN 'AIPT'
                                     WHEN TCM2.S_Center_Code LIKE 'FR-%'
                                     THEN 'Franchise'
                                     ELSE 'Own'
                                END AS TypeofCentre,
                TRH.Dt_Receipt_Date,                
                DATENAME(MONTH, TRH.Dt_Receipt_Date) + ' '
                + CAST(DATEPART(YYYY, TRH.Dt_Receipt_Date) AS VARCHAR) AS MonthYear ,
                TCM.I_Course_ID ,
                TCM.S_Course_Name ,
                'Form/Prospectus' AS Category ,
                COUNT(DISTINCT TRH.I_Receipt_Header_ID) AS Value
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TRH.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
                INNER JOIN dbo.T_Information_Source_Master TISM ON TERD.I_Info_Source_ID = TISM.I_Info_Source_ID 
                INNER JOIN dbo.T_Enquiry_Course TEC ON TERD.I_Enquiry_Regn_ID = TEC.I_Enquiry_Regn_ID
                INNER JOIN dbo.T_Course_Master TCM ON TEC.I_Course_ID = TCM.I_Course_ID
                INNER JOIN dbo.T_Centre_Master AS TCM2 ON TCM2.I_Centre_Id = TCHND.I_Center_ID
        WHERE   TRH.I_Status = 1
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND TRH.I_Receipt_Type IN ( 31, 32, 50, 51, 57, 85 )
                AND TRH.Dt_Crtd_On >= @dtStartDate
                AND TRH.Dt_Crtd_On < DATEADD(d, 1, @dtUptoDate)
                AND TISM.I_Info_Source_ID != 3
        GROUP BY TCHND.I_Brand_ID,TCHND.S_Brand_Name,TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'
                                     THEN 'Judiciary'
                                     WHEN TCM2.S_Center_Code LIKE 'IAS T%'
                                     THEN 'IAS'
                                     WHEN TCM2.S_Center_Code = 'BRST'
                                     THEN 'AIPT'
                                     WHEN TCM2.S_Center_Code LIKE 'FR-%'
                                     THEN 'Franchise'
                                     ELSE 'Own'
                                END,
                TRH.Dt_Receipt_Date,                
                DATENAME(MONTH, TRH.Dt_Receipt_Date) + ' '
                + CAST(DATEPART(YYYY, TRH.Dt_Receipt_Date) AS VARCHAR),
                TCM.I_Course_ID ,
                TCM.S_Course_Name 
                
                
        UNION ALL
        
        
        SELECT  TCHND.I_Brand_ID,TCHND.S_Brand_Name,TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                CASE WHEN TCM3.S_Center_Code LIKE 'Judiciary T%'
                                     THEN 'Judiciary'
                                     WHEN TCM3.S_Center_Code LIKE 'IAS T%'
                                     THEN 'IAS'
                                     WHEN TCM3.S_Center_Code = 'BRST'
                                     THEN 'AIPT'
                                     WHEN TCM3.S_Center_Code LIKE 'FR-%'
                                     THEN 'Franchise'
                                     ELSE 'Own'
                                END AS TypeofCentre,
                                TSD.Dt_Crtd_On,
                DATENAME(MONTH, TSD.Dt_Crtd_On) + ' '
                + CAST(DATEPART(YYYY, TSD.Dt_Crtd_On) AS VARCHAR) AS MonthYear ,
                TCM2.I_Course_ID ,
                TCM2.S_Course_Name ,
                'Enrolment' AS Category ,
                COUNT(DISTINCT TSD.S_Student_ID) AS Value
        FROM    dbo.T_Student_Detail TSD
                INNER JOIN dbo.T_Student_Center_Detail TSCD ON TSD.I_Student_Detail_ID = TSCD.I_Student_Detail_ID
                                                              AND CONVERT(DATE, TSD.Dt_Crtd_On) = CONVERT(DATE, TSCD.Dt_Valid_From)
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TSCD.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
                INNER JOIN dbo.T_Information_Source_Master TISM ON TERD.I_Info_Source_ID = TISM.I_Info_Source_ID 
                INNER JOIN ( SELECT TSBD.I_Student_ID ,
                                    MIN(TSBD.I_Student_Batch_ID) AS MinBatchID
                             FROM   dbo.T_Student_Batch_Details TSBD
                             GROUP BY TSBD.I_Student_ID
                           ) TSBD1 ON TSD.I_Student_Detail_ID = TSBD1.I_Student_ID
                INNER JOIN dbo.T_Student_Batch_Details TSBD2 ON TSBD1.I_Student_ID = TSBD2.I_Student_ID
                                                              AND TSBD2.I_Student_ID = TSD.I_Student_Detail_ID
                                                              AND TSBD1.MinBatchID = TSBD2.I_Student_Batch_ID
                INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD2.I_Batch_ID = TSBM.I_Batch_ID
                INNER JOIN dbo.T_Course_Master TCM2 ON TSBM.I_Course_ID = TCM2.I_Course_ID
                INNER JOIN dbo.T_Centre_Master AS TCM3 ON TCM3.I_Centre_Id = TCHND.I_Center_ID
        WHERE   TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND TSD.Dt_Crtd_On >= @dtStartDate
                AND TSD.Dt_Crtd_On < DATEADD(d, 1, @dtUptoDate)
                AND TERD.I_Enquiry_Status_Code = 3
                AND TISM.I_Info_Source_ID != 3
        GROUP BY TCHND.I_Brand_ID,TCHND.S_Brand_Name,TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                CASE WHEN TCM3.S_Center_Code LIKE 'Judiciary T%'
                                     THEN 'Judiciary'
                                     WHEN TCM3.S_Center_Code LIKE 'IAS T%'
                                     THEN 'IAS'
                                     WHEN TCM3.S_Center_Code = 'BRST'
                                     THEN 'AIPT'
                                     WHEN TCM3.S_Center_Code LIKE 'FR-%'
                                     THEN 'Franchise'
                                     ELSE 'Own'
                                END ,
                                TSD.Dt_Crtd_On,
                DATENAME(MONTH, TSD.Dt_Crtd_On) + ' '
                + CAST(DATEPART(YYYY, TSD.Dt_Crtd_On) AS VARCHAR),
                TCM2.I_Course_ID ,
                TCM2.S_Course_Name        
                
                                          
        END 
        
        
        UPDATE #FINDATA SET ParentCategory='Enquiry',Sequence=1 WHERE Category LIKE '%Enquiry%'
        UPDATE #FINDATA SET ParentCategory='Form Sale',Sequence=2 WHERE Category LIKE '%Form%'
        UPDATE #FINDATA SET ParentCategory='Enrolment',Sequence=3 WHERE Category LIKE '%Enrolment%'
        UPDATE #FINDATA SET ParentCategory='Collection',Sequence=4 WHERE Category LIKE '%Collection%'                  
                                              
                           
        UPDATE  #FINDATA
        SET     FinancialRange = 'YTD'
 
        INSERT  INTO #FINDATA
                SELECT  I_Brand_ID ,
                        S_Brand_Name ,
                        I_Center_ID ,
                        S_Center_Name ,
                        TypeofCentre ,
                        TransactionDate ,
                        MonthYear ,
                        I_Course_ID ,
                        S_Course_Name ,
                        'MTD' ,
                        Category ,
                        NValue ,
                        I_FeeComponent_ID ,
                        FeeComponentName ,
                        TypeofComp,
                        Sequence,
                        ParentCategory
                FROM    #FINDATA AS T1
                WHERE   MONTH(T1.TransactionDate) = MONTH(@dtUptoDate)
           
           
        INSERT  INTO #FINDATA
                SELECT  I_Brand_ID ,
                        S_Brand_Name ,
                        I_Center_ID ,
                        S_Center_Name ,
                        TypeofCentre ,
                        TransactionDate ,
                        MonthYear ,
                        I_Course_ID ,
                        S_Course_Name ,
                        'OD' ,
                        Category ,
                        NValue ,
                        I_FeeComponent_ID ,
                        FeeComponentName ,
                        TypeofComp,
                        Sequence,
                        ParentCategory
                FROM    #FINDATA AS T1
                WHERE   CONVERT(DATE, T1.TransactionDate) = CONVERT(DATE, @dtUptoDate)
                        AND T1.FinancialRange != 'YTD'
                      
 --SELECT @ODCol=@ODCol+SUM(F.NValue) FROM #FINDATA AS F WHERE F.FinancialRange='OD'
 
 UPDATE #FINDATA SET FSequence=1 WHERE FinancialRange='OD'
 UPDATE #FINDATA SET FSequence=2 WHERE FinancialRange='MTD'
 UPDATE #FINDATA SET FSequence=3 WHERE FinancialRange='YTD'
 
 
        SELECT  *
        FROM    #FINDATA AS F
 --PRINT dbo.fNumToWords(ROUND(@ODCol,0))
 
        DROP TABLE #FINDATA

    END
