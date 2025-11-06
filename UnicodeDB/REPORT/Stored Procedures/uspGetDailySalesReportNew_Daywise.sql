CREATE PROCEDURE [REPORT].[uspGetDailySalesReportNew_Daywise]
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
              I_Center_ID INT ,
              S_Center_Name VARCHAR(MAX) ,
			  Dt_AdmissionDate DATETIME,
              MonthYear VARCHAR(MAX) ,
              I_Course_ID INT ,
              S_Course_Name VARCHAR(MAX) ,
              NValue DECIMAL(14, 2) ,
              I_FeeComponent_ID INT,
              I_Instalment_No INT
            )

        INSERT  INTO #temp
                ( I_Center_ID ,
                  S_Center_Name ,
				  Dt_AdmissionDate,
                  MonthYear ,
                  I_Course_ID ,
                  S_Course_Name ,
                  I_Instalment_No,
                  I_FeeComponent_ID ,
                  NValue
                )
                SELECT  TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
						CONVERT(DATE,TSD.Dt_Crtd_On) as AdmissionDate,
                        CONVERT(DATE,TRH.Dt_Crtd_On) AS MonthYear ,
                        TCM.I_Course_ID ,
                        TCM.S_Course_Name ,
                        TICD.I_Installment_No,
                        TICD.I_Fee_Component_ID ,
                        SUM(ISNULL(TRCD.N_Amount_Paid, 0.0)) AS VALUE
                FROM    dbo.T_Receipt_Header TRH WITH ( NOLOCK )
                        INNER JOIN dbo.T_Receipt_Component_Detail TRCD WITH ( NOLOCK ) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                        INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                        INNER JOIN dbo.T_Invoice_Child_Header TICH WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND
                        WITH ( NOLOCK ) ON TRH.I_Centre_Id = TCHND.I_Center_ID
                        --INNER JOIN dbo.T_Student_Course_Detail TSCD WITH ( NOLOCK ) ON TRH.I_Student_Detail_ID = TSCD.I_Student_Detail_ID
                        LEFT JOIN dbo.T_Course_Master TCM WITH ( NOLOCK ) ON TICH.I_Course_ID = TCM.I_Course_ID
						INNER JOIN T_Student_Detail TSD on TRH.I_Student_Detail_ID=TSD.I_Student_Detail_ID
                WHERE   TRH.I_Status IN ( 0, 1 )
                        AND TRH.I_Receipt_Type = 2
                        AND ( TRH.Dt_Crtd_On >= @dtStartDate
                              AND TRH.Dt_Crtd_On < DATEADD(d, 1, @dtEndDate)
                            )
                        AND TRH.I_Centre_Id IN (
                        SELECT  FGCFR.centerID
                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                           @iBrandID) FGCFR )
                GROUP BY TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
						CONVERT(DATE,TSD.Dt_Crtd_On),
                        CONVERT(DATE,TRH.Dt_Crtd_On) ,
                        TCM.I_Course_ID ,
                        TCM.S_Course_Name ,
                        TICD.I_Installment_No,
                        TICD.I_Fee_Component_ID
                UNION ALL
                SELECT  TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
						CONVERT(DATE,TSD.Dt_Crtd_On) as AdmissionDate,
                        CONVERT(DATE,TRH.Dt_Upd_On) AS MonthYear ,
                        TCM.I_Course_ID ,
                        TCM.S_Course_Name ,
                        TICD.I_Installment_No,
                        TICD.I_Fee_Component_ID ,
                        -SUM(ISNULL(TRCD.N_Amount_Paid, 0.0)) AS VALUE
                FROM    dbo.T_Receipt_Header TRH WITH ( NOLOCK )
                        INNER JOIN dbo.T_Receipt_Component_Detail TRCD WITH ( NOLOCK ) ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                        INNER JOIN dbo.T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                        INNER JOIN dbo.T_Invoice_Child_Header TICH WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND
                        WITH ( NOLOCK ) ON TRH.I_Centre_Id = TCHND.I_Center_ID
                        --INNER JOIN dbo.T_Student_Course_Detail TSCD WITH ( NOLOCK ) ON TRH.I_Student_Detail_ID = TSCD.I_Student_Detail_ID
                        LEFT JOIN dbo.T_Course_Master TCM WITH ( NOLOCK ) ON TICH.I_Course_ID = TCM.I_Course_ID
						INNER JOIN T_Student_Detail TSD on TRH.I_Student_Detail_ID=TSD.I_Student_Detail_ID
                WHERE   TRH.I_Status = 0
                        AND TRH.I_Receipt_Type = 2
                        AND ( TRH.Dt_Upd_On >= @dtStartDate
                              AND TRH.Dt_Upd_On < DATEADD(d, 1, @dtEndDate)
                            )
                        AND TRH.I_Centre_Id IN (
                        SELECT  FGCFR.centerID
                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                           @iBrandID) FGCFR )
                GROUP BY TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
						CONVERT(DATE,TSD.Dt_Crtd_On),
                        CONVERT(DATE,TRH.Dt_Upd_On) ,
                        TCM.I_Course_ID ,
                        TCM.S_Course_Name ,
                        TICD.I_Installment_No,
                        TICD.I_Fee_Component_ID
                            
                            --SELECT * FROM #temp T1
                            
                            
        SELECT  TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                CONVERT(DATE,TRH.Dt_Receipt_Date) AS MonthYear ,
                TCM.I_Course_ID ,
                TCM.S_Course_Name ,
                'Form/Prospectus(Old Reg)' AS Category ,
                COUNT(DISTINCT TRH.I_Receipt_Header_ID) AS Value
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TRH.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
                INNER JOIN dbo.T_Information_Source_Master TISM ON TERD.I_Info_Source_ID = TISM.I_Info_Source_ID 
                INNER JOIN dbo.T_Enquiry_Course TEC ON TERD.I_Enquiry_Regn_ID = TEC.I_Enquiry_Regn_ID
                INNER JOIN dbo.T_Course_Master TCM ON TEC.I_Course_ID = TCM.I_Course_ID
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
                TCHND.S_Center_Name ,
                CONVERT(DATE,TRH.Dt_Receipt_Date) ,
                TCM.I_Course_ID ,
                TCM.S_Course_Name
        UNION ALL
        SELECT  TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                CONVERT(DATE,TRH.Dt_Receipt_Date) AS MonthYear ,
                TCM.I_Course_ID ,
                TCM.S_Course_Name ,
                'Form/Prospectus(New)' AS Category ,
                COUNT(DISTINCT TRH.I_Receipt_Header_ID) AS Value
        FROM    dbo.T_Receipt_Header TRH
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TRH.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
                INNER JOIN dbo.T_Information_Source_Master TISM ON TERD.I_Info_Source_ID = TISM.I_Info_Source_ID 
                INNER JOIN dbo.T_Enquiry_Course TEC ON TERD.I_Enquiry_Regn_ID = TEC.I_Enquiry_Regn_ID
                INNER JOIN dbo.T_Course_Master TCM ON TEC.I_Course_ID = TCM.I_Course_ID
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
                TCHND.S_Center_Name ,
                CONVERT(DATE,TRH.Dt_Receipt_Date) ,
                TCM.I_Course_ID ,
                TCM.S_Course_Name
        UNION ALL
        SELECT  TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                CONVERT(DATE,TERD.Dt_Crtd_On) AS MonthYear ,
                TCM.I_Course_ID ,
                TCM.S_Course_Name ,
                'PreEnquiry/Enquiry(Old Reg)' AS Category ,
                COUNT(DISTINCT TERD.I_Enquiry_Regn_ID) AS Value
        FROM    dbo.T_Enquiry_Regn_Detail TERD
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TERD.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_Information_Source_Master TISM ON TERD.I_Info_Source_ID = TISM.I_Info_Source_ID 
                INNER JOIN dbo.T_Enquiry_Course TEC ON TERD.I_Enquiry_Regn_ID = TEC.I_Enquiry_Regn_ID
                INNER JOIN dbo.T_Course_Master TCM ON TEC.I_Course_ID = TCM.I_Course_ID
        WHERE   TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND TERD.Dt_Crtd_On >= @dtStartDate
                AND TERD.Dt_Crtd_On < DATEADD(d, 1, @dtEndDate)
                AND TISM.I_Info_Source_ID = 3
        GROUP BY TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                CONVERT(DATE,TERD.Dt_Crtd_On) ,
                TCM.I_Course_ID ,
                TCM.S_Course_Name
        UNION ALL
        SELECT  TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                CONVERT(DATE,TERD.Dt_Crtd_On) AS MonthYear ,
                TCM.I_Course_ID ,
                TCM.S_Course_Name ,
                'PreEnquiry/Enquiry(New)' AS Category ,
                COUNT(DISTINCT TERD.I_Enquiry_Regn_ID) AS Value
        FROM    dbo.T_Enquiry_Regn_Detail TERD
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TERD.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_Information_Source_Master TISM ON TERD.I_Info_Source_ID = TISM.I_Info_Source_ID 
                INNER JOIN dbo.T_Enquiry_Course TEC ON TERD.I_Enquiry_Regn_ID = TEC.I_Enquiry_Regn_ID
                INNER JOIN dbo.T_Course_Master TCM ON TEC.I_Course_ID = TCM.I_Course_ID
        WHERE   TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND TERD.Dt_Crtd_On >= @dtStartDate
                AND TERD.Dt_Crtd_On < DATEADD(d, 1, @dtEndDate)
                AND TISM.I_Info_Source_ID != 3
        GROUP BY TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                CONVERT(DATE,TERD.Dt_Crtd_On) ,
                TCM.I_Course_ID ,
                TCM.S_Course_Name
        UNION ALL
        SELECT  TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                CONVERT(DATE,TSD.Dt_Crtd_On) AS MonthYear ,
                TCM2.I_Course_ID ,
                TCM2.S_Course_Name ,
                'Registration (Old)' AS Category ,
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
        WHERE   TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND TSD.Dt_Crtd_On >= @dtStartDate
                AND TSD.Dt_Crtd_On < DATEADD(d, 1, @dtEndDate)
                AND TERD.I_Enquiry_Status_Code = 3
                AND TISM.I_Info_Source_ID = 3
        GROUP BY TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                CONVERT(DATE,TSD.Dt_Crtd_On) ,
                TCM2.I_Course_ID ,
                TCM2.S_Course_Name
        UNION ALL
        SELECT  TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                CONVERT(DATE,TSD.Dt_Crtd_On) AS MonthYear ,
                TCM2.I_Course_ID ,
                TCM2.S_Course_Name ,
                'Registration (New)' AS Category ,
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
        WHERE   TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
                AND TSD.Dt_Crtd_On >= @dtStartDate
                AND TSD.Dt_Crtd_On < DATEADD(d, 1, @dtEndDate)
                AND TERD.I_Enquiry_Status_Code = 3
                AND TISM.I_Info_Source_ID != 3
        GROUP BY TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                CONVERT(DATE,TSD.Dt_Crtd_On) ,
                TCM2.I_Course_ID ,
                TCM2.S_Course_Name
        UNION ALL
        SELECT  TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                CONVERT(DATE,TIP.Dt_Crtd_On) AS MonthYear ,
                TCM.I_Course_ID ,
                TCM.S_Course_Name ,
                'Promotion/Conversion' AS Category ,
        --TSD.S_Student_ID
                COUNT(DISTINCT TIP.I_Invoice_Header_ID) AS Value
        FROM    dbo.T_Invoice_Parent TIP
                INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                INNER JOIN dbo.T_Invoice_Batch_Map TIBM ON TICH.I_Invoice_Child_Header_ID = TIBM.I_Invoice_Child_Header_ID
                INNER JOIN dbo.T_Student_Batch_Master TSBM ON TIBM.I_Batch_ID = TSBM.I_Batch_ID
                INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TIP.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
        WHERE   TCHND.I_Center_ID IN (19,18 )
                AND TIP.I_Parent_Invoice_ID IS NULL
                AND ( TIP.Dt_Crtd_On >= @dtStartDate
                      AND TIP.Dt_Crtd_On < DATEADD(d, 1, @dtEndDate)
                    )
                AND CONVERT(DATE, TIP.Dt_Crtd_On) != CONVERT(DATE, TSD.Dt_Crtd_On)
                AND TCM.I_Course_ID IN (519,520,11,12)
                --AND TCHND.I_Center_ID IN (19,18)
        GROUP BY TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                CONVERT(DATE,TIP.Dt_Crtd_On) ,
                TCM.I_Course_ID ,
                TCM.S_Course_Name
        UNION ALL
        SELECT  T1.I_Center_ID ,
                T1.S_Center_Name ,
                T1.MonthYear ,
                T1.I_Course_ID ,
                T1.S_Course_Name ,
                'Fresh Collection' AS Category ,
                SUM(T1.NValue) AS Value
        FROM    #temp T1
        INNER JOIN dbo.T_Fee_Component_Master AS TFCM ON TFCM.I_Fee_Component_ID=T1.I_FeeComponent_ID
        WHERE TFCM.S_Type_Of_Component='A' and T1.Dt_AdmissionDate=T1.MonthYear
        --T1.I_FeeComponent_ID NOT IN ( 50, 57, 58,49 )
        GROUP BY T1.I_Center_ID ,
                T1.S_Center_Name ,
                T1.MonthYear ,
                T1.I_Course_ID ,
                T1.S_Course_Name
		UNION ALL
		SELECT  T1.I_Center_ID ,
                T1.S_Center_Name ,
                T1.MonthYear ,
                T1.I_Course_ID ,
                T1.S_Course_Name ,
                'PartPayment Adm Collection' AS Category ,
                SUM(T1.NValue) AS Value
        FROM    #temp T1
        INNER JOIN dbo.T_Fee_Component_Master AS TFCM ON TFCM.I_Fee_Component_ID=T1.I_FeeComponent_ID
        WHERE TFCM.S_Type_Of_Component='A' and T1.Dt_AdmissionDate!=T1.MonthYear
        --T1.I_FeeComponent_ID NOT IN ( 50, 57, 58,49 )
        GROUP BY T1.I_Center_ID ,
                T1.S_Center_Name ,
                T1.MonthYear ,
                T1.I_Course_ID ,
                T1.S_Course_Name
        UNION ALL
        SELECT  T1.I_Center_ID ,
                T1.S_Center_Name ,
                T1.MonthYear ,
                T1.I_Course_ID ,
                T1.S_Course_Name ,
                'MTF Collection' AS Category ,
                SUM(T1.NValue) AS Value
        FROM    #temp T1
        INNER JOIN dbo.T_Fee_Component_Master AS TFCM ON TFCM.I_Fee_Component_ID=T1.I_FeeComponent_ID
        WHERE TFCM.S_Type_Of_Component='M'
        --WHERE   T1.I_FeeComponent_ID IN ( 50, 57, 58,49 )
        GROUP BY T1.I_Center_ID ,
                T1.S_Center_Name ,
                T1.MonthYear ,
                T1.I_Course_ID ,
                T1.S_Course_Name
        UNION ALL
        SELECT  T1.I_Center_ID ,
                T1.S_Center_Name ,
                T1.MonthYear ,
                T1.I_Course_ID ,
                T1.S_Course_Name ,
                'Total Collection' AS Category ,
                SUM(T1.NValue) AS Value
        FROM    #temp T1
        GROUP BY T1.I_Center_ID ,
                T1.S_Center_Name ,
                T1.MonthYear ,
                T1.I_Course_ID ,
                T1.S_Course_Name
        UNION ALL
        SELECT  T1.I_Center_ID ,
                T1.S_Center_Name ,
                T1.MonthYear ,
                T1.I_Course_ID ,
                T1.S_Course_Name ,
                'Conversion Collection' AS Category ,
                SUM(T1.NValue) AS Value
        FROM    #temp T1
        INNER JOIN dbo.T_Fee_Component_Master AS TFCM ON TFCM.I_Fee_Component_ID=T1.I_FeeComponent_ID
        WHERE TFCM.S_Type_Of_Component='M'
        AND T1.I_Instalment_No=1 AND T1.I_Course_ID IN (519,520,11,12) AND T1.I_Center_ID IN (19,18)
        --WHERE   T1.I_FeeComponent_ID IN ( 50, 57, 58,49 )
        GROUP BY T1.I_Center_ID ,
                T1.S_Center_Name ,
                T1.MonthYear ,
                T1.I_Course_ID ,
                T1.S_Course_Name         
	
    END
