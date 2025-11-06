CREATE PROCEDURE ERP_REPORTS.usp_ERP_GetCollectionDetailReport  
    (  
      @dtUptoDate DATETIME ,  
      @sHierarchyListID VARCHAR(MAX)=NULL ,  
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
              TypeofComp VARCHAR(10)  
            )  
      
      
     --   IF ( @iBrandID = 111  
     --        OR @iBrandID = 109  
     --      )  
     --       BEGIN                                                           
              
     --           INSERT  INTO #FINDATA  
     --                   ( I_Brand_ID ,  
     --                     S_Brand_Name ,  
     --                     I_Center_ID ,  
     --                     S_Center_Name ,  
     --                     TypeofCentre ,  
     --                     TransactionDate ,  
     --                     MonthYear ,  
     --                     I_Course_ID ,  
     --                     S_Course_Name ,  
     --                     I_FeeComponent_ID ,  
     --                     FeeComponentName ,  
     --                     TypeofComp ,  
     --                     NValue   
     --                   )  
     --                   SELECT  TCHND.I_Brand_ID ,  
     --                           TCHND.S_Brand_Name ,  
     --                           TCHND.I_Center_ID ,  
     --                           TCHND.S_Center_Name ,  
     --                           CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'  
     --                                THEN 'Judiciary'  
     --                                WHEN TCM2.S_Center_Code LIKE 'IAS T%'  
     --                                THEN 'IAS'  
     --                                WHEN TCM2.S_Center_Code = 'BRST'  
     --                                THEN 'AIPT'  
     --                                WHEN TCM2.S_Center_Code LIKE 'FR-%'  
     --                                THEN 'Franchise'  
     --                                ELSE 'Own'  
     --                           END AS TypeofCentre ,  
     --                           CONVERT(DATE, TRH.Dt_Crtd_On) AS TransactionDate ,  
     --                           DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '  
     --                           + CAST(DATEPART(YYYY, TRH.Dt_Crtd_On) AS VARCHAR) AS MonthYear ,  
     --                           TCM.I_Course_ID ,  
     --                           TCM.S_Course_Name ,  
     --                           TICD.I_Fee_Component_ID ,  
     --                           TFCM.S_Component_Name ,  
     --                           TFCM.S_Type_Of_Component ,  
     --                           SUM(ISNULL(TRCD.N_Amount_Paid, 0.0)) AS VALUE  
     --                   FROM    dbo.T_Receipt_Header TRH WITH ( NOLOCK )  
     --                           INNER JOIN dbo.T_Receipt_Component_Detail TRCD  
     --                           WITH ( NOLOCK ) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID  
     --                           INNER JOIN dbo.T_Invoice_Child_Detail TICD  
     --                           WITH ( NOLOCK ) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID  
     --                           INNER JOIN dbo.T_Invoice_Child_Header TICH  
     --                           WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID  
     --                           INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND  
     --                           WITH ( NOLOCK ) ON TRH.I_Centre_Id = TCHND.I_Center_ID  
     --                           INNER JOIN dbo.T_Centre_Master AS TCM2 WITH ( NOLOCK ) ON TCM2.I_Centre_Id = TCHND.I_Center_ID  
     --                                                         AND TCM2.I_Centre_Id = TRH.I_Centre_Id  
     --                   --INNER JOIN dbo.T_Student_Course_Detail TSCD WITH ( NOLOCK ) ON TRH.I_Student_Detail_ID = TSCD.I_Student_Detail_ID  
     --                           LEFT JOIN dbo.T_Course_Master TCM WITH ( NOLOCK ) ON TICH.I_Course_ID = TCM.I_Course_ID  
     --                           INNER JOIN dbo.T_Fee_Component_Master AS TFCM ON TFCM.I_Fee_Component_ID = TICD.I_Fee_Component_ID  
     --                   WHERE   TRH.I_Status IN ( 0, 1 )  
     --                           AND TRH.I_Receipt_Type = 2  
     --                           AND ( TRH.Dt_Crtd_On >= @dtStartDate  
     --                                 AND TRH.Dt_Crtd_On < DATEADD(d, 1,  
     --                                                         @dtUptoDate)  
     --                               )  
     --                           AND TRH.I_Centre_Id IN (  
     --                           SELECT  FGCFR.centerID  
     --                           FROM    dbo.fnGetCentersForReports(@sHierarchyListID,  
     --                                                         @iBrandID) FGCFR )  
     --                   GROUP BY TCHND.I_Brand_ID ,  
     --                           TCHND.S_Brand_Name ,  
     --                           TCHND.I_Center_ID ,  
     --                           TCHND.S_Center_Name ,  
     --                           CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'  
     --                                THEN 'Judiciary'  
     --                                WHEN TCM2.S_Center_Code LIKE 'IAS T%'  
     --                                THEN 'IAS'  
     --                                WHEN TCM2.S_Center_Code = 'BRST'  
     --                                THEN 'AIPT'  
     --                                WHEN TCM2.S_Center_Code LIKE 'FR-%'  
     --                                THEN 'Franchise'  
     --                                ELSE 'Own'  
     --                           END ,  
     --                           DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '  
     --                           + CAST(DATEPART(YYYY, TRH.Dt_Crtd_On) AS VARCHAR) ,  
     --                           CONVERT(DATE, TRH.Dt_Crtd_On) ,  
     --                           TCM.I_Course_ID ,  
     --                           TCM.S_Course_Name ,  
     --                           TICD.I_Fee_Component_ID ,  
     --                           TFCM.S_Component_Name ,  
     --                           TFCM.S_Type_Of_Component  
     --                   UNION ALL  
     --                   SELECT  TCHND.I_Brand_ID ,  
     --                           TCHND.S_Brand_Name ,  
     --                           TCHND.I_Center_ID ,  
     --                           TCHND.S_Center_Name ,  
     --                           CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'  
     --                        THEN 'Judiciary'  
     --                                WHEN TCM2.S_Center_Code LIKE 'IAS T%'  
     --                                THEN 'IAS'  
     --                                WHEN TCM2.S_Center_Code = 'BRST'  
     --                                THEN 'AIPT'  
     --                                WHEN TCM2.S_Center_Code LIKE 'FR-%'  
     --                                THEN 'Franchise'  
     --                                ELSE 'Own'  
     --                           END AS TypeofCentre ,  
     --                           CONVERT(DATE, TRH.Dt_Upd_On) AS TransactionDate ,  
     --                           DATENAME(MONTH, TRH.Dt_Upd_On) + ' '  
     --                           + CAST(DATEPART(YYYY, TRH.Dt_Upd_On) AS VARCHAR) AS MonthYear ,  
     --                           TCM.I_Course_ID ,  
     --                           TCM.S_Course_Name ,  
     --                           TICD.I_Fee_Component_ID ,  
     --                           TFCM.S_Component_Name ,  
     --                           TFCM.S_Type_Of_Component ,  
     --                           -SUM(ISNULL(TRCD.N_Amount_Paid, 0.0)) AS VALUE  
     --                   FROM    dbo.T_Receipt_Header TRH WITH ( NOLOCK )  
     --                           INNER JOIN dbo.T_Receipt_Component_Detail TRCD  
     --                           WITH ( NOLOCK ) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID  
     --                           INNER JOIN dbo.T_Invoice_Child_Detail TICD  
     --                           WITH ( NOLOCK ) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID  
     --                           INNER JOIN dbo.T_Invoice_Child_Header TICH  
     --                           WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID  
     --                           INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND  
     --                           WITH ( NOLOCK ) ON TRH.I_Centre_Id = TCHND.I_Center_ID  
     --                           INNER JOIN dbo.T_Centre_Master AS TCM2 ON TCM2.I_Centre_Id = TCHND.I_Center_ID  
     --                                                         AND TCM2.I_Centre_Id = TRH.I_Centre_Id  
     --                   --INNER JOIN dbo.T_Student_Course_Detail TSCD WITH ( NOLOCK ) ON TRH.I_Student_Detail_ID = TSCD.I_Student_Detail_ID  
     --                           LEFT JOIN dbo.T_Course_Master TCM WITH ( NOLOCK ) ON TICH.I_Course_ID = TCM.I_Course_ID  
     --                           INNER JOIN dbo.T_Fee_Component_Master AS TFCM ON TFCM.I_Fee_Component_ID = TICD.I_Fee_Component_ID  
     --                   WHERE   TRH.I_Status = 0  
     --                           AND TRH.I_Receipt_Type = 2  
     --                           AND ( TRH.Dt_Upd_On >= @dtStartDate  
     --                                 AND TRH.Dt_Upd_On < DATEADD(d, 1,  
     --                                                         @dtUptoDate)  
     --                               )  
     --                           AND TRH.I_Centre_Id IN (  
     --                           SELECT  FGCFR.centerID  
     --                           FROM    dbo.fnGetCentersForReports(@sHierarchyListID,  
     --                                                         @iBrandID) FGCFR )  
     --                   GROUP BY TCHND.I_Brand_ID ,  
     --                           TCHND.S_Brand_Name ,  
     --                           TCHND.I_Center_ID ,  
     --                           TCHND.S_Center_Name ,  
     --                           CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'  
     --                                THEN 'Judiciary'  
     --                                WHEN TCM2.S_Center_Code LIKE 'IAS T%'  
     --                                THEN 'IAS'  
     --                                WHEN TCM2.S_Center_Code = 'BRST'  
     --                                THEN 'AIPT'  
     --                                WHEN TCM2.S_Center_Code LIKE 'FR-%'  
     --                                THEN 'Franchise'  
     --                                ELSE 'Own'  
     --END ,  
     --                           DATENAME(MONTH, TRH.Dt_Upd_On) + ' '  
     --                           + CAST(DATEPART(YYYY, TRH.Dt_Upd_On) AS VARCHAR) ,  
     --                           CONVERT(DATE, TRH.Dt_Upd_On) ,  
     --                           TCM.I_Course_ID ,  
     --                           TCM.S_Course_Name ,  
     --                           TICD.I_Fee_Component_ID ,  
     --                           TFCM.S_Component_Name ,  
     --                           TFCM.S_Type_Of_Component  
                          
     --       END  
                          
     --   ELSE  
     --       BEGIN                                                           
              
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
                                FROM    dbo.fnGetCentreIdByBrandId(@iBrandID) FGCFR )  
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
                                FROM    dbo.fnGetCentreIdByBrandId(@iBrandID) FGCFR )  
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
                          
            --END  
              
