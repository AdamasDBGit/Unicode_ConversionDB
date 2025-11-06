CREATE PROCEDURE [REPORT].[uspGetStudentCurrentStatusReport]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @dtDate DATETIME ,
      @sBatchIDList VARCHAR(MAX) = NULL ,
      @iCategoryID INT = NULL
    )
AS 
    BEGIN
    
        --CREATE TABLE #temp
        --    (
        --      I_Student_Detail_ID INT ,
        --      S_Mobile_No VARCHAR(50) ,
        --      S_Student_ID VARCHAR(100) ,
        --      I_Roll_No INT ,
        --      S_Student_Name VARCHAR(200) ,
        --      S_Invoice_No VARCHAR(100) ,
        --      S_Receipt_No VARCHAR(100) ,
        --      Dt_Invoice_Date DATETIME ,
        --      S_Component_Name VARCHAR(100) ,
        --      S_Batch_Name VARCHAR(100) ,
        --      S_Course_Name VARCHAR(100) ,
        --      I_Center_ID INT ,
        --      S_Center_Name VARCHAR(100) ,
        --      S_Brand_Name VARCHAR(100) ,
        --      S_Cost_Center VARCHAR(100) ,
        --      Due_Value REAL ,
        --      Dt_Installment_Date DATETIME ,
        --      I_Installment_No INT ,
        --      I_Parent_Invoice_ID INT ,
        --      I_Invoice_Detail_ID INT ,
        --      Revised_Invoice_Date DATETIME ,
        --      Tax_Value DECIMAL(14, 2) ,
        --      Total_Value DECIMAL(14, 2) ,
        --      Amount_Paid DECIMAL(14, 2) ,
        --      Tax_Paid DECIMAL(14, 2) ,
        --      Total_Paid DECIMAL(14, 2) ,
        --      Total_Due DECIMAL(14, 2) ,
        --      sInstance VARCHAR(MAX)
        --    )

        --INSERT  INTO #temp
        --        EXEC REPORT.uspGetDueReport_History @sHierarchyList = @sHierarchyListID, -- varchar(max)
        --            @iBrandID = @iBrandID, -- int
        --            @dtUptoDate = @dtDate, -- datetime
        --            @sStatus = 'ALL' -- varchar(100)
                    
                    
        CREATE TABLE #temp1
            (
              StudentDetailID INT ,
              StudentID VARCHAR(MAX) ,
              StudentName VARCHAR(MAX) ,
              BatchName VARCHAR(MAX) ,
              CenterID INT ,
              CenterName VARCHAR(MAX) ,
              BrandName VARCHAR(MAX) ,
              ContactNo VARCHAR(20) ,
              CourseName VARCHAR(MAX) ,
              CategoryID INT ,
              CategoryName VARCHAR(MAX) ,
              CurrenStatus INT ,
              TotalDue DECIMAL(14, 2)
            )
            
        IF ( @sBatchIDList IS NULL ) 
            BEGIN    
                    
                INSERT  INTO #temp1
                        ( StudentDetailID ,
                          StudentID ,
                          StudentName ,
                          BatchName ,
                          CenterID ,
                          CenterName ,
                          BrandName ,
                          ContactNo ,
                          CourseName ,
                          CategoryID ,
                          CategoryName ,
                          CurrenStatus,
                          TotalDue
                            
                        )
                        SELECT  TSD.I_Student_Detail_ID ,
                                TSD.S_Student_ID ,
                                TSD.S_First_Name + ' '
                                + ISNULL(TSD.S_Middle_Name, '') + ' '
                                + TSD.S_Last_Name AS StudentName ,
                                TSBM.S_Batch_Name ,
                                TCHND.I_Center_ID ,
                                TCHND.S_Center_Name ,
                                TCHND.S_Brand_Name ,
                                TSD.S_Mobile_No ,
                                TCM.S_Course_Name ,
                                TSSM.I_Student_Status_ID AS CategoryID ,
                                TSSM.S_Student_Status AS CategoryName ,
                                CASE WHEN TSSM.I_Student_Status_ID IS NULL THEN 0
                                WHEN TSSM.I_Student_Status_ID IS NOT NULL THEN 1 END AS CurrentStatus,
                                TSSD.N_Due
                --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, NULL) AS Dropout
                        FROM    dbo.T_Student_Detail TSD
                                INNER JOIN ( SELECT T1.I_Student_ID ,
                                                    T2.I_Batch_ID
                                             FROM   ( SELECT  TSBD2.I_Student_ID ,
                                                              MAX(TSBD2.I_Student_Batch_ID) AS ID
                                                      FROM    dbo.T_Student_Batch_Details TSBD2
                                                      WHERE   TSBD2.I_Status IN (
                                                              1, 3 )
                                                      GROUP BY TSBD2.I_Student_ID
                                                    ) T1
                                                    INNER JOIN ( SELECT
                                                              TSBD3.I_Student_ID ,
                                                              TSBD3.I_Student_Batch_ID AS ID ,
                                                              TSBD3.I_Batch_ID
                                                              FROM
                                                              dbo.T_Student_Batch_Details TSBD3
                                                              WHERE
                                                              TSBD3.I_Status IN (
                                                              1, 3 )
                                                              ) T2 ON T1.I_Student_ID = T2.I_Student_ID
                                                              AND T1.ID = T2.ID
                                           ) TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                                INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                                INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                                INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
                                INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                                LEFT JOIN dbo.T_Student_Status_Details_Archive TSSD ON TSD.I_Student_Detail_ID=TSSD.I_Student_Detail_ID AND TSSD.I_Status=1 AND CONVERT(DATE,TSSD.Dt_Crtd_On)=CONVERT(DATE,@dtDate)
                                LEFT JOIN dbo.T_Student_Status_Master TSSM ON TSSD.I_Student_Status_ID = TSSM.I_Student_Status_ID
                        WHERE   TCHND.I_Center_ID IN (
                                SELECT  FGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR )
                                --AND TSD.I_Status = 0
                       
           --             UNION ALL
           --             SELECT  TSD.I_Student_Detail_ID ,
           --                     TSD.S_Student_ID ,
           --                     TSD.S_First_Name + ' '
           --                     + ISNULL(TSD.S_Middle_Name, '') + ' '
           --                     + TSD.S_Last_Name AS StudentName ,
           --                     TSBM.S_Batch_Name ,
           --                     TCHND.I_Center_ID ,
           --                     TCHND.S_Center_Name ,
           --                     TCHND.S_Brand_Name ,
           --                     TSD.S_Mobile_No ,
           --                     TCM.S_Course_Name ,
           --                     2 AS CategoryID ,
           --                     'DropOut' AS CategoryName ,
           --                     dbo.fnGetAcademicDropOutStatus(NULL,TSD.I_Student_Detail_ID,
           --                                                   @dtDate) AS CurrentStatus
           --     --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, NULL) AS Dropout
           --             FROM    dbo.T_Student_Detail TSD
           --                     INNER JOIN ( SELECT T1.I_Student_ID ,
           --                                         T2.I_Batch_ID
           --                                  FROM   ( SELECT  TSBD2.I_Student_ID ,
           --                                                   MAX(TSBD2.I_Student_Batch_ID) AS ID
           --                                           FROM    dbo.T_Student_Batch_Details TSBD2
           --                                           WHERE   TSBD2.I_Status IN (
           --                                                   1, 3 )
           --                                           GROUP BY TSBD2.I_Student_ID
           --                                         ) T1
           --                                         INNER JOIN ( SELECT
           --                                                   TSBD3.I_Student_ID ,
           --                                                   TSBD3.I_Student_Batch_ID AS ID ,
           --                                                   TSBD3.I_Batch_ID
           --                                                   FROM
           --                                                   dbo.T_Student_Batch_Details TSBD3
           --                                                   WHERE
           --                                                   TSBD3.I_Status IN (
           --                                                   1, 3 )
           --                                                   ) T2 ON T1.I_Student_ID = T2.I_Student_ID
           --                                                   AND T1.ID = T2.ID
           --                                ) TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
           --                     INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
           --                     INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
           --                     INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
           --                     INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
           --                     INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
           --             WHERE   TCHND.I_Center_ID IN (
           --                     SELECT  FGCFR.centerID
           --                     FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
           --                                                   @iBrandID) FGCFR )
           --                     AND TSD.I_Status = 1
           --             --AND TSBD.I_Batch_ID IN (
           --             --SELECT  CAST(FSR.Val AS INT)
           --             --FROM    dbo.fnString2Rows(@sBatchIDList, ',') FSR )
           --             UNION ALL
           --             SELECT  T1.I_Student_Detail_ID ,
           --                     T1.S_Student_ID ,
           --                     T1.StudentName ,
           --                     T1.S_Batch_Name ,
           --                     T1.I_Center_ID ,
           --                     T1.S_Center_Name ,
           --                     T1.S_Brand_Name ,
           --                     T1.S_Mobile_No ,
           --                     T1.S_Course_Name ,
           --                     T1.CategoryID ,
           --                     T1.CategoryName ,
           --                     CASE WHEN T2.IsOnLeave IS NULL THEN 0
           --                          WHEN T2.IsOnLeave = 1 THEN 1
           --                     END AS CurrentStatus
           --             FROM    ( SELECT    TSD.I_Student_Detail_ID ,
           --                                 TSD.S_Student_ID ,
           --                                 TSD.S_First_Name + ' '
           --                                 + ISNULL(TSD.S_Middle_Name, '')
           --                                 + ' ' + TSD.S_Last_Name AS StudentName ,
           --                                 TSBM.S_Batch_Name ,
           --                                 TCHND.I_Center_ID ,
           --                                 TCHND.S_Center_Name ,
           --                                 TCHND.S_Brand_Name ,
           --                                 TSD.S_Mobile_No ,
           --                                 TCM.S_Course_Name ,
           --                                 3 AS CategoryID ,
           --                                 'IsOnleave' AS CategoryName
           --     --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, @dtDate) AS CurrentStatus 
           --     --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, NULL) AS Dropout
           --                       FROM      dbo.T_Student_Detail TSD
           --                                 INNER JOIN ( SELECT
           --                                                   T1.I_Student_ID ,
           --                                                   T2.I_Batch_ID
           --                                              FROM ( SELECT
           --                                                   TSBD2.I_Student_ID ,
           --                                                   MAX(TSBD2.I_Student_Batch_ID) AS ID
           --                                                   FROM
           --                                                   dbo.T_Student_Batch_Details TSBD2
           --                                                   WHERE
           --                                                   TSBD2.I_Status IN (
           --                                                   1, 3 )
           --                                                   GROUP BY TSBD2.I_Student_ID
           --                                                   ) T1
           --                                                   INNER JOIN ( SELECT
           --                                                   TSBD3.I_Student_ID ,
           --                                                   TSBD3.I_Student_Batch_ID AS ID ,
           --                                                   TSBD3.I_Batch_ID
           --                                                   FROM
           --                                                   dbo.T_Student_Batch_Details TSBD3
           --                                                   WHERE
           --                                                   TSBD3.I_Status IN (
           --                                                   1, 3 )
           --                                                   ) T2 ON T1.I_Student_ID = T2.I_Student_ID
           --                                                   AND T1.ID = T2.ID
           --                                            ) TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
           --                                 INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
           --                                 INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
           --                                 INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
           --                                 INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
           --                                 INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
           --                       WHERE     TCHND.I_Center_ID IN (
           --                                 SELECT  FGCFR.centerID
           --                                 FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
           --                                                   @iBrandID) FGCFR )
           --                                 AND TSD.I_Status = 1
           --                         --AND TSBD.I_Batch_ID IN (
           --                         --SELECT  CAST(FSR.Val AS INT)
           --                         --FROM    dbo.fnString2Rows(@sBatchIDList,
           --                         --                          ',') FSR )
                                  
           --                     ) T1
           --                     LEFT JOIN ( SELECT  TSLR.I_Student_Detail_ID ,
           --                                         1 AS IsOnLeave
           --                                 FROM    dbo.T_Student_Leave_Request TSLR
           --                                 WHERE   TSLR.I_Status = 1
           --                                         AND @dtDate BETWEEN TSLR.Dt_From_Date
           --                                                   AND
           --                                                   TSLR.Dt_To_Date
           --                               ) T2 ON T1.I_Student_Detail_ID = T2.I_Student_Detail_ID
           --             UNION ALL
           --             SELECT  T1.I_Student_Detail_ID ,
           --                     T1.S_Student_ID ,
           --                     T1.StudentName ,
           --                     T1.S_Batch_Name ,
           --                     T1.I_Center_ID ,
           --                     T1.S_Center_Name ,
           --                     T1.S_Brand_Name ,
           --                     T1.S_Mobile_No ,
           --                     T1.S_Course_Name ,
           --                     T1.CategoryID ,
           --                     T1.CategoryName ,
           --                     CASE WHEN T2.Defaulter IS NULL THEN 0
           --                          WHEN T2.Defaulter = 1 THEN 1
           --                     END AS CurrentStatus
           --             FROM    ( SELECT    TSD.I_Student_Detail_ID ,
           --                                 TSD.S_Student_ID ,
           --                                 TSD.S_First_Name + ' '
           --                                 + ISNULL(TSD.S_Middle_Name, '')
           --                                 + ' ' + TSD.S_Last_Name AS StudentName ,
           --                                 TSBM.S_Batch_Name ,
           --                                 TCHND.I_Center_ID ,
           --                                 TCHND.S_Center_Name ,
           --                                 TCHND.S_Brand_Name ,
           --                                 TSD.S_Mobile_No ,
           --                                 TCM.S_Course_Name ,
           --                                 4 AS CategoryID ,
           --                                 'Defaulter' AS CategoryName
                            
           --     --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, @dtDate) AS CurrentStatus 
           --     --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, NULL) AS Dropout
           --                       FROM      dbo.T_Student_Detail TSD
           --                                 INNER JOIN ( SELECT
           --                                                   T1.I_Student_ID ,
           --                                                   T2.I_Batch_ID
           --                                              FROM ( SELECT
           --                                                   TSBD2.I_Student_ID ,
           --                                                   MAX(TSBD2.I_Student_Batch_ID) AS ID
           --                                                   FROM
           --                                                   dbo.T_Student_Batch_Details TSBD2
           --                                                   WHERE
           --                                                   TSBD2.I_Status IN (
           --                                                   1, 3 )
           --                                                   GROUP BY TSBD2.I_Student_ID
           --                                                   ) T1
           --                                                   INNER JOIN ( SELECT
           --                                                   TSBD3.I_Student_ID ,
           --                                                   TSBD3.I_Student_Batch_ID AS ID ,
           --                                                   TSBD3.I_Batch_ID
           --                                                   FROM
           --                                                   dbo.T_Student_Batch_Details TSBD3
           --                                                   WHERE
           --                                                   TSBD3.I_Status IN (
           --                                                   1, 3 )
           --                                                   ) T2 ON T1.I_Student_ID = T2.I_Student_ID
           --                                                   AND T1.ID = T2.ID
           --                                            ) TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
           --                                 INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
           --                                 INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
           --                                 INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
           --                                 INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
           --                                 INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
           --                       WHERE     TCHND.I_Center_ID IN (
           --                                 SELECT  FGCFR.centerID
           --                                 FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
           --                                                   @iBrandID) FGCFR )
           --                                 AND TSD.I_Status = 1
           --                         --AND TSBD.I_Batch_ID IN (
           --                         --SELECT  CAST(FSR.Val AS INT)
           --                         --FROM    dbo.fnString2Rows(@sBatchIDList,
           --                         --                          ',') FSR )
                                  
           --                     ) T1
           --                     LEFT JOIN ( SELECT  DISTINCT
           --                                         XX.S_Student_ID ,
           --                                         1 AS Defaulter
           --                                 FROM    ( SELECT  S_Student_ID ,
           --                                                   SUM(ISNULL(Total_Due,
           --                                                   0)) AS TotalDue
           --                                           FROM    #temp TTT
           --                                           WHERE   DATEDIFF(d,
           --                                                   TTT.Dt_Installment_Date,
           --                                                   @dtDate) >= 10
           --                                             --AND T1.S_Student_ID=@Sstudentid      
           --                                           GROUP BY S_Student_ID
           --                                         ) XX
           --                                 WHERE   XX.TotalDue >= 100
           --                               ) T2 ON T1.S_Student_ID = T2.S_Student_ID
                                          
                                          
           --                               UNION ALL
           --             SELECT  T1.I_Student_Detail_ID ,
           --                     T1.S_Student_ID ,
           --                     T1.StudentName ,
           --                     T1.S_Batch_Name ,
           --                     T1.I_Center_ID ,
           --                     T1.S_Center_Name ,
           --                     T1.S_Brand_Name ,
           --                     T1.S_Mobile_No ,
           --                     T1.S_Course_Name ,
           --                     T1.CategoryID ,
           --                     T1.CategoryName ,
           --                     CASE WHEN T2.Completed IS NULL THEN 0
           --                          WHEN T2.Completed = 1 THEN 1
           --                     END AS CurrentStatus
           --             FROM    ( SELECT    TSD.I_Student_Detail_ID ,
           --                                 TSD.S_Student_ID ,
           --                                 TSD.S_First_Name + ' '
           --                                 + ISNULL(TSD.S_Middle_Name, '')
           --                                 + ' ' + TSD.S_Last_Name AS StudentName ,
           --                                 TSBM.S_Batch_Name ,
           --                                 TCHND.I_Center_ID ,
           --                                 TCHND.S_Center_Name ,
           --                                 TCHND.S_Brand_Name ,
           --                                 TSD.S_Mobile_No ,
           --                                 TCM.S_Course_Name ,
           --                                 6 AS CategoryID ,
           --                                 'Completed' AS CategoryName
           --     --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, @dtDate) AS CurrentStatus 
           --     --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, NULL) AS Dropout
           --                       FROM      dbo.T_Student_Detail TSD
           --                                 INNER JOIN ( SELECT
           --                                                   T1.I_Student_ID ,
           --                                                   T2.I_Batch_ID
           --                                              FROM ( SELECT
           --                                                   TSBD2.I_Student_ID ,
           --                                                   MAX(TSBD2.I_Student_Batch_ID) AS ID
           --                                                   FROM
           --                                                   dbo.T_Student_Batch_Details TSBD2
           --                                                   WHERE
           --                                                   TSBD2.I_Status IN (
           --                                                   1, 3 )
           --                                                   GROUP BY TSBD2.I_Student_ID
           --                                                   ) T1
           --                                                   INNER JOIN ( SELECT
           --                                                   TSBD3.I_Student_ID ,
           --                                                   TSBD3.I_Student_Batch_ID AS ID ,
           --                                                   TSBD3.I_Batch_ID
           --                                                   FROM
           --                                                   dbo.T_Student_Batch_Details TSBD3
           --                                                   WHERE
           --                                                   TSBD3.I_Status IN (
           --                                                   1, 3 )
           --                                                   ) T2 ON T1.I_Student_ID = T2.I_Student_ID
           --                                                   AND T1.ID = T2.ID
           --                                            ) TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
           --                                 INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
           --                                 INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
           --                                 INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
           --                                 INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
           --                                 INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
           --                       WHERE     TCHND.I_Center_ID IN (
           --                                 SELECT  FGCFR.centerID
           --                                 FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
           --                                                   @iBrandID) FGCFR )
           --                                 AND TSD.I_Status = 1
           --                         --AND TSBD.I_Batch_ID IN (
           --                         --SELECT  CAST(FSR.Val AS INT)
           --                         --FROM    dbo.fnString2Rows(@sBatchIDList,
           --                         --                          ',') FSR )
                                  
           --                     ) T1
           --                     LEFT JOIN ( SELECT TSSD.I_Student_Detail_ID,1 AS Completed FROM dbo.T_Student_Status_Details TSSD
											--WHERE
											--TSSD.I_Student_Status_ID=2 AND TSSD.I_Status=1
											--AND CONVERT(DATE,TSSD.Dt_Crtd_On)<=CONVERT(DATE,@dtdate)
           --                               ) T2 ON T1.I_Student_Detail_ID = T2.I_Student_Detail_ID
                          
                          
           --     DELETE  FROM #temp1
           --     WHERE   CurrenStatus = 0
                         
                          
                         
           --     INSERT  INTO #temp1
           --             ( StudentDetailID ,
           --               StudentID ,
           --               StudentName ,
           --               BatchName ,
           --               CenterID ,
           --               CenterName ,
           --               BrandName ,
           --               ContactNo ,
           --               CourseName ,
           --               CategoryID ,
           --               CategoryName ,
           --               CurrenStatus
                            
           --             )
           --             SELECT  TSD.I_Student_Detail_ID ,
           --                     TSD.S_Student_ID ,
           --                     TSD.S_First_Name + ' '
           --                     + ISNULL(TSD.S_Middle_Name, '') + ' '
           --                     + TSD.S_Last_Name AS StudentName ,
           --                     TSBM.S_Batch_Name ,
           --                     TCHND.I_Center_ID ,
           --                     TCHND.S_Center_Name ,
           --                     TCHND.S_Brand_Name ,
           --                     TSD.S_Mobile_No ,
           --                     TCM.S_Course_Name ,
           --                     5 AS CategoryID ,
           --                     'Active' AS CategoryName ,
           --                     1 AS CurrentStatus
           --     --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, NULL) AS Dropout
           --             FROM    dbo.T_Student_Detail TSD
           --                     INNER JOIN ( SELECT T1.I_Student_ID ,
           --                                         T2.I_Batch_ID
           --                                  FROM   ( SELECT  TSBD2.I_Student_ID ,
           --                                                   MAX(TSBD2.I_Student_Batch_ID) AS ID
           --                                           FROM    dbo.T_Student_Batch_Details TSBD2
           --                                           WHERE   TSBD2.I_Status IN (
           --                                                   1, 3 )
           --                                           GROUP BY TSBD2.I_Student_ID
           --                                         ) T1
           --                                         INNER JOIN ( SELECT
           --                                                   TSBD3.I_Student_ID ,
           --                                                   TSBD3.I_Student_Batch_ID AS ID ,
           --                                                   TSBD3.I_Batch_ID
           --                                                   FROM
           --                                                   dbo.T_Student_Batch_Details TSBD3
           --                                                   WHERE
           --                                                   TSBD3.I_Status IN (
           --                                                   1, 3 )
           --                                                   ) T2 ON T1.I_Student_ID = T2.I_Student_ID
           --                                                   AND T1.ID = T2.ID
           --                                ) TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
           --                     INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
           --                     INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
           --                     INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
           --                     INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
           --                     INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
           --             WHERE   TCHND.I_Center_ID IN (
           --                     SELECT  FGCFR.centerID
           --                     FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
           --                                                   @iBrandID) FGCFR )
           --                     AND TSD.I_Status = 1
           --             --AND TSBD.I_Batch_ID IN (
           --             --SELECT  CAST(FSR.Val AS INT)
           --             --FROM    dbo.fnString2Rows(@sBatchIDList, ',') FSR )
           --                     AND TSD.I_Student_Detail_ID NOT IN ( SELECT
           --                                                   StudentDetailID
           --                                                   FROM
           --                                                   #temp1 )
                
                
           --     UPDATE  T1
           --     SET     T1.TotalDue = T2.TotalDue
           --     FROM    #temp1 T1
           --             INNER JOIN ( SELECT XX.S_Student_ID ,
           --                                 XX.TotalDue
           --                          FROM   ( SELECT    S_Student_ID ,
           --                                             SUM(ISNULL(Total_Due,
           --                                                   0)) AS TotalDue
           --                                   FROM      #temp TTT
           --                                   WHERE     DATEDIFF(d,
           --                                                   TTT.Dt_Installment_Date,
           --                                                   @dtDate) >= 10
           --                                             --AND T1.S_Student_ID=@Sstudentid      
           --                                   GROUP BY  S_Student_ID
           --                                 ) XX
           --                          WHERE  XX.TotalDue > 100
           --                        ) T2 ON T1.StudentID = T2.S_Student_ID
           --                                AND T1.CategoryID = 4
                           
                           
                IF ( @iCategoryID = 0 OR @iCategoryID IS NULL ) 
                    BEGIN
                        SELECT  *
                        FROM    #temp1 WHERE CategoryName IS NOT NULL
                    END
                ELSE 
                    BEGIN
                        SELECT  *
                        FROM    #temp1
                        WHERE   CategoryID = @iCategoryID AND CategoryName IS NOT NULL
                    END
                           
                           
            END
                           
        ELSE 
            BEGIN
                INSERT  INTO #temp1
                        ( StudentDetailID ,
                          StudentID ,
                          StudentName ,
                          BatchName ,
                          CenterID ,
                          CenterName ,
                          BrandName ,
                          ContactNo ,
                          CourseName ,
                          CategoryID ,
                          CategoryName ,
                          CurrenStatus,
                          TotalDue
                            
                        )
                        SELECT  TSD.I_Student_Detail_ID ,
                                TSD.S_Student_ID ,
                                TSD.S_First_Name + ' '
                                + ISNULL(TSD.S_Middle_Name, '') + ' '
                                + TSD.S_Last_Name AS StudentName ,
                                TSBM.S_Batch_Name ,
                                TCHND.I_Center_ID ,
                                TCHND.S_Center_Name ,
                                TCHND.S_Brand_Name ,
                                TSD.S_Mobile_No ,
                                TCM.S_Course_Name ,
                                TSSM.I_Student_Status_ID AS CategoryID ,
                                TSSM.S_Student_Status AS CategoryName ,
                                CASE WHEN TSSM.I_Student_Status_ID IS NULL THEN 0
                                WHEN TSSM.I_Student_Status_ID IS NOT NULL THEN 1 END AS CurrentStatus,
                                TSSD.N_Due
                --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, NULL) AS Dropout
                        FROM    dbo.T_Student_Detail TSD
                                INNER JOIN ( SELECT T1.I_Student_ID ,
                                                    T2.I_Batch_ID
                                             FROM   ( SELECT  TSBD2.I_Student_ID ,
                                                              MAX(TSBD2.I_Student_Batch_ID) AS ID
                                                      FROM    dbo.T_Student_Batch_Details TSBD2
                                                      WHERE   TSBD2.I_Status IN (
                                                              1, 3 )
                                                      GROUP BY TSBD2.I_Student_ID
                                                    ) T1
                                                    INNER JOIN ( SELECT
                                                              TSBD3.I_Student_ID ,
                                                              TSBD3.I_Student_Batch_ID AS ID ,
                                                              TSBD3.I_Batch_ID
                                                              FROM
                                                              dbo.T_Student_Batch_Details TSBD3
                                                              WHERE
                                                              TSBD3.I_Status IN (
                                                              1, 3 )
                                                              ) T2 ON T1.I_Student_ID = T2.I_Student_ID
                                                              AND T1.ID = T2.ID
                                           ) TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                                INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                                INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                                INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
                                INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                                LEFT JOIN dbo.T_Student_Status_Details_Archive TSSD ON TSD.I_Student_Detail_ID=TSSD.I_Student_Detail_ID AND TSSD.I_Status=1 AND CONVERT(DATE,TSSD.Dt_Crtd_On)=CONVERT(DATE,@dtDate)
                                LEFT JOIN dbo.T_Student_Status_Master TSSM ON TSSD.I_Student_Status_ID = TSSM.I_Student_Status_ID
                        WHERE   TCHND.I_Center_ID IN (
                                SELECT  FGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR )
                                --AND TSD.I_Status = 0
                                AND TSBD.I_Batch_ID IN (
                                SELECT  CAST(FSR.Val AS INT)
                                FROM    dbo.fnString2Rows(@sBatchIDList, ',') FSR )
           --             UNION ALL
           --             SELECT  TSD.I_Student_Detail_ID ,
           --                     TSD.S_Student_ID ,
           --                     TSD.S_First_Name + ' '
           --                     + ISNULL(TSD.S_Middle_Name, '') + ' '
           --                     + TSD.S_Last_Name AS StudentName ,
           --                     TSBM.S_Batch_Name ,
           --                     TCHND.I_Center_ID ,
           --                     TCHND.S_Center_Name ,
           --                     TCHND.S_Brand_Name ,
           --                     TSD.S_Mobile_No ,
           --                     TCM.S_Course_Name ,
           --                     2 AS CategoryID ,
           --                     'DropOut' AS CategoryName ,
           --                     dbo.fnGetAcademicDropOutStatus(NULL,TSD.I_Student_Detail_ID,
           --                                                   @dtDate) AS CurrentStatus
           --     --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, NULL) AS Dropout
           --             FROM    dbo.T_Student_Detail TSD
           --                     INNER JOIN ( SELECT T1.I_Student_ID ,
           --                                         T2.I_Batch_ID
           --                                  FROM   ( SELECT  TSBD2.I_Student_ID ,
           --                                                   MAX(TSBD2.I_Student_Batch_ID) AS ID
           --                                           FROM    dbo.T_Student_Batch_Details TSBD2
           --                                           WHERE   TSBD2.I_Status IN (
           --                                                   1, 3 )
           --                                           GROUP BY TSBD2.I_Student_ID
           --                                         ) T1
           --                                         INNER JOIN ( SELECT
           --                                                   TSBD3.I_Student_ID ,
           --                                                   TSBD3.I_Student_Batch_ID AS ID ,
           --                                                   TSBD3.I_Batch_ID
           --                                                   FROM
           --                                                   dbo.T_Student_Batch_Details TSBD3
           --                                                   WHERE
           --                                                   TSBD3.I_Status IN (
           --                                                   1, 3 )
           --                                                   ) T2 ON T1.I_Student_ID = T2.I_Student_ID
           --                                                   AND T1.ID = T2.ID
           --                                ) TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
           --                     INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
           --                     INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
           --                     INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
           --                     INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
           --                     INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
           --             WHERE   TCHND.I_Center_ID IN (
           --                     SELECT  FGCFR.centerID
           --                     FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
           --                                                   @iBrandID) FGCFR )
           --                     AND TSD.I_Status = 1
           --                     AND TSBD.I_Batch_ID IN (
           --                     SELECT  CAST(FSR.Val AS INT)
           --                     FROM    dbo.fnString2Rows(@sBatchIDList, ',') FSR )
           --             UNION ALL
           --             SELECT  T1.I_Student_Detail_ID ,
           --                     T1.S_Student_ID ,
           --                     T1.StudentName ,
           --                     T1.S_Batch_Name ,
           --                     T1.I_Center_ID ,
           --                     T1.S_Center_Name ,
           --                     T1.S_Brand_Name ,
           --                     T1.S_Mobile_No ,
           --                     T1.S_Course_Name ,
           --                     T1.CategoryID ,
           --                     T1.CategoryName ,
           --                     CASE WHEN T2.IsOnLeave IS NULL THEN 0
           --                          WHEN T2.IsOnLeave = 1 THEN 1
           --                     END AS CurrentStatus
           --             FROM    ( SELECT    TSD.I_Student_Detail_ID ,
           --                                 TSD.S_Student_ID ,
           --                                 TSD.S_First_Name + ' '
           --                                 + ISNULL(TSD.S_Middle_Name, '')
           --                                 + ' ' + TSD.S_Last_Name AS StudentName ,
           --                                 TSBM.S_Batch_Name ,
           --                                 TCHND.I_Center_ID ,
           --                                 TCHND.S_Center_Name ,
           --                                 TCHND.S_Brand_Name ,
           --                                 TSD.S_Mobile_No ,
           --                                 TCM.S_Course_Name ,
           --                                 3 AS CategoryID ,
           --                                 'IsOnleave' AS CategoryName
           --     --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, @dtDate) AS CurrentStatus 
           --     --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, NULL) AS Dropout
           --                       FROM      dbo.T_Student_Detail TSD
           --                                 INNER JOIN ( SELECT
           --                                                   T1.I_Student_ID ,
           --                                                   T2.I_Batch_ID
           --                                              FROM ( SELECT
           --                                                   TSBD2.I_Student_ID ,
           --                                                   MAX(TSBD2.I_Student_Batch_ID) AS ID
           --                                                   FROM
           --                                                   dbo.T_Student_Batch_Details TSBD2
           --                                                   WHERE
           --                                                   TSBD2.I_Status IN (
           --                                                   1, 3 )
           --                                                   GROUP BY TSBD2.I_Student_ID
           --                                                   ) T1
           --                                                   INNER JOIN ( SELECT
           --                                                   TSBD3.I_Student_ID ,
           --                                                   TSBD3.I_Student_Batch_ID AS ID ,
           --                                                   TSBD3.I_Batch_ID
           --                                                   FROM
           --                                                   dbo.T_Student_Batch_Details TSBD3
           --                                                   WHERE
           --                                                   TSBD3.I_Status IN (
           --                                                   1, 3 )
           --                                                   ) T2 ON T1.I_Student_ID = T2.I_Student_ID
           --                                                   AND T1.ID = T2.ID
           --                                            ) TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
           --                                 INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
           --                                 INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
           --                                 INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
           --                                 INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
           --                                 INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
           --                       WHERE     TCHND.I_Center_ID IN (
           --                                 SELECT  FGCFR.centerID
           --                                 FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
           --                                                   @iBrandID) FGCFR )
           --                                 AND TSD.I_Status = 1
           --                                 AND TSBD.I_Batch_ID IN (
           --                                 SELECT  CAST(FSR.Val AS INT)
           --                                 FROM    dbo.fnString2Rows(@sBatchIDList,
           --                                                   ',') FSR )
           --                     ) T1
           --                     LEFT JOIN ( SELECT  TSLR.I_Student_Detail_ID ,
           --                                         1 AS IsOnLeave
           --                                 FROM    dbo.T_Student_Leave_Request TSLR
           --                                 WHERE   TSLR.I_Status = 1
           --                                         AND @dtDate BETWEEN TSLR.Dt_From_Date
           --                                                   AND
           --                                                   TSLR.Dt_To_Date
           --                               ) T2 ON T1.I_Student_Detail_ID = T2.I_Student_Detail_ID
           --             UNION ALL
           --             SELECT  T1.I_Student_Detail_ID ,
           --                     T1.S_Student_ID ,
           --                     T1.StudentName ,
           --                     T1.S_Batch_Name ,
           --                     T1.I_Center_ID ,
           --                     T1.S_Center_Name ,
           --                     T1.S_Brand_Name ,
           --                     T1.S_Mobile_No ,
           --                     T1.S_Course_Name ,
           --                     T1.CategoryID ,
           --                     T1.CategoryName ,
           --                     CASE WHEN T2.Defaulter IS NULL THEN 0
           --                          WHEN T2.Defaulter = 1 THEN 1
           --                     END AS CurrentStatus
           --             FROM    ( SELECT    TSD.I_Student_Detail_ID ,
           --                                 TSD.S_Student_ID ,
           --                                 TSD.S_First_Name + ' '
           --                                 + ISNULL(TSD.S_Middle_Name, '')
           --                                 + ' ' + TSD.S_Last_Name AS StudentName ,
           --                                 TSBM.S_Batch_Name ,
           --                                 TCHND.I_Center_ID ,
           --                                 TCHND.S_Center_Name ,
           --                                 TCHND.S_Brand_Name ,
           --                                 TSD.S_Mobile_No ,
           --                                 TCM.S_Course_Name ,
           --                                 4 AS CategoryID ,
           --                                 'Defaulter' AS CategoryName
                            
           --     --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, @dtDate) AS CurrentStatus 
           --     --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, NULL) AS Dropout
           --                       FROM      dbo.T_Student_Detail TSD
           --                                 INNER JOIN ( SELECT
           --                                                   T1.I_Student_ID ,
           --                                                   T2.I_Batch_ID
           --                                              FROM ( SELECT
           --                                                   TSBD2.I_Student_ID ,
           --                                                   MAX(TSBD2.I_Student_Batch_ID) AS ID
           --                                                   FROM
           --                                                   dbo.T_Student_Batch_Details TSBD2
           --                                                   WHERE
           --                                                   TSBD2.I_Status IN (
           --                                                   1, 3 )
           --                                                   GROUP BY TSBD2.I_Student_ID
           --                                                   ) T1
           --                                                   INNER JOIN ( SELECT
           --                                                   TSBD3.I_Student_ID ,
           --                                                   TSBD3.I_Student_Batch_ID AS ID ,
           --                                                   TSBD3.I_Batch_ID
           --                                                   FROM
           --                                                   dbo.T_Student_Batch_Details TSBD3
           --                                                   WHERE
           --                                                   TSBD3.I_Status IN (
           --                                                   1, 3 )
           --                                                   ) T2 ON T1.I_Student_ID = T2.I_Student_ID
           --                                                   AND T1.ID = T2.ID
           --                                            ) TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
           --                                 INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
           --                                 INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
           --                                 INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
           --                                 INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
           --                                 INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
           --                       WHERE     TCHND.I_Center_ID IN (
           --                                 SELECT  FGCFR.centerID
           --                                 FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
           --                                                   @iBrandID) FGCFR )
           --                                 AND TSD.I_Status = 1
           --                                 AND TSBD.I_Batch_ID IN (
           --                                 SELECT  CAST(FSR.Val AS INT)
           --                                 FROM    dbo.fnString2Rows(@sBatchIDList,
           --                                                   ',') FSR )
           --                     ) T1
           --                     LEFT JOIN ( SELECT  DISTINCT
           --                                         XX.S_Student_ID ,
           --                                         1 AS Defaulter
           --                                 FROM    ( SELECT  S_Student_ID ,
           --                                                   SUM(ISNULL(Total_Due,
           --                                                   0)) AS TotalDue
           --                                           FROM    #temp TTT
           --                                           WHERE   DATEDIFF(d,
           --                                                   TTT.Dt_Installment_Date,
           --                                                   @dtDate) >= 10
           --                                             --AND T1.S_Student_ID=@Sstudentid      
           --                                           GROUP BY S_Student_ID
           --                                         ) XX
           --                                 WHERE   XX.TotalDue >= 100
           --                               ) T2 ON T1.S_Student_ID = T2.S_Student_ID
                                          
                                          
           --                               UNION ALL
           --             SELECT  T1.I_Student_Detail_ID ,
           --                     T1.S_Student_ID ,
           --                     T1.StudentName ,
           --                     T1.S_Batch_Name ,
           --                     T1.I_Center_ID ,
           --                     T1.S_Center_Name ,
           --                     T1.S_Brand_Name ,
           --                     T1.S_Mobile_No ,
           --                     T1.S_Course_Name ,
           --                     T1.CategoryID ,
           --                     T1.CategoryName ,
           --                     CASE WHEN T2.Completed IS NULL THEN 0
           --                          WHEN T2.Completed = 1 THEN 1
           --                     END AS CurrentStatus
           --             FROM    ( SELECT    TSD.I_Student_Detail_ID ,
           --                                 TSD.S_Student_ID ,
           --                                 TSD.S_First_Name + ' '
           --                                 + ISNULL(TSD.S_Middle_Name, '')
           --                                 + ' ' + TSD.S_Last_Name AS StudentName ,
           --                                 TSBM.S_Batch_Name ,
           --                                 TCHND.I_Center_ID ,
           --                                 TCHND.S_Center_Name ,
           --                                 TCHND.S_Brand_Name ,
           --                                 TSD.S_Mobile_No ,
           --                                 TCM.S_Course_Name ,
           --                                 6 AS CategoryID ,
           --                                 'Completed' AS CategoryName
           --     --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, @dtDate) AS CurrentStatus 
           --     --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, NULL) AS Dropout
           --                       FROM      dbo.T_Student_Detail TSD
           --                                 INNER JOIN ( SELECT
           --                                                   T1.I_Student_ID ,
           --                                                   T2.I_Batch_ID
           --                                              FROM ( SELECT
           --                                                   TSBD2.I_Student_ID ,
           --                                                   MAX(TSBD2.I_Student_Batch_ID) AS ID
           --                                                   FROM
           --                                                   dbo.T_Student_Batch_Details TSBD2
           --                                                   WHERE
           --                                                   TSBD2.I_Status IN (
           --                                                   1, 3 )
           --                                                   GROUP BY TSBD2.I_Student_ID
           --                                                   ) T1
           --                                                   INNER JOIN ( SELECT
           --                                                   TSBD3.I_Student_ID ,
           --                                                   TSBD3.I_Student_Batch_ID AS ID ,
           --                                                   TSBD3.I_Batch_ID
           --                                                   FROM
           --                                                   dbo.T_Student_Batch_Details TSBD3
           --                                                   WHERE
           --                                                   TSBD3.I_Status IN (
           --                                                   1, 3 )
           --                                                   ) T2 ON T1.I_Student_ID = T2.I_Student_ID
           --                                                   AND T1.ID = T2.ID
           --                                            ) TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
           --                                 INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
           --                                 INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
           --                                 INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
           --                                 INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
           --                                 INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
           --                       WHERE     TCHND.I_Center_ID IN (
           --                                 SELECT  FGCFR.centerID
           --                                 FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
           --                                                   @iBrandID) FGCFR )
           --                                 AND TSD.I_Status = 1
           --                                 AND TSBD.I_Batch_ID IN (
           --                                 SELECT  CAST(FSR.Val AS INT)
           --                                 FROM    dbo.fnString2Rows(@sBatchIDList,
           --                                                   ',') FSR )
           --                         --AND TSBD.I_Batch_ID IN (
           --                         --SELECT  CAST(FSR.Val AS INT)
           --                         --FROM    dbo.fnString2Rows(@sBatchIDList,
           --                         --                          ',') FSR )
                                  
           --                     ) T1
           --                     LEFT JOIN ( SELECT TSSD.I_Student_Detail_ID,1 AS Completed FROM dbo.T_Student_Status_Details TSSD
											--WHERE
											--TSSD.I_Student_Status_ID=2 AND TSSD.I_Status=1
											--AND CONVERT(DATE,TSSD.Dt_Crtd_On)<=CONVERT(DATE,@dtdate)
           --                               ) T2 ON T1.I_Student_Detail_ID = T2.I_Student_Detail_ID
                          
                          
           --     DELETE  FROM #temp1
           --     WHERE   CurrenStatus = 0
                         
                          
                         
           --     INSERT  INTO #temp1
           --             ( StudentDetailID ,
           --               StudentID ,
           --               StudentName ,
           --               BatchName ,
           --               CenterID ,
           --               CenterName ,
           --               BrandName ,
           --               ContactNo ,
           --               CourseName ,
           --               CategoryID ,
           --               CategoryName ,
           --               CurrenStatus
                            
           --             )
           --             SELECT  TSD.I_Student_Detail_ID ,
           --                     TSD.S_Student_ID ,
           --                     TSD.S_First_Name + ' '
           --                     + ISNULL(TSD.S_Middle_Name, '') + ' '
           --                     + TSD.S_Last_Name AS StudentName ,
           --                     TSBM.S_Batch_Name ,
           --                     TCHND.I_Center_ID ,
           --                     TCHND.S_Center_Name ,
           --                     TCHND.S_Brand_Name ,
           --                     TSD.S_Mobile_No ,
           --                     TCM.S_Course_Name ,
           --                     5 AS CategoryID ,
           --                     'Active' AS CategoryName ,
           --                     1 AS CurrentStatus
           --     --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, NULL) AS Dropout
           --             FROM    dbo.T_Student_Detail TSD
           --                     INNER JOIN ( SELECT T1.I_Student_ID ,
           --                                         T2.I_Batch_ID
           --                                  FROM   ( SELECT  TSBD2.I_Student_ID ,
           --                                                   MAX(TSBD2.I_Student_Batch_ID) AS ID
           --                                           FROM    dbo.T_Student_Batch_Details TSBD2
           --                                           WHERE   TSBD2.I_Status IN (
           --                                                   1, 3 )
           --                                           GROUP BY TSBD2.I_Student_ID
           --                                         ) T1
           --                                         INNER JOIN ( SELECT
           --                                                   TSBD3.I_Student_ID ,
           --                                                   TSBD3.I_Student_Batch_ID AS ID ,
           --                                                   TSBD3.I_Batch_ID
           --                                                   FROM
           --                                                   dbo.T_Student_Batch_Details TSBD3
           --                                                   WHERE
           --                                                   TSBD3.I_Status IN (
           --                                                   1, 3 )
           --                                                   ) T2 ON T1.I_Student_ID = T2.I_Student_ID
           --                                                   AND T1.ID = T2.ID
           --                                ) TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
           --                     INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
           --                     INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
           --                     INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
           --                     INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
           --                     INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
           --             WHERE   TCHND.I_Center_ID IN (
           --                     SELECT  FGCFR.centerID
           --                     FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
           --                                                   @iBrandID) FGCFR )
           --                     AND TSD.I_Status = 1
           --                     AND TSBD.I_Batch_ID IN (
           --                     SELECT  CAST(FSR.Val AS INT)
           --                     FROM    dbo.fnString2Rows(@sBatchIDList, ',') FSR )
           --                     AND TSD.I_Student_Detail_ID NOT IN ( SELECT
           --                                                   StudentDetailID
           --                                                   FROM
           --                                                   #temp1 )
                
                
           --     UPDATE  T1
           --     SET     T1.TotalDue = T2.TotalDue
           --     FROM    #temp1 T1
           --             INNER JOIN ( SELECT XX.S_Student_ID ,
           --                                 XX.TotalDue
           --                          FROM   ( SELECT    S_Student_ID ,
           --                                             SUM(ISNULL(Total_Due,
           --                                                   0)) AS TotalDue
           --                                   FROM      #temp TTT
           --                                   WHERE     DATEDIFF(d,
           --                                                   TTT.Dt_Installment_Date,
           --                                                   @dtDate) >= 10
           --                                             --AND T1.S_Student_ID=@Sstudentid      
           --                                   GROUP BY  S_Student_ID
           --                                 ) XX
           --                          WHERE  XX.TotalDue > 100
           --                        ) T2 ON T1.StudentID = T2.S_Student_ID
           --                                AND T1.CategoryID = 4
                           
                           
                IF ( @iCategoryID = 0 OR @iCategoryID IS NULL ) 
                    BEGIN
                        SELECT  *
                        FROM    #temp1 WHERE CategoryName IS NOT NULL
                    END
                ELSE 
                    BEGIN
                        SELECT  *
                        FROM    #temp1
                        WHERE   CategoryID = @iCategoryID AND CategoryName IS NOT NULL
                    END
            END
                
                          
        
                                               
    END
