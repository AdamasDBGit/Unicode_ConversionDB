CREATE PROCEDURE [REPORT].[uspGetDailySalesReport]
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
I_Center_ID INT,
S_Center_Name VARCHAR(MAX),
NValue DECIMAL(14,2),
I_FeeComponent_ID INT
)

INSERT INTO #temp
        ( I_Center_ID ,
          S_Center_Name ,
          I_FeeComponent_ID,
          NValue
        )
SELECT    TCHND.I_Center_ID ,
                            TCHND.S_Center_Name ,
                            TICD.I_Fee_Component_ID,
                            SUM(ISNULL(TRCD.N_Amount_Paid,0.0)) AS VALUE
                  FROM      dbo.T_Receipt_Header TRH WITH ( NOLOCK )
                            INNER JOIN dbo.T_Receipt_Component_Detail TRCD
                            WITH ( NOLOCK ) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                            INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                            INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND
                            WITH ( NOLOCK ) ON TRH.I_Centre_Id = TCHND.I_Center_ID
                  WHERE     TRH.I_Status IN ( 0, 1 )
                            AND TRH.I_Receipt_Type = 2
                            AND ( TRH.Dt_Crtd_On >= @dtStartDate
                                  AND TRH.Dt_Crtd_On < DATEADD(d, 1,
                                                              @dtEndDate)
                                )
                            AND TRH.I_Centre_Id IN (
                            SELECT  FGCFR.centerID
                            FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR )
                  GROUP BY  TCHND.I_Center_ID ,
                            TCHND.S_Center_Name,
                            TICD.I_Fee_Component_ID
                            UNION ALL
                  SELECT    TCHND.I_Center_ID ,
                            TCHND.S_Center_Name ,
                            TICD.I_Fee_Component_ID,
                            -SUM(ISNULL(TRCD.N_Amount_Paid,0.0)) AS VALUE
                  FROM      dbo.T_Receipt_Header TRH WITH ( NOLOCK )
                            INNER JOIN dbo.T_Receipt_Component_Detail TRCD
                            WITH ( NOLOCK ) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                            INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                            INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND
                            WITH ( NOLOCK ) ON TRH.I_Centre_Id = TCHND.I_Center_ID
                  WHERE     TRH.I_Status = 0
                            AND TRH.I_Receipt_Type = 2
                            AND ( TRH.Dt_Upd_On >= @dtStartDate
                                  AND TRH.Dt_Upd_On < DATEADD(d, 1, @dtEndDate)
                                )
                            AND TRH.I_Centre_Id IN (
                            SELECT  FGCFR.centerID
                            FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR )
                  GROUP BY  TCHND.I_Center_ID ,
                            TCHND.S_Center_Name,
                            TICD.I_Fee_Component_ID
                            
                            --SELECT * FROM #temp T1
                            
                            
        SELECT  TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                'Form/Prospectus(Old Reg)' AS Category ,
                COUNT(DISTINCT TRH.I_Receipt_Header_ID) AS Value
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TRH.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
                INNER JOIN dbo.T_Information_Source_Master TISM ON TERD.I_Info_Source_ID = TISM.I_Info_Source_ID
        WHERE   TRH.I_Status = 1
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND TRH.I_Receipt_Type IN ( 31, 32, 50, 51, 57, 85 )
                AND TRH.Dt_Crtd_On >= @dtStartDate
                AND TRH.Dt_Crtd_On < DATEADD(d, 1, @dtEndDate)
                AND TISM.I_Info_Source_ID = 3
        GROUP BY TCHND.I_Center_ID ,
                TCHND.S_Center_Name
        UNION ALL
        SELECT  TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                'Form/Prospectus(New)' AS Category ,
                COUNT(DISTINCT TRH.I_Receipt_Header_ID) AS Value
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TRH.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
                INNER JOIN dbo.T_Information_Source_Master TISM ON TERD.I_Info_Source_ID = TISM.I_Info_Source_ID
        WHERE   TRH.I_Status = 1
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND TRH.I_Receipt_Type IN ( 31, 32, 50, 51, 57, 85 )
                AND TRH.Dt_Crtd_On >= @dtStartDate
                AND TRH.Dt_Crtd_On < DATEADD(d, 1, @dtEndDate)
                AND TISM.I_Info_Source_ID != 3
        GROUP BY TCHND.I_Center_ID ,
                TCHND.S_Center_Name
        UNION ALL
        SELECT  TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                'PreEnquiry/Enquiry(Old Reg)' AS Category ,
                COUNT(DISTINCT TERD.I_Enquiry_Regn_ID) AS Value
        FROM    dbo.T_Enquiry_Regn_Detail TERD
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TERD.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_Information_Source_Master TISM ON TERD.I_Info_Source_ID = TISM.I_Info_Source_ID
        WHERE   TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND TERD.Dt_Crtd_On >= @dtStartDate
                AND TERD.Dt_Crtd_On < DATEADD(d, 1, @dtEndDate)
                AND TISM.I_Info_Source_ID = 3
        GROUP BY TCHND.I_Center_ID ,
                TCHND.S_Center_Name
        UNION ALL
        SELECT  TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                'PreEnquiry/Enquiry(New)' AS Category ,
                COUNT(DISTINCT TERD.I_Enquiry_Regn_ID) AS Value
        FROM    dbo.T_Enquiry_Regn_Detail TERD
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TERD.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_Information_Source_Master TISM ON TERD.I_Info_Source_ID = TISM.I_Info_Source_ID
        WHERE   TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND TERD.Dt_Crtd_On >= @dtStartDate
                AND TERD.Dt_Crtd_On < DATEADD(d, 1, @dtEndDate)
                AND TISM.I_Info_Source_ID != 3
        GROUP BY TCHND.I_Center_ID ,
                TCHND.S_Center_Name
        UNION ALL
        SELECT  TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                'Registration (Old)' AS Category ,
                COUNT(DISTINCT TSD.S_Student_ID) AS Value
        FROM    dbo.T_Student_Detail TSD
                INNER JOIN dbo.T_Student_Center_Detail TSCD ON TSD.I_Student_Detail_ID = TSCD.I_Student_Detail_ID
                                                              AND CONVERT(DATE, TSD.Dt_Crtd_On) = CONVERT(DATE, TSCD.Dt_Valid_From)
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TSCD.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
                INNER JOIN dbo.T_Information_Source_Master TISM ON TERD.I_Info_Source_ID = TISM.I_Info_Source_ID
        WHERE   TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND TSD.Dt_Crtd_On >= @dtStartDate
                AND TSD.Dt_Crtd_On < DATEADD(d, 1, @dtEndDate)
                AND TERD.I_Enquiry_Status_Code = 3
                AND TISM.I_Info_Source_ID = 3
        GROUP BY TCHND.I_Center_ID ,
                TCHND.S_Center_Name
        UNION ALL
        SELECT  TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                'Registration (New)' AS Category ,
                COUNT(DISTINCT TSD.S_Student_ID) AS Value
        FROM    dbo.T_Student_Detail TSD
                INNER JOIN dbo.T_Student_Center_Detail TSCD ON TSD.I_Student_Detail_ID = TSCD.I_Student_Detail_ID
                                                              AND CONVERT(DATE, TSD.Dt_Crtd_On) = CONVERT(DATE, TSCD.Dt_Valid_From)
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TSCD.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
                INNER JOIN dbo.T_Information_Source_Master TISM ON TERD.I_Info_Source_ID = TISM.I_Info_Source_ID
        WHERE   TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND TSD.Dt_Crtd_On >= @dtStartDate
                AND TSD.Dt_Crtd_On < DATEADD(d, 1, @dtEndDate)
                AND TERD.I_Enquiry_Status_Code = 3
                AND TISM.I_Info_Source_ID != 3
        GROUP BY TCHND.I_Center_ID ,
                TCHND.S_Center_Name
        UNION ALL
        SELECT T1.I_Center_ID,T1.S_Center_Name,'Fresh Collection' AS Category,SUM(T1.NValue) AS Value FROM #temp T1
        WHERE
        T1.I_FeeComponent_ID NOT IN ( 50, 57, 58 )
        GROUP BY T1.I_Center_ID,T1.S_Center_Name
        UNION ALL
        SELECT T1.I_Center_ID,T1.S_Center_Name,'MTF Collection' AS Category,SUM(T1.NValue) AS Value FROM #temp T1
        WHERE
        T1.I_FeeComponent_ID IN ( 50, 57, 58 )
        GROUP BY T1.I_Center_ID,T1.S_Center_Name
        UNION ALL
        SELECT T1.I_Center_ID,T1.S_Center_Name,'Total Collection' AS Category,SUM(T1.NValue) AS Value FROM #temp T1
        GROUP BY T1.I_Center_ID,T1.S_Center_Name
        
        
        
        
        
        --SELECT  T1.I_Center_ID ,
        --        T1.S_Center_Name ,
        --        T1.Category ,
        --        SUM(T1.Value) AS Value
        --FROM    ( SELECT    TCHND.I_Center_ID ,
        --                    TCHND.S_Center_Name ,
        --                    'FreshCollection' AS Category ,
        --                    SUM(ISNULL(TRCD.N_Amount_Paid,0.0)) AS Value
        --          FROM      dbo.T_Receipt_Header TRH WITH ( NOLOCK )
        --                    INNER JOIN dbo.T_Receipt_Component_Detail TRCD
        --                    WITH ( NOLOCK ) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
        --                    INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
        --                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND
        --                    WITH ( NOLOCK ) ON TRH.I_Centre_Id = TCHND.I_Center_ID
        --                    INNER JOIN dbo.T_Fee_Component_Master TFCM WITH (NOLOCK) ON TICD.I_Fee_Component_ID=TFCM.I_Fee_Component_ID
        --          WHERE     TRH.I_Status IN ( 0, 1 )
        --                    AND TRH.I_Receipt_Type = 2
        --                    AND TFCM.I_Fee_Component_ID NOT IN ( 50, 57, 58 )
        --                    AND ( TRH.Dt_Crtd_On >= @dtStartDate
        --                          AND TRH.Dt_Crtd_On < DATEADD(d, 1,
        --                                                      @dtEndDate)
        --                        )
        --                    AND TRH.I_Centre_Id IN (
        --                    SELECT  FGCFR.centerID
        --                    FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
        --                                                      @iBrandID) FGCFR )
        --          GROUP BY  TCHND.I_Center_ID ,
        --                    TCHND.S_Center_Name
        --          UNION ALL
        --          SELECT    TCHND.I_Center_ID ,
        --                    TCHND.S_Center_Name ,
        --                    'FreshCollection' AS Category ,
        --                    -SUM(ISNULL(TRCD.N_Amount_Paid,0.0)) AS Value
        --          FROM      dbo.T_Receipt_Header TRH WITH ( NOLOCK )
        --                    INNER JOIN dbo.T_Receipt_Component_Detail TRCD
        --                    WITH ( NOLOCK ) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
        --                    INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
        --                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND
        --                    WITH ( NOLOCK ) ON TRH.I_Centre_Id = TCHND.I_Center_ID
        --                    INNER JOIN dbo.T_Fee_Component_Master TFCM WITH (NOLOCK) ON TICD.I_Fee_Component_ID=TFCM.I_Fee_Component_ID
        --          WHERE     TRH.I_Status = 0
        --                    AND TRH.I_Receipt_Type = 2
        --                    AND TFCM.I_Fee_Component_ID NOT IN ( 50, 57, 58 )
        --                    AND ( TRH.Dt_Upd_On >= @dtStartDate
        --                          AND TRH.Dt_Upd_On < DATEADD(d, 1, @dtEndDate)
        --                        )
        --                    AND TRH.I_Centre_Id IN (
        --                    SELECT  FGCFR.centerID
        --                    FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
        --                                                      @iBrandID) FGCFR )
        --          GROUP BY  TCHND.I_Center_ID ,
        --                    TCHND.S_Center_Name
        --        ) AS T1
        --GROUP BY T1.I_Center_ID ,
        --        T1.S_Center_Name ,
        --        T1.Category
        --UNION ALL
        --SELECT  T1.I_Center_ID ,
        --        T1.S_Center_Name ,
        --        T1.Category ,
        --        SUM(T1.Value) AS Value
        --FROM    ( SELECT    TCHND.I_Center_ID ,
        --                    TCHND.S_Center_Name ,
        --                    'MTF Collection' AS Category ,
        --                    SUM(ISNULL(TRCD.N_Amount_Paid,0.0)) AS Value
        --          FROM      dbo.T_Receipt_Header TRH WITH ( NOLOCK )
        --                    INNER JOIN dbo.T_Receipt_Component_Detail TRCD
        --                    WITH ( NOLOCK ) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
        --                    INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
        --                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND
        --                    WITH ( NOLOCK ) ON TRH.I_Centre_Id = TCHND.I_Center_ID
        --                    INNER JOIN dbo.T_Fee_Component_Master TFCM WITH (NOLOCK) ON TICD.I_Fee_Component_ID=TFCM.I_Fee_Component_ID
        --          WHERE     TRH.I_Status IN ( 0, 1 )
        --                    AND TRH.I_Receipt_Type = 2
        --                    AND TFCM.I_Fee_Component_ID IN ( 50, 57, 58 )
        --                    AND ( TRH.Dt_Crtd_On >= @dtStartDate
        --                          AND TRH.Dt_Crtd_On < DATEADD(d, 1,
        --                                                      @dtEndDate)
        --                        )
        --                    AND TRH.I_Centre_Id IN (
        --                    SELECT  FGCFR.centerID
        --                    FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
        --                                                      @iBrandID) FGCFR )
        --          GROUP BY  TCHND.I_Center_ID ,
        --                    TCHND.S_Center_Name
        --          UNION ALL
        --          SELECT    TCHND.I_Center_ID ,
        --                    TCHND.S_Center_Name ,
        --                    'MTF Collection' AS Category ,
        --                    -SUM(ISNULL(TRCD.N_Amount_Paid,0.0)) AS Value
        --          FROM      dbo.T_Receipt_Header TRH WITH ( NOLOCK )
        --                    INNER JOIN dbo.T_Receipt_Component_Detail TRCD
        --                    WITH ( NOLOCK ) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
        --                    INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
        --                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND
        --                    WITH ( NOLOCK ) ON TRH.I_Centre_Id = TCHND.I_Center_ID
        --                    INNER JOIN dbo.T_Fee_Component_Master TFCM WITH (NOLOCK) ON TICD.I_Fee_Component_ID=TFCM.I_Fee_Component_ID
        --          WHERE     TRH.I_Status = 0
        --                    AND TRH.I_Receipt_Type = 2
        --                    AND TFCM.I_Fee_Component_ID IN ( 50, 57, 58 )
        --                    AND ( TRH.Dt_Upd_On >= @dtStartDate
        --                          AND TRH.Dt_Upd_On < DATEADD(d, 1, @dtEndDate)
        --                        )
        --                    AND TRH.I_Centre_Id IN (
        --                    SELECT  FGCFR.centerID
        --                    FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
        --                                                      @iBrandID) FGCFR )
        --          GROUP BY  TCHND.I_Center_ID ,
        --                    TCHND.S_Center_Name
        --        ) AS T1
        --GROUP BY T1.I_Center_ID ,
        --        T1.S_Center_Name ,
        --        T1.Category
        --UNION ALL
        --SELECT  T1.I_Center_ID ,
        --        T1.S_Center_Name ,
        --        T1.Category ,
        --        SUM(T1.Value) AS Value
        --FROM    ( SELECT    TCHND.I_Center_ID ,
        --                    TCHND.S_Center_Name ,
        --                    'Total Collection' AS Category ,
        --                    SUM(ISNULL(TRCD.N_Amount_Paid,0.0)) AS Value
        --          FROM      dbo.T_Receipt_Header TRH WITH ( NOLOCK )
        --                    INNER JOIN dbo.T_Receipt_Component_Detail TRCD
        --                    WITH ( NOLOCK ) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
        --                    INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
        --                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND
        --                    WITH ( NOLOCK ) ON TRH.I_Centre_Id = TCHND.I_Center_ID
        --          WHERE     TRH.I_Status IN ( 0, 1 )
        --                    AND TRH.I_Receipt_Type = 2
        --                    AND ( TRH.Dt_Crtd_On >= @dtStartDate
        --                          AND TRH.Dt_Crtd_On < DATEADD(d, 1,
        --                                                      @dtEndDate)
        --                        )
        --                    AND TRH.I_Centre_Id IN (
        --                    SELECT  FGCFR.centerID
        --                    FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
        --                                                      @iBrandID) FGCFR )
        --          GROUP BY  TCHND.I_Center_ID ,
        --                    TCHND.S_Center_Name
        --          UNION ALL
        --          SELECT    TCHND.I_Center_ID ,
        --                    TCHND.S_Center_Name ,
        --                    'Total Collection' AS Category ,
        --                    -SUM(ISNULL(TRCD.N_Amount_Paid,0.0)) AS Value
        --          FROM      dbo.T_Receipt_Header TRH WITH ( NOLOCK )
        --                    INNER JOIN dbo.T_Receipt_Component_Detail TRCD
        --                    WITH ( NOLOCK ) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
        --                    INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
        --                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND
        --                    WITH ( NOLOCK ) ON TRH.I_Centre_Id = TCHND.I_Center_ID
        --          WHERE     TRH.I_Status = 0
        --                    AND TRH.I_Receipt_Type = 2
        --                    AND ( TRH.Dt_Upd_On >= @dtStartDate
        --                          AND TRH.Dt_Upd_On < DATEADD(d, 1, @dtEndDate)
        --                        )
        --                    AND TRH.I_Centre_Id IN (
        --                    SELECT  FGCFR.centerID
        --                    FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
        --                                                      @iBrandID) FGCFR )
        --          GROUP BY  TCHND.I_Center_ID ,
        --                    TCHND.S_Center_Name
        --        ) AS T1
        --GROUP BY T1.I_Center_ID ,
        --        T1.S_Center_Name ,
        --        T1.Category 
	
    END
