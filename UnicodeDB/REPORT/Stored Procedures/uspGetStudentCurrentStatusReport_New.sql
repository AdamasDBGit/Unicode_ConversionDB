CREATE PROCEDURE [REPORT].[uspGetStudentCurrentStatusReport_New]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @dtDate DATETIME ,
      @sBatchIDList VARCHAR(MAX) = NULL ,
      @iCategoryID INT = NULL
    )
AS 
    BEGIN
    
        CREATE TABLE #temp1
            (
              StudentDetailID INT ,
              StudentID VARCHAR(MAX) ,
              StudentName VARCHAR(MAX) ,
              BatchName VARCHAR(MAX) ,
              BatchStartDate DATETIME,
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
    
        
        IF ( CONVERT(DATE, @dtDate) = CONVERT(DATE, GETDATE()) ) 
            BEGIN
    	
               
                    
        
            
                IF ( @sBatchIDList IS NOT NULL ) 
                    BEGIN    
                    
                        INSERT  INTO #temp1
                                ( StudentDetailID ,
                                  StudentID ,
                                  StudentName ,
                                  BatchName ,
                                  BatchStartDate,
                                  CenterID ,
                                  CenterName ,
                                  BrandName ,
                                  ContactNo ,
                                  CourseName ,
                                  CategoryID ,
                                  CategoryName ,
                                  CurrenStatus ,
                                  TotalDue
                            
                                )
                                SELECT  TT.I_Student_Detail_ID ,
                                        TT.S_Student_ID ,
                                        TT.StudentName ,
                                        TT.S_Batch_Name ,
                                        TT.Dt_BatchStartDate,
                                        TT.I_Center_ID ,
                                        TT.S_Center_Name ,
                                        TT.S_Brand_Name ,
                                        TT.S_Mobile_No ,
                                        TT.S_Course_Name ,
                                        TT.CategoryID ,
                                        TT.CategoryName ,
                                        ISNULL(TSSD2.I_Status, 0) AS CurrentStatus ,
                                        TSSD2.N_Due
                                FROM    ( SELECT    T1.I_Student_Detail_ID ,
                                                    T1.S_Student_ID ,
                                                    T1.StudentName ,
                                                    T1.S_Batch_Name ,
                                                    T1.Dt_BatchStartDate,
                                                    T1.I_Center_ID ,
                                                    T1.S_Center_Name ,
                                                    T1.S_Brand_Name ,
                                                    T1.S_Mobile_No ,
                                                    T1.S_Course_Name ,
                                                    TSSM.I_Student_Status_ID AS CategoryID ,
                                                    TSSM.S_Student_Status AS CategoryName
                                          FROM      ( SELECT DISTINCT
                                                              TSD.I_Student_Detail_ID ,
                                                              TSD.S_Student_ID ,
                                                              TSD.S_First_Name
                                                              + ' '
                                                              + ISNULL(TSD.S_Middle_Name,
                                                              '') + ' '
                                                              + TSD.S_Last_Name AS StudentName ,
                                                              TSBM.S_Batch_Name ,
                                                              TSBM.Dt_BatchStartDate,
                                                              TCHND.I_Center_ID ,
                                                              TCHND.S_Center_Name ,
                                                              TCHND.S_Brand_Name ,
                                                              TSD.S_Mobile_No ,
                                                              TCM.S_Course_Name 
                --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, NULL) AS Dropout
                                                      FROM    dbo.T_Student_Detail TSD
                                                              INNER JOIN dbo.T_Student_Status_Details_Archive TSSD ON TSD.I_Student_Detail_ID = TSSD.I_Student_Detail_ID
                                                              
                                                              INNER JOIN ( SELECT
                                                              T1.I_Student_ID ,
                                                              T2.I_Batch_ID
                                                              FROM
                                                              ( SELECT
                                                              TSBD2.I_Student_ID ,
                                                              MAX(TSBD2.I_Student_Batch_ID) AS ID
                                                              FROM
                                                              dbo.T_Student_Batch_Details TSBD2
                                                              WHERE
                                                              TSBD2.I_Status IN (
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
                                                      WHERE   TCHND.I_Center_ID IN (
                                                              SELECT
                                                              FGCFR.centerID
                                                              FROM
                                                              dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR )
                                                              AND CONVERT(DATE,TSSD.Dt_Crtd_On) = CONVERT(DATE,@dtDate)
                                                              AND TSSD.I_Status = 1
                                                    ) T1
                                                    CROSS JOIN dbo.T_Student_Status_Master TSSM
                                        ) TT
                                        LEFT JOIN dbo.T_Student_Status_Details TSSD2 ON TT.I_Student_Detail_ID = TSSD2.I_Student_Detail_ID
                                                              AND TT.CategoryID = TSSD2.I_Student_Status_ID
                                                              AND TSSD2.I_Status = 1  
                           
                           
                        IF ( @iCategoryID = 0
                             OR @iCategoryID IS NULL
                           ) 
                            BEGIN
                                SELECT  *
                                FROM    #temp1
                            END
                        ELSE 
                            BEGIN
                                SELECT  *
                                FROM    #temp1
                                WHERE   CategoryID = @iCategoryID
                            END
                           
                           
                    END
                           
                ELSE 
                    BEGIN
                        INSERT  INTO #temp1
                                ( StudentDetailID ,
                                  StudentID ,
                                  StudentName ,
                                  BatchName ,
                                  BatchStartDate,
                                  CenterID ,
                                  CenterName ,
                                  BrandName ,
                                  ContactNo ,
                                  CourseName ,
                                  CategoryID ,
                                  CategoryName ,
                                  CurrenStatus ,
                                  TotalDue
                            
                                )
                                SELECT  TT.I_Student_Detail_ID ,
                                        TT.S_Student_ID ,
                                        TT.StudentName ,
                                        TT.S_Batch_Name ,
                                        TT.Dt_BatchStartDate,
                                        TT.I_Center_ID ,
                                        TT.S_Center_Name ,
                                        TT.S_Brand_Name ,
                                        TT.S_Mobile_No ,
                                        TT.S_Course_Name ,
                                        TT.CategoryID ,
                                        TT.CategoryName ,
                                        ISNULL(TSSD2.I_Status, 0) AS CurrentStatus ,
                                        TSSD2.N_Due
                                FROM    ( SELECT    T1.I_Student_Detail_ID ,
                                                    T1.S_Student_ID ,
                                                    T1.StudentName ,
                                                    T1.S_Batch_Name ,
                                                    T1.Dt_BatchStartDate,
                                                    T1.I_Center_ID ,
                                                    T1.S_Center_Name ,
                                                    T1.S_Brand_Name ,
                                                    T1.S_Mobile_No ,
                                                    T1.S_Course_Name ,
                                                    TSSM.I_Student_Status_ID AS CategoryID ,
                                                    TSSM.S_Student_Status AS CategoryName
                                          FROM      ( SELECT DISTINCT
                                                              TSD.I_Student_Detail_ID ,
                                                              TSD.S_Student_ID ,
                                                              TSD.S_First_Name
                                                              + ' '
                                                              + ISNULL(TSD.S_Middle_Name,
                                                              '') + ' '
                                                              + TSD.S_Last_Name AS StudentName ,
                                                              TSBM.S_Batch_Name ,
                                                              TSBM.Dt_BatchStartDate,
                                                              TCHND.I_Center_ID ,
                                                              TCHND.S_Center_Name ,
                                                              TCHND.S_Brand_Name ,
                                                              TSD.S_Mobile_No ,
                                                              TCM.S_Course_Name 
                --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, NULL) AS Dropout
                                                      FROM    dbo.T_Student_Detail TSD
                                                              INNER JOIN dbo.T_Student_Status_Details_Archive TSSD ON TSD.I_Student_Detail_ID = TSSD.I_Student_Detail_ID
                                                              INNER JOIN ( SELECT
                                                              T1.I_Student_ID ,
                                                              T2.I_Batch_ID
                                                              FROM
                                                              ( SELECT
                                                              TSBD2.I_Student_ID ,
                                                              MAX(TSBD2.I_Student_Batch_ID) AS ID
                                                              FROM
                                                              dbo.T_Student_Batch_Details TSBD2
                                                              WHERE
                                                              TSBD2.I_Status IN (
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
                                                      WHERE   TCHND.I_Center_ID IN (
                                                              SELECT
                                                              FGCFR.centerID
                                                              FROM
                                                              dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR )
                                                              AND TSBD.I_Batch_ID IN (
                                                              SELECT
                                                              CAST(FSR.Val AS INT)
                                                              FROM
                                                              dbo.fnString2Rows(@sBatchIDList,
                                                              ',') FSR )
                                                              AND CONVERT(DATE,TSSD.Dt_Crtd_On) = CONVERT(DATE,@dtDate)
                                                              AND TSSD.I_Status = 1
                                                    ) T1
                                                    CROSS JOIN dbo.T_Student_Status_Master TSSM
                                        ) TT
                                        LEFT JOIN dbo.T_Student_Status_Details TSSD2 ON TT.I_Student_Detail_ID = TSSD2.I_Student_Detail_ID
                                                              AND TT.CategoryID = TSSD2.I_Student_Status_ID
                                                              AND TSSD2.I_Status = 1         
                           
                           
                        IF ( @iCategoryID = 0
                             OR @iCategoryID IS NULL
                           ) 
                            BEGIN
                                SELECT  *
                                FROM    #temp1
                            END
                        ELSE 
                            BEGIN
                                SELECT  *
                                FROM    #temp1
                                WHERE   CategoryID = @iCategoryID
                            END
                    END
                
            END
          
        ELSE 
            BEGIN
          	
            
                IF ( @sBatchIDList IS NULL ) 
                    BEGIN    
                    
                        INSERT  INTO #temp1
                                ( StudentDetailID ,
                                  StudentID ,
                                  StudentName ,
                                  BatchName ,
                                  BatchStartDate,
                                  CenterID ,
                                  CenterName ,
                                  BrandName ,
                                  ContactNo ,
                                  CourseName ,
                                  CategoryID ,
                                  CategoryName ,
                                  CurrenStatus ,
                                  TotalDue
                            
                                )
                                SELECT  TT.I_Student_Detail_ID ,
                                        TT.S_Student_ID ,
                                        TT.StudentName ,
                                        TT.S_Batch_Name ,
                                        TT.Dt_BatchStartDate,
                                        TT.I_Center_ID ,
                                        TT.S_Center_Name ,
                                        TT.S_Brand_Name ,
                                        TT.S_Mobile_No ,
                                        TT.S_Course_Name ,
                                        TT.CategoryID ,
                                        TT.CategoryName ,
                                        ISNULL(TSSD2.I_Status, 0) AS CurrentStatus ,
                                        TSSD2.N_Due
                                FROM    ( SELECT    T1.I_Student_Detail_ID ,
                                                    T1.S_Student_ID ,
                                                    T1.StudentName ,
                                                    T1.S_Batch_Name ,
                                                    T1.Dt_BatchStartDate,
                                                    T1.I_Center_ID ,
                                                    T1.S_Center_Name ,
                                                    T1.S_Brand_Name ,
                                                    T1.S_Mobile_No ,
                                                    T1.S_Course_Name ,
                                                    TSSM.I_Student_Status_ID AS CategoryID ,
                                                    TSSM.S_Student_Status AS CategoryName
                                          FROM      ( SELECT DISTINCT
                                                              TSD.I_Student_Detail_ID ,
                                                              TSD.S_Student_ID ,
                                                              TSD.S_First_Name
                                                              + ' '
                                                              + ISNULL(TSD.S_Middle_Name,
                                                              '') + ' '
                                                              + TSD.S_Last_Name AS StudentName ,
                                                              TSBM.S_Batch_Name ,
                                                              TSBM.Dt_BatchStartDate,
                                                              TCHND.I_Center_ID ,
                                                              TCHND.S_Center_Name ,
                                                              TCHND.S_Brand_Name ,
                                                              TSD.S_Mobile_No ,
                                                              TCM.S_Course_Name 
                --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, NULL) AS Dropout
                                                      FROM    dbo.T_Student_Detail TSD
                                                              INNER JOIN dbo.T_Student_Status_Details_Archive TSSD ON TSD.I_Student_Detail_ID = TSSD.I_Student_Detail_ID
                                                              INNER JOIN ( SELECT
                                                              T1.I_Student_ID ,
                                                              T2.I_Batch_ID
                                                              FROM
                                                              ( SELECT
                                                              TSBD2.I_Student_ID ,
                                                              MAX(TSBD2.I_Student_Batch_ID) AS ID
                                                              FROM
                                                              dbo.T_Student_Batch_Details TSBD2
                                                              WHERE
                                                              TSBD2.I_Status IN (
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
                                                      WHERE   TCHND.I_Center_ID IN (
                                                              SELECT
                                                              FGCFR.centerID
                                                              FROM
                                                              dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR )
                                                              AND CONVERT(DATE, TSSD.Dt_Crtd_On) = CONVERT(DATE, @dtDate)
                                                    ) T1
                                                    CROSS JOIN dbo.T_Student_Status_Master TSSM
                                        ) TT
                                        LEFT JOIN dbo.T_Student_Status_Details_Archive TSSD2 ON TT.I_Student_Detail_ID = TSSD2.I_Student_Detail_ID
                                                              AND TT.CategoryID = TSSD2.I_Student_Status_ID
                                                              AND TSSD2.I_Status = 1 
															  AND CONVERT(DATE, TSSD2.Dt_Crtd_On) = CONVERT(DATE, @dtDate)
                           
                           
                        IF ( @iCategoryID = 0
                             OR @iCategoryID IS NULL
                           ) 
                            BEGIN
                                SELECT  *
                                FROM    #temp1 where CurrenStatus>0
                            END
                        ELSE 
                            BEGIN
                                SELECT  *
                                FROM    #temp1
                                WHERE   CategoryID = @iCategoryID and CurrenStatus>0
                            END
                           
                           
                    END
                           
                ELSE 
                    BEGIN
                        INSERT  INTO #temp1
                                ( StudentDetailID ,
                                  StudentID ,
                                  StudentName ,
                                  BatchName ,
                                  BatchStartDate,
                                  CenterID ,
                                  CenterName ,
                                  BrandName ,
                                  ContactNo ,
                                  CourseName ,
                                  CategoryID ,
                                  CategoryName ,
                                  CurrenStatus ,
                                  TotalDue
                            
                                )
                                SELECT  TT.I_Student_Detail_ID ,
                                        TT.S_Student_ID ,
                                        TT.StudentName ,
                                        TT.S_Batch_Name ,
                                        TT.Dt_BatchStartDate,
                                        TT.I_Center_ID ,
                                        TT.S_Center_Name ,
                                        TT.S_Brand_Name ,
                                        TT.S_Mobile_No ,
                                        TT.S_Course_Name ,
                                        TT.CategoryID ,
                                        TT.CategoryName ,
                                        ISNULL(TSSD2.I_Status, 0) AS CurrentStatus ,
                                        TSSD2.N_Due
                                FROM    ( SELECT    T1.I_Student_Detail_ID ,
                                                    T1.S_Student_ID ,
                                                    T1.StudentName ,
                                                    T1.S_Batch_Name ,
                                                    T1.Dt_BatchStartDate ,
                                                    T1.I_Center_ID ,
                                                    T1.S_Center_Name ,
                                                    T1.S_Brand_Name ,
                                                    T1.S_Mobile_No ,
                                                    T1.S_Course_Name ,
                                                    TSSM.I_Student_Status_ID AS CategoryID ,
                                                    TSSM.S_Student_Status AS CategoryName
                                          FROM      ( SELECT DISTINCT
                                                              TSD.I_Student_Detail_ID ,
                                                              TSD.S_Student_ID ,
                                                              TSD.S_First_Name
                                                              + ' '
                                                              + ISNULL(TSD.S_Middle_Name,
                                                              '') + ' '
                                                              + TSD.S_Last_Name AS StudentName ,
                                                              TSBM.S_Batch_Name ,
                                                              TSBM.Dt_BatchStartDate,
                                                              TCHND.I_Center_ID ,
                                                              TCHND.S_Center_Name ,
                                                              TCHND.S_Brand_Name ,
                                                              TSD.S_Mobile_No ,
                                                              TCM.S_Course_Name 
                --dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID, NULL) AS Dropout
                                                      FROM    dbo.T_Student_Detail TSD
                                                              INNER JOIN dbo.T_Student_Status_Details_Archive TSSD ON TSD.I_Student_Detail_ID = TSSD.I_Student_Detail_ID
                                                              INNER JOIN ( SELECT
                                                              T1.I_Student_ID ,
                                                              T2.I_Batch_ID
                                                              FROM
                                                              ( SELECT
                                                              TSBD2.I_Student_ID ,
                                                              MAX(TSBD2.I_Student_Batch_ID) AS ID
                                                              FROM
                                                              dbo.T_Student_Batch_Details TSBD2
                                                              WHERE
                                                              TSBD2.I_Status IN (
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
                                                      WHERE   TCHND.I_Center_ID IN (
                                                              SELECT
                                                              FGCFR.centerID
                                                              FROM
                                                              dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR )
                                                              AND TSBD.I_Batch_ID IN (
                                                              SELECT
                                                              CAST(FSR.Val AS INT)
                                                              FROM
                                                              dbo.fnString2Rows(@sBatchIDList,
                                                              ',') FSR )
                                                              AND CONVERT(DATE, TSSD.Dt_Crtd_On) = CONVERT(DATE, @dtDate)
                                                    ) T1
                                                    CROSS JOIN dbo.T_Student_Status_Master TSSM
                                        ) TT
                                        LEFT JOIN dbo.T_Student_Status_Details_Archive TSSD2 ON TT.I_Student_Detail_ID = TSSD2.I_Student_Detail_ID
                                                              AND TT.CategoryID = TSSD2.I_Student_Status_ID
                                                              AND TSSD2.I_Status = 1 
															  AND CONVERT(DATE, TSSD2.Dt_Crtd_On) = CONVERT(DATE, @dtDate)
                           
                           
                        IF ( @iCategoryID = 0
                             OR @iCategoryID IS NULL
                           ) 
                            BEGIN
                                SELECT  *
                                FROM    #temp1 where CurrenStatus>0
                            END
                        ELSE 
                            BEGIN
                                SELECT  *
                                FROM    #temp1
                                WHERE   CategoryID = @iCategoryID and CurrenStatus>0
                            END
                    END
            END                
        
                                             
    END