--INSERT  INTO #FINDATA  
--        ( I_Brand_ID ,  
--          S_Brand_Name ,  
--          I_Center_ID ,  
--          S_Center_Name ,  
--          TypeofCentre ,  
--          TransactionDate ,  
--          MonthYear ,  
--          I_Course_ID ,  
--          S_Course_Name ,  
--          I_FeeComponent_ID,  
--          FeeComponentName,  
--          TypeofComp,  
--          NValue   
--        )  
--        SELECT  TCHND.I_Brand_ID ,  
--                TCHND.S_Brand_Name ,  
--                TCHND.I_Center_ID ,  
--                TCHND.S_Center_Name ,  
--                CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'  
--                     THEN 'Judiciary'  
--                     WHEN TCM2.S_Center_Code LIKE 'IAS T%' THEN 'IAS'  
--                     WHEN TCM2.S_Center_Code = 'BRST' THEN 'AIPT'  
--                     WHEN TCM2.S_Center_Code LIKE 'FR-%' THEN 'Franchise'  
--                     ELSE 'Own'  
--                END AS TypeofCentre ,  
--                CONVERT(DATE, TRH.Dt_Crtd_On) AS TransactionDate ,  
--                DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '  
--                + CAST(DATEPART(YYYY, TRH.Dt_Crtd_On) AS VARCHAR) AS MonthYear ,  
--                TCM.I_Course_ID ,  
--                TCM.S_Course_Name ,  
--                TICD.I_Fee_Component_ID ,  
--                TFCM.S_Component_Name,  
--                TFCM.S_Type_Of_Component,  
--                SUM(ISNULL(TRCD.N_Amount_Paid, 0.0)) AS VALUE  
--        FROM    dbo.T_Receipt_Header TRH WITH ( NOLOCK )  
--                INNER JOIN dbo.T_Receipt_Component_Detail TRCD WITH ( NOLOCK ) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID  
--                INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID  
--                INNER JOIN dbo.T_Invoice_Child_Header TICH WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID  
--                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH ( NOLOCK ) ON TRH.I_Centre_Id = TCHND.I_Center_ID  
--                INNER JOIN dbo.T_Centre_Master AS TCM2 WITH ( NOLOCK ) ON TCM2.I_Centre_Id = TCHND.I_Center_ID  
--                                                              AND TCM2.I_Centre_Id = TRH.I_Centre_Id  
--                        --INNER JOIN dbo.T_Student_Course_Detail TSCD WITH ( NOLOCK ) ON TRH.I_Student_Detail_ID = TSCD.I_Student_Detail_ID  
--                INNER JOIN dbo.T_Course_Master TCM WITH ( NOLOCK ) ON TICH.I_Course_ID = TCM.I_Course_ID  
--                INNER JOIN dbo.T_Fee_Component_Master AS TFCM ON TFCM.I_Fee_Component_ID = TICD.I_Fee_Component_ID  
--        WHERE   TRH.I_Status IN ( 0, 1 )  
--                AND TRH.I_Receipt_Type = 2  
--                AND ( TRH.Dt_Crtd_On >= @dtStartDate  
--                      AND TRH.Dt_Crtd_On < DATEADD(d, 1, @dtUptoDate)  
--                    )  
--                AND TRH.I_Centre_Id IN (  
--                SELECT  FGCFR.centerID  
--                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,  
--                                                   @iBrandID) FGCFR )  
--        GROUP BY TCHND.I_Brand_ID ,  
--                TCHND.S_Brand_Name ,  
--                TCHND.I_Center_ID ,  
--                TCHND.S_Center_Name ,  
--                CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'  
--                     THEN 'Judiciary'  
--                     WHEN TCM2.S_Center_Code LIKE 'IAS T%' THEN 'IAS'  
--                     WHEN TCM2.S_Center_Code = 'BRST' THEN 'AIPT'  
--                     WHEN TCM2.S_Center_Code LIKE 'FR-%' THEN 'Franchise'  
--                     ELSE 'Own'  
--                END ,  
--                DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '  
--                + CAST(DATEPART(YYYY, TRH.Dt_Crtd_On) AS VARCHAR) ,  
--                CONVERT(DATE, TRH.Dt_Crtd_On) ,  
--                TCM.I_Course_ID ,  
--                TCM.S_Course_Name ,  
--                TICD.I_Fee_Component_ID,  
--                TFCM.S_Component_Name,  
--                TFCM.S_Type_Of_Component  
--        UNION ALL  
--        SELECT  TCHND.I_Brand_ID ,  
--                TCHND.S_Brand_Name ,  
--                TCHND.I_Center_ID ,  
--                TCHND.S_Center_Name ,  
--                CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'  
--                     THEN 'Judiciary'  
--                     WHEN TCM2.S_Center_Code LIKE 'IAS T%' THEN 'IAS'  
--                     WHEN TCM2.S_Center_Code = 'BRST' THEN 'AIPT'  
--                     WHEN TCM2.S_Center_Code LIKE 'FR-%' THEN 'Franchise'  
--                     ELSE 'Own'  
--                END AS TypeofCentre ,  
--                CONVERT(DATE, TRH.Dt_Upd_On) AS TransactionDate ,  
--                DATENAME(MONTH, TRH.Dt_Upd_On) + ' '  
--                + CAST(DATEPART(YYYY, TRH.Dt_Upd_On) AS VARCHAR) AS MonthYear ,  
--                TCM.I_Course_ID ,  
--                TCM.S_Course_Name ,  
--                TICD.I_Fee_Component_ID ,  
--                TFCM.S_Component_Name,  
--                TFCM.S_Type_Of_Component,  
--                -SUM(ISNULL(TRCD.N_Amount_Paid, 0.0)) AS VALUE  
--        FROM    dbo.T_Receipt_Header TRH WITH ( NOLOCK )  
--                INNER JOIN dbo.T_Receipt_Component_Detail TRCD WITH ( NOLOCK ) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID  
--                INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID  
--                INNER JOIN dbo.T_Invoice_Child_Header TICH WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID  
--                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH ( NOLOCK ) ON TRH.I_Centre_Id = TCHND.I_Center_ID  
--                INNER JOIN dbo.T_Centre_Master AS TCM2 ON TCM2.I_Centre_Id = TCHND.I_Center_ID  
--                                                          AND TCM2.I_Centre_Id = TRH.I_Centre_Id  
--                        --INNER JOIN dbo.T_Student_Course_Detail TSCD WITH ( NOLOCK ) ON TRH.I_Student_Detail_ID = TSCD.I_Student_Detail_ID  
--                INNER JOIN dbo.T_Course_Master TCM WITH ( NOLOCK ) ON TICH.I_Course_ID = TCM.I_Course_ID  
--                INNER JOIN dbo.T_Fee_Component_Master AS TFCM ON TFCM.I_Fee_Component_ID = TICD.I_Fee_Component_ID  
--        WHERE   TRH.I_Status = 0  
--                AND TRH.I_Receipt_Type = 2  
--                AND ( TRH.Dt_Upd_On >= @dtStartDate  
--                      AND TRH.Dt_Upd_On < DATEADD(d, 1, @dtUptoDate)  
--                    )  
--                AND TRH.I_Centre_Id IN (  
--                SELECT  FGCFR.centerID  
--                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,  
--                                                   @iBrandID) FGCFR )  
--        GROUP BY TCHND.I_Brand_ID ,  
--                TCHND.S_Brand_Name ,  
--                TCHND.I_Center_ID ,  
--                TCHND.S_Center_Name ,  
--                CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'  
--                     THEN 'Judiciary'  
--                     WHEN TCM2.S_Center_Code LIKE 'IAS T%' THEN 'IAS'  
--                     WHEN TCM2.S_Center_Code = 'BRST' THEN 'AIPT'  
--                     WHEN TCM2.S_Center_Code LIKE 'FR-%' THEN 'Franchise'  
--                     ELSE 'Own'  
--                END ,  
--                DATENAME(MONTH, TRH.Dt_Upd_On) + ' '  
--                + CAST(DATEPART(YYYY, TRH.Dt_Upd_On) AS VARCHAR) ,  
--                CONVERT(DATE, TRH.Dt_Upd_On) ,  
--                TCM.I_Course_ID ,  
--                TCM.S_Course_Name ,  
--                TICD.I_Fee_Component_ID,  
--                TFCM.S_Component_Name,  
--                TFCM.S_Type_Of_Component            
  
   
 --PRINT @StartDate  
   
        UPDATE  #FINDATA  
        SET     Category = CASE WHEN TypeofComp = 'M' THEN 'MTF Collection'  
                                ELSE 'Fresh Collection'  
                           END  
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
                        TypeofComp  
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
                        TypeofComp  
                FROM    #FINDATA AS T1  
                WHERE   CONVERT(DATE, T1.TransactionDate) = CONVERT(DATE, @dtUptoDate)  
                        AND T1.FinancialRange != 'YTD'  
                        
 --SELECT @ODCol=@ODCol+SUM(F.NValue) FROM #FINDATA AS F WHERE F.FinancialRange='OD'  
        SELECT  *  
        FROM    #FINDATA AS F  
 --PRINT dbo.fNumToWords(ROUND(@ODCol,0))  
   
        DROP TABLE #FINDATA  
  
    END  
             