CREATE PROCEDURE [REPORT].[uspGetHistoricalBusinessData]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @FromDate DATE ,
      @ToDate DATE
    )
AS 
    BEGIN

        --DECLARE @FromDate DATETIME= CONVERT(VARCHAR(4), @YearFrom) + '-'
        --    + CONVERT(VARCHAR(2), @MonthFrom) + '-01'
        --DECLARE @ToDate DATETIME= CONVERT(VARCHAR(4), @YearTo) + '-'
        --    + CONVERT(VARCHAR(2), @MonthTo) + '-01'
        
        DECLARE @PrevFromDate DATE= DATEADD(YYYY, -1, @FromDate)
        DECLARE @PrevToDate DATE= DATEADD(YYYY, -1, @ToDate)
        
        
        CREATE TABLE #CenterList ( CenterID INT )

        INSERT  INTO #CenterList
                ( CenterID 
                )
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR
                                                   
                                                   
        CREATE TABLE #temp
            (
              BrandID INT ,
              BrandName VARCHAR(MAX) ,
              CentreID INT ,
              CentreName VARCHAR(MAX) ,
              MonthN VARCHAR(MAX) ,
              MonthYear VARCHAR(MAX) ,
              RowCategory VARCHAR(MAX) ,
              ColumnCategory VARCHAR(MAX) ,
              Total INT
            )                                           

        --WHILE ( @FromDate <= @ToDate ) 
        --    BEGIN
        INSERT  INTO #temp
                ( BrandID ,
                  BrandName ,
                  CentreID ,
                  CentreName ,
                  MonthYear ,
                  RowCategory ,
                  ColumnCategory ,
                  Total
                )
                SELECT  TCHND.I_Brand_ID ,
                        TCHND.S_Brand_Name ,
                        TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
                        DATENAME(MONTH, TERD.Dt_Crtd_On) + ' '
                        + CAST(DATEPART(YYYY, TERD.Dt_Crtd_On) AS VARCHAR) AS MonthYear ,
                        'Enquiry' AS RowCategory ,
                        'TY' AS ColumnCategory ,
                        COUNT(DISTINCT TERD.I_Enquiry_Regn_ID) AS Total
                FROM    dbo.T_Enquiry_Regn_Detail TERD WITH (NOLOCK)
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH (NOLOCK) ON TERD.I_Centre_Id = TCHND.I_Center_ID
                        INNER JOIN #CenterList CL WITH (NOLOCK) ON TERD.I_Centre_Id = CL.CenterID
                WHERE   TERD.Dt_Crtd_On >= @FromDate
                        AND TERD.Dt_Crtd_On < DATEADD(d, 1, @ToDate)
                GROUP BY TCHND.I_Brand_ID ,
                        TCHND.S_Brand_Name ,
                        TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
                        DATENAME(MONTH, TERD.Dt_Crtd_On) + ' '
                        + CAST(DATEPART(YYYY, TERD.Dt_Crtd_On) AS VARCHAR)
                UNION ALL
                SELECT  TCHND.I_Brand_ID ,
                        TCHND.S_Brand_Name ,
                        TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
                        DATENAME(MONTH, TSD.Dt_Crtd_On) + ' '
                        + CAST(DATEPART(YYYY, TSD.Dt_Crtd_On) AS VARCHAR) AS MonthYear ,
                        'Admission' AS RowCategory ,
                        'TY' AS ColumnCategory ,
                        COUNT(DISTINCT TSD.I_Student_Detail_ID) AS Total
                FROM    dbo.T_Student_Detail TSD WITH (NOLOCK)
                        INNER JOIN dbo.T_Student_Center_Detail TSCD WITH (NOLOCK) ON TSD.I_Student_Detail_ID = TSCD.I_Student_Detail_ID
                                                              AND CONVERT(DATE, TSD.Dt_Crtd_On) = CONVERT(DATE, TSCD.Dt_Valid_From)
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH (NOLOCK) ON TSCD.I_Centre_Id = TCHND.I_Center_ID
                WHERE   TCHND.I_Center_ID IN ( SELECT   CL.CenterID
                                               FROM     #CenterList CL WITH (NOLOCK) )
                        AND ( TSD.Dt_Crtd_On >= @FromDate
                              AND TSD.Dt_Crtd_On < DATEADD(d, 1, @ToDate)
                            )
                GROUP BY TCHND.I_Brand_ID ,
                        TCHND.S_Brand_Name ,
                        TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
                        DATENAME(MONTH, TSD.Dt_Crtd_On) + ' '
                        + CAST(DATEPART(YYYY, TSD.Dt_Crtd_On) AS VARCHAR)
                UNION ALL
                SELECT  T1.I_Brand_ID ,
                        T1.S_Brand_Name ,
                        T1.I_Center_ID ,
                        T1.S_Center_Name ,
                        T1.MonthYear ,
                        T1.RowCategory ,
                        T1.ColumnCategory ,
                        SUM(T1.Total) AS Total
                FROM    ( SELECT    TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Crtd_On) AS VARCHAR) AS MonthYear ,
                                    'FreshCollection' AS RowCategory ,
                                    'TY' AS ColumnCategory ,
                                    SUM(TRCD.N_Amount_Paid) AS Total
                          FROM      dbo.T_Receipt_Header TRH WITH (NOLOCK)
                                    INNER JOIN dbo.T_Receipt_Component_Detail TRCD WITH (NOLOCK) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                    INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH (NOLOCK) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH (NOLOCK) ON TRH.I_Centre_Id = TCHND.I_Center_ID
                                    INNER JOIN dbo.T_Fee_Component_Master TFCM WITH (NOLOCK) ON TICD.I_Fee_Component_ID=TFCM.I_Fee_Component_ID
                          WHERE     TRH.I_Status = 1
                                    AND TRH.I_Receipt_Type = 2
                                    AND TFCM.I_Fee_Component_ID NOT IN ( 50,
                                                              57, 58 )
                                    AND ( TRH.Dt_Crtd_On >= @FromDate
                                          AND TRH.Dt_Crtd_On < DATEADD(d, 1,
                                                              @ToDate)
                                        )
                                    AND TRH.I_Centre_Id IN ( SELECT
                                                              CL.CenterID
                                                             FROM
                                                              #CenterList CL WITH (NOLOCK) )
                          GROUP BY  TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Crtd_On) AS VARCHAR)
                          UNION ALL
                          SELECT    TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Upd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Upd_On) AS VARCHAR) AS MonthYear ,
                                    'FreshCollection' AS RowCategory ,
                                    'TY' AS ColumnCategory ,
                                    -SUM(TRCD.N_Amount_Paid) AS Total
                          FROM      dbo.T_Receipt_Header TRH WITH (NOLOCK)
                                    INNER JOIN dbo.T_Receipt_Component_Detail TRCD WITH (NOLOCK) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                    INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH (NOLOCK) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH (NOLOCK) ON TRH.I_Centre_Id = TCHND.I_Center_ID
                                    INNER JOIN dbo.T_Fee_Component_Master TFCM WITH (NOLOCK) ON TICD.I_Fee_Component_ID=TFCM.I_Fee_Component_ID
                          WHERE     TRH.I_Status = 0
                                    AND TRH.I_Receipt_Type = 2
                                    AND TFCM.I_Fee_Component_ID NOT IN ( 50,
                                                              57, 58 )
                                    AND ( TRH.Dt_Upd_On >= @FromDate
                                          AND TRH.Dt_Upd_On < DATEADD(d, 1,
                                                              @ToDate)
                                        )
                                    AND TRH.I_Centre_Id IN ( SELECT
                                                              CL.CenterID
                                                             FROM
                                                              #CenterList CL WITH (NOLOCK) )
                          GROUP BY  TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Upd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Upd_On) AS VARCHAR)
                        ) AS T1
                GROUP BY T1.I_Brand_ID ,
                        T1.S_Brand_Name ,
                        T1.I_Center_ID ,
                        T1.S_Center_Name ,
                        T1.MonthYear ,
                        T1.RowCategory ,
                        T1.ColumnCategory
                UNION ALL
                SELECT  T1.I_Brand_ID ,
                        T1.S_Brand_Name ,
                        T1.I_Center_ID ,
                        T1.S_Center_Name ,
                        T1.MonthYear ,
                        T1.RowCategory ,
                        T1.ColumnCategory ,
                        SUM(T1.Total) AS Total
                FROM    ( SELECT    TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Crtd_On) AS VARCHAR) AS MonthYear ,
                                    'MTF Collection' AS RowCategory ,
                                    'TY' AS ColumnCategory ,
                                    SUM(TRCD.N_Amount_Paid) AS Total
                          FROM      dbo.T_Receipt_Header TRH WITH (NOLOCK)
                                    INNER JOIN dbo.T_Receipt_Component_Detail TRCD WITH (NOLOCK) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                    INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH (NOLOCK) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH (NOLOCK) ON TRH.I_Centre_Id = TCHND.I_Center_ID
                                    INNER JOIN dbo.T_Fee_Component_Master TFCM WITH (NOLOCK) ON TICD.I_Fee_Component_ID=TFCM.I_Fee_Component_ID
                          WHERE     TRH.I_Status = 1
                                    AND TRH.I_Receipt_Type = 2
                                    AND TFCM.I_Fee_Component_ID IN ( 50, 57,
                                                              58 )
                                    AND ( TRH.Dt_Crtd_On >= @FromDate
                                          AND TRH.Dt_Crtd_On < DATEADD(d, 1,
                                                              @ToDate)
                                        )
                                    AND TRH.I_Centre_Id IN ( SELECT
                                                              CL.CenterID
                                                             FROM
                                                              #CenterList CL WITH (NOLOCK) )
                          GROUP BY  TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Crtd_On) AS VARCHAR)
                          UNION ALL
                          SELECT    TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Upd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Upd_On) AS VARCHAR) AS MonthYear ,
                                    'MTF Collection' AS RowCategory ,
                                    'TY' AS ColumnCategory ,
                                    -SUM(TRCD.N_Amount_Paid) AS Total
                          FROM      dbo.T_Receipt_Header TRH WITH (NOLOCK)
                                    INNER JOIN dbo.T_Receipt_Component_Detail TRCD WITH (NOLOCK) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                    INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH (NOLOCK) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH (NOLOCK) ON TRH.I_Centre_Id = TCHND.I_Center_ID
                                    INNER JOIN dbo.T_Fee_Component_Master TFCM WITH (NOLOCK) ON TICD.I_Fee_Component_ID=TFCM.I_Fee_Component_ID
                          WHERE     TRH.I_Status = 0
                                    AND TRH.I_Receipt_Type = 2
                                    AND TFCM.I_Fee_Component_ID IN ( 50, 57,
                                                              58 )
                                    AND ( TRH.Dt_Upd_On >= @FromDate
                                          AND TRH.Dt_Upd_On < DATEADD(d, 1,
                                                              @ToDate)
                                        )
                                    AND TRH.I_Centre_Id IN ( SELECT
                                                              CL.CenterID
                                                             FROM
                                                              #CenterList CL WITH (NOLOCK) )
                          GROUP BY  TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Upd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Upd_On) AS VARCHAR)
                        ) AS T1
                GROUP BY T1.I_Brand_ID ,
                        T1.S_Brand_Name ,
                        T1.I_Center_ID ,
                        T1.S_Center_Name ,
                        T1.MonthYear ,
                        T1.RowCategory ,
                        T1.ColumnCategory
                UNION ALL
                SELECT  T1.I_Brand_ID ,
                        T1.S_Brand_Name ,
                        T1.I_Center_ID ,
                        T1.S_Center_Name ,
                        T1.MonthYear ,
                        T1.RowCategory ,
                        T1.ColumnCategory, 
                        SUM(T1.Total) AS Total
                FROM    ( SELECT    TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Crtd_On) AS VARCHAR) AS MonthYear ,
                                    'Total Collection' AS RowCategory ,
                                    'TY' AS ColumnCategory ,
                                    SUM(TRCD.N_Amount_Paid) AS Total
                          FROM      dbo.T_Receipt_Header TRH WITH (NOLOCK)
                                    INNER JOIN dbo.T_Receipt_Component_Detail TRCD WITH (NOLOCK) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                    INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH (NOLOCK) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH (NOLOCK) ON TRH.I_Centre_Id = TCHND.I_Center_ID
                                    --INNER JOIN dbo.T_Fee_Component_Master TFCM WITH (NOLOCK) ON TICD.I_Fee_Component_ID=TFCM.I_Fee_Component_ID
                          WHERE     TRH.I_Status = 1
                                    AND TRH.I_Receipt_Type = 2
                                    AND ( TRH.Dt_Crtd_On >= @FromDate
                                          AND TRH.Dt_Crtd_On < DATEADD(d, 1,
                                                              @ToDate)
                                        )
                                    AND TRH.I_Centre_Id IN ( SELECT
                                                              CL.CenterID
                                                             FROM
                                                              #CenterList CL WITH (NOLOCK) )
                          GROUP BY  TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Crtd_On) AS VARCHAR)
                          UNION ALL
                          SELECT    TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Upd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Upd_On) AS VARCHAR) AS MonthYear ,
                                    'Total Collection' AS RowCategory ,
                                    'TY' AS ColumnCategory ,
                                    -SUM(TRCD.N_Amount_Paid) AS Total
                          FROM      dbo.T_Receipt_Header TRH WITH (NOLOCK)
                                    INNER JOIN dbo.T_Receipt_Component_Detail TRCD WITH (NOLOCK) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                    INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH (NOLOCK) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH (NOLOCK) ON TRH.I_Centre_Id = TCHND.I_Center_ID
                          WHERE     TRH.I_Status = 0
                                    AND TRH.I_Receipt_Type = 2
                                    AND ( TRH.Dt_Upd_On >= @FromDate
                                          AND TRH.Dt_Upd_On < DATEADD(d, 1,
                                                              @ToDate)
                                        )
                                    AND TRH.I_Centre_Id IN ( SELECT
                                                              CL.CenterID
                                                             FROM
                                                              #CenterList CL WITH (NOLOCK) )
                          GROUP BY  TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Upd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Upd_On) AS VARCHAR)
                        ) AS T1
                GROUP BY T1.I_Brand_ID ,
                        T1.S_Brand_Name ,
                        T1.I_Center_ID ,
                        T1.S_Center_Name ,
                        T1.MonthYear ,
                        T1.RowCategory ,
                        T1.ColumnCategory
                UNION ALL
                
                ---Previous Year Data
                SELECT  TCHND.I_Brand_ID ,
                        TCHND.S_Brand_Name ,
                        TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
                        DATENAME(MONTH, TERD.Dt_Crtd_On) + ' '
                        + CAST(DATEPART(YYYY, TERD.Dt_Crtd_On) AS VARCHAR) AS MonthYear ,
                        'Enquiry' AS RowCategory ,
                        'LY' AS ColumnCategory ,
                        COUNT(DISTINCT TERD.I_Enquiry_Regn_ID) AS Total
                FROM    dbo.T_Enquiry_Regn_Detail TERD WITH (NOLOCK)
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH (NOLOCK) ON TERD.I_Centre_Id = TCHND.I_Center_ID
                        INNER JOIN #CenterList CL WITH (NOLOCK) ON TERD.I_Centre_Id = CL.CenterID
                WHERE   TERD.Dt_Crtd_On >= @PrevFromDate
                        AND TERD.Dt_Crtd_On < DATEADD(d, 1, @PrevToDate)
                GROUP BY TCHND.I_Brand_ID ,
                        TCHND.S_Brand_Name ,
                        TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
                        DATENAME(MONTH, TERD.Dt_Crtd_On) + ' '
                        + CAST(DATEPART(YYYY, TERD.Dt_Crtd_On) AS VARCHAR)
                UNION ALL
                SELECT  TCHND.I_Brand_ID ,
                        TCHND.S_Brand_Name ,
                        TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
                        DATENAME(MONTH, TSD.Dt_Crtd_On) + ' '
                        + CAST(DATEPART(YYYY, TSD.Dt_Crtd_On) AS VARCHAR) AS MonthYear ,
                        'Admission' AS RowCategory ,
                        'LY' AS ColumnCategory ,
                        COUNT(DISTINCT TSD.I_Student_Detail_ID) AS Total
                FROM    dbo.T_Student_Detail TSD WITH (NOLOCK)
                        INNER JOIN dbo.T_Student_Center_Detail TSCD WITH (NOLOCK) ON TSD.I_Student_Detail_ID = TSCD.I_Student_Detail_ID
                                                              AND CONVERT(DATE, TSD.Dt_Crtd_On) = CONVERT(DATE, TSCD.Dt_Valid_From)
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH (NOLOCK) ON TSCD.I_Centre_Id = TCHND.I_Center_ID
                WHERE   TCHND.I_Center_ID IN ( SELECT   CL.CenterID
                                               FROM     #CenterList CL WITH (NOLOCK) )
                        AND ( TSD.Dt_Crtd_On >= @PrevFromDate
                              AND TSD.Dt_Crtd_On < DATEADD(d, 1, @PrevToDate)
                            )
                GROUP BY TCHND.I_Brand_ID ,
                        TCHND.S_Brand_Name ,
                        TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
                        DATENAME(MONTH, TSD.Dt_Crtd_On) + ' '
                        + CAST(DATEPART(YYYY, TSD.Dt_Crtd_On) AS VARCHAR)
                UNION ALL
                SELECT  T1.I_Brand_ID ,
                        T1.S_Brand_Name ,
                        T1.I_Center_ID ,
                        T1.S_Center_Name ,
                        T1.MonthYear ,
                        T1.RowCategory ,
                        T1.ColumnCategory ,
                        SUM(T1.Total) AS Total
                FROM    ( SELECT    TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Crtd_On) AS VARCHAR) AS MonthYear ,
                                    'FreshCollection' AS RowCategory ,
                                    'LY' AS ColumnCategory ,
                                    SUM(TRCD.N_Amount_Paid) AS Total
                          FROM      dbo.T_Receipt_Header TRH WITH (NOLOCK)
                                    INNER JOIN dbo.T_Receipt_Component_Detail TRCD WITH (NOLOCK) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                    INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH (NOLOCK) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH (NOLOCK) ON TRH.I_Centre_Id = TCHND.I_Center_ID
                                    INNER JOIN dbo.T_Fee_Component_Master TFCM WITH (NOLOCK) ON TICD.I_Fee_Component_ID=TFCM.I_Fee_Component_ID
                          WHERE     TRH.I_Status = 1
                                    AND TRH.I_Receipt_Type = 2
                                    AND TFCM.I_Fee_Component_ID NOT IN ( 50,
                                                              57, 58 )
                                    AND ( TRH.Dt_Crtd_On >= @PrevFromDate
                                          AND TRH.Dt_Crtd_On < DATEADD(d, 1,
                                                              @PrevToDate)
                                        )
                                    AND TRH.I_Centre_Id IN ( SELECT
                                                              CL.CenterID
                                                             FROM
                                                              #CenterList CL WITH (NOLOCK) )
                          GROUP BY  TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Crtd_On) AS VARCHAR)
                          UNION ALL
                          SELECT    TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Upd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Upd_On) AS VARCHAR) AS MonthYear ,
                                    'FreshCollection' AS RowCategory ,
                                    'LY' AS ColumnCategory ,
                                    -SUM(TRCD.N_Amount_Paid) AS Total
                          FROM      dbo.T_Receipt_Header TRH WITH (NOLOCK)
                                    INNER JOIN dbo.T_Receipt_Component_Detail TRCD WITH (NOLOCK) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                    INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH (NOLOCK) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH (NOLOCK) ON TRH.I_Centre_Id = TCHND.I_Center_ID
                                    INNER JOIN dbo.T_Fee_Component_Master TFCM WITH (NOLOCK) ON TICD.I_Fee_Component_ID=TFCM.I_Fee_Component_ID
                          WHERE     TRH.I_Status = 0
                                    AND TRH.I_Receipt_Type = 2
                                    AND TFCM.I_Fee_Component_ID NOT IN ( 50,
                                                              57, 58 )
                                    AND ( TRH.Dt_Upd_On >= @PrevFromDate
                                          AND TRH.Dt_Upd_On < DATEADD(d, 1,
                                                              @PrevToDate)
                                        )
                                    AND TRH.I_Centre_Id IN ( SELECT
                                                              CL.CenterID
                                                             FROM
                                                              #CenterList CL WITH (NOLOCK) )
                          GROUP BY  TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Upd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Upd_On) AS VARCHAR)
                        ) AS T1
                GROUP BY T1.I_Brand_ID ,
                        T1.S_Brand_Name ,
                        T1.I_Center_ID ,
                        T1.S_Center_Name ,
                        T1.MonthYear ,
                        T1.RowCategory ,
                        T1.ColumnCategory
                UNION ALL
                SELECT  T1.I_Brand_ID ,
                        T1.S_Brand_Name ,
                        T1.I_Center_ID ,
                        T1.S_Center_Name ,
                        T1.MonthYear ,
                        T1.RowCategory ,
                        T1.ColumnCategory ,
                        SUM(T1.Total) AS Total
                FROM    ( SELECT    TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Crtd_On) AS VARCHAR) AS MonthYear ,
                                    'MTF Collection' AS RowCategory ,
                                    'LY' AS ColumnCategory ,
                                    SUM(TRCD.N_Amount_Paid) AS Total
                          FROM      dbo.T_Receipt_Header TRH WITH (NOLOCK)
                                    INNER JOIN dbo.T_Receipt_Component_Detail TRCD WITH (NOLOCK) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                    INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH (NOLOCK) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH (NOLOCK) ON TRH.I_Centre_Id = TCHND.I_Center_ID
                          WHERE     TRH.I_Status = 1
                                    AND TRH.I_Receipt_Type = 2
                                    AND TICD.I_Fee_Component_ID IN ( 50, 57,
                                                              58 )
                                    AND ( TRH.Dt_Crtd_On >= @PrevFromDate
                                          AND TRH.Dt_Crtd_On < DATEADD(d, 1,
                                                              @PrevToDate)
                                        )
                                    AND TRH.I_Centre_Id IN ( SELECT
                                                              CL.CenterID
                                                             FROM
                                                              #CenterList CL WITH (NOLOCK) )
                          GROUP BY  TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Crtd_On) AS VARCHAR)
                          UNION ALL
                          SELECT    TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Upd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Upd_On) AS VARCHAR) AS MonthYear ,
                                    'MTF Collection' AS RowCategory ,
                                    'LY' AS ColumnCategory ,
                                    -SUM(TRCD.N_Amount_Paid) AS Total
                          FROM      dbo.T_Receipt_Header TRH WITH (NOLOCK)
                                    INNER JOIN dbo.T_Receipt_Component_Detail TRCD WITH (NOLOCK) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                    INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH (NOLOCK) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH (NOLOCK) ON TRH.I_Centre_Id = TCHND.I_Center_ID
                          WHERE     TRH.I_Status = 0
                                    AND TRH.I_Receipt_Type = 2
                                    AND TICD.I_Fee_Component_ID IN ( 50, 57,
                                                              58 )
                                    AND ( TRH.Dt_Upd_On >= @PrevFromDate
                                          AND TRH.Dt_Upd_On < DATEADD(d, 1,
                                                              @PrevToDate)
                                        )
                                    AND TRH.I_Centre_Id IN ( SELECT
                                                              CL.CenterID
                                                             FROM
                                                              #CenterList CL WITH (NOLOCK) )
                          GROUP BY  TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Upd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Upd_On) AS VARCHAR)
                        ) AS T1
                GROUP BY T1.I_Brand_ID ,
                        T1.S_Brand_Name ,
                        T1.I_Center_ID ,
                        T1.S_Center_Name ,
                        T1.MonthYear ,
                        T1.RowCategory ,
                        T1.ColumnCategory
                UNION ALL
                SELECT  T1.I_Brand_ID ,
                        T1.S_Brand_Name ,
                        T1.I_Center_ID ,
                        T1.S_Center_Name ,
                        T1.MonthYear ,
                        T1.RowCategory ,
                        T1.ColumnCategory ,
                        SUM(T1.Total) AS Total
                FROM    ( SELECT    TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Crtd_On) AS VARCHAR) AS MonthYear ,
                                    'Total Collection' AS RowCategory ,
                                    'LY' AS ColumnCategory ,
                                    SUM(TRCD.N_Amount_Paid) AS Total
                          FROM      dbo.T_Receipt_Header TRH WITH (NOLOCK)
                                    INNER JOIN dbo.T_Receipt_Component_Detail TRCD WITH (NOLOCK) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                    INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH (NOLOCK) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH (NOLOCK) ON TRH.I_Centre_Id = TCHND.I_Center_ID
                          WHERE     TRH.I_Status = 1
                                    AND TRH.I_Receipt_Type = 2
                                    AND ( TRH.Dt_Crtd_On >= @PrevFromDate
                                          AND TRH.Dt_Crtd_On < DATEADD(d, 1,
                                                              @PrevToDate)
                                        )
                                    AND TRH.I_Centre_Id IN ( SELECT
                                                              CL.CenterID
                                                             FROM
                                                              #CenterList CL WITH (NOLOCK) )
                          GROUP BY  TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Crtd_On) AS VARCHAR)
                          UNION ALL
                          SELECT    TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Upd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Upd_On) AS VARCHAR) AS MonthYear ,
                                    'Total Collection' AS RowCategory ,
                                    'LY' AS ColumnCategory ,
                                    -SUM(TRCD.N_Amount_Paid) AS Total
                          FROM      dbo.T_Receipt_Header TRH WITH (NOLOCK)
                                    INNER JOIN dbo.T_Receipt_Component_Detail TRCD WITH (NOLOCK) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                                    INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH (NOLOCK) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH (NOLOCK) ON TRH.I_Centre_Id = TCHND.I_Center_ID
                          WHERE     TRH.I_Status = 0
                                    AND TRH.I_Receipt_Type = 2
                                    AND ( TRH.Dt_Upd_On >= @PrevFromDate
                                          AND TRH.Dt_Upd_On < DATEADD(d, 1,
                                                              @PrevToDate)
                                        )
                                    AND TRH.I_Centre_Id IN ( SELECT
                                                              CL.CenterID
                                                             FROM
                                                              #CenterList CL WITH (NOLOCK) )
                          GROUP BY  TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    DATENAME(MONTH, TRH.Dt_Upd_On) + ' '
                                    + CAST(DATEPART(YYYY, TRH.Dt_Upd_On) AS VARCHAR)
                        ) AS T1
                GROUP BY T1.I_Brand_ID ,
                        T1.S_Brand_Name ,
                        T1.I_Center_ID ,
                        T1.S_Center_Name ,
                        T1.MonthYear ,
                        T1.RowCategory ,
                        T1.ColumnCategory
                
        UPDATE  #temp
        SET     MonthN = LEFT(MonthYear, CHARINDEX(' ', MonthYear) - 1) 
        
        UPDATE #temp SET Total=1 WHERE Total=0
                
        SELECT  TT.BrandID ,
                TT.BrandName ,
                TT.CentreID ,
                TT.CentreName ,
                TT.MonthN ,
                TT.MonthYear ,
                TT.RowCategory ,
                'Growth' AS ColumnCategory ,
                ( ( TT.Total / T3.Total ) - 1 ) * 100 AS Total
        FROM    ( SELECT    BrandID ,
                            BrandName ,
                            CentreID ,
                            CentreName ,
                            MonthN ,
                            MonthYear ,
                            RowCategory ,
                            ColumnCategory ,
                            Total
                  FROM      #temp T2
                  WHERE     T2.ColumnCategory = 'TY'
                ) TT
                INNER JOIN ( SELECT BrandID ,
                                    BrandName ,
                                    CentreID ,
                                    CentreName ,
                                    MonthN ,
                                    MonthYear ,
                                    RowCategory ,
                                    ColumnCategory ,
                                    Total
                             FROM   #temp T2
                             WHERE  T2.ColumnCategory = 'LY'
                           ) T3 ON TT.MonthN = T3.MonthN
                                   AND TT.CentreName = T3.CentreName
                                   AND TT.RowCategory = T3.RowCategory
        UNION ALL
        SELECT  TT.BrandID ,
                TT.BrandName ,
                TT.CentreID ,
                TT.CentreName ,
                TT.MonthN ,
                TT.MonthYear ,
                TT.RowCategory ,
                TT.ColumnCategory ,
                TT.Total
        FROM    #temp TT     


    END
