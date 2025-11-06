CREATE PROCEDURE [REPORT].[uspGetMonthlyExamAttendanceReport]
    (
      @dtPrevExamDate DATE ,
      @dtExamDate DATE ,
      @sHierarchyList VARCHAR(MAX) ,
      @sBatchIDs VARCHAR(MAX) ,
      @iBrandID INT
    )
AS 
    BEGIN

        CREATE TABLE #temp
            (
              StudentDetailID INT ,
              StudentID VARCHAR(MAX) ,
              BatchID INT ,
              BatchName VARCHAR(MAX) ,
              RollNo INT ,
              StudentName VARCHAR(MAX) ,
              SContactNo VARCHAR(MAX) ,
              GContactNo VARCHAR(MAX) ,
              CourseName VARCHAR(MAX) ,
              CenterID INT ,
              CenterName VARCHAR(MAX) ,
              StudyMaterialID INT ,
              StudyMaterialName VARCHAR(MAX) ,
              BatchStrength INT ,
              IsPresent INT ,
              ExamAttnCount INT ,
              ClassScheduled INT,
              ClassAttended INT,
              ClassAttnPercentage DECIMAL(18,2),
              TotalMarks DECIMAL(18,2),
              TotalAllottedmarks DECIMAL(18,2),
              TotalMarksPercent INT
            )
            
        CREATE TABLE #temp1
            (
              InstanceChain VARCHAR(MAX) ,
              CenterName VARCHAR(MAX) ,
              BatchName VARCHAR(MAX) ,
              CourseName VARCHAR(MAX) ,
              StdDetailID INT ,
              StudentID VARCHAR(MAX) ,
              Roll INT ,
              FirstName VARCHAR(MAX) ,
              MiddleName VARCHAR(MAX) ,
              LastName VARCHAR(MAX) ,
              Scheduled INT ,
              Attended INT ,
              ContactNo VARCHAR(MAX) ,
              Percentage DECIMAL ,
              GuardianPhNo VARCHAR(MAX)
            )
            
        INSERT  INTO #temp
                ( StudentDetailID ,
                  StudentID ,
                  BatchID ,
                  BatchName ,
                  RollNo ,
                  StudentName ,
                  SContactNo ,
                  GContactNo ,
                  CourseName ,
                  CenterID ,
                  CenterName
                )
                SELECT  A.I_Student_Detail_ID ,
                        A.S_Student_ID ,
                        C.I_Batch_ID ,
                        C.S_Batch_Name ,
                        A.I_RollNo ,
                        UPPER(A.S_First_Name + ' ' + ISNULL(A.S_Middle_Name,
                                                            '') + ' '
                              + A.S_Last_Name) ,
                        A.S_Mobile_No ,
                        A.S_Guardian_Phone_No ,
                        UPPER(G.S_Course_Name) AS Course_Name ,
                        E.I_Center_ID ,
                        UPPER(E.S_Center_Name) AS Center_Name
                FROM    T_Student_Detail A
						INNER JOIN dbo.T_Student_Batch_Details B ON A.I_Student_Detail_ID=B.I_Student_ID
                        INNER JOIN T_Student_Batch_Master C ON C.I_Batch_ID = B.I_Batch_ID
                        INNER JOIN T_Center_Batch_Details D ON D.I_Batch_ID = C.I_Batch_ID
                        INNER JOIN T_Center_Hierarchy_Name_Details E ON E.I_Center_ID = D.I_Centre_Id
                        INNER JOIN T_Enquiry_Regn_Detail F ON F.I_Enquiry_Regn_ID = A.I_Enquiry_Regn_ID
                        INNER JOIN T_Course_Master G ON G.I_Course_ID = C.I_Course_ID
                WHERE  B.I_Status IN (1)
                AND 
                D.I_Centre_ID IN (
                        SELECT  fnCenter.centerID
                        FROM    fnGetCentersForReports(@sHierarchyList,
                                                       @iBrandID) fnCenter )
                        AND ( @sBatchIDs IS NULL
                              OR B.I_Batch_ID IN (
                              SELECT    Val
                              FROM      dbo.fnString2Rows(@sBatchIDs, ',') )
                            )
                ORDER BY E.S_Center_Name ,
                        S_Batch_Name ,
                        A.I_RollNo

        UPDATE  TT
        SET     TT.StudyMaterialName = XX.TermName ,
                TT.StudyMaterialID = XX.TermID
        FROM    #temp TT
                INNER JOIN ( SELECT DISTINCT TBEM.I_Batch_ID AS Batch ,
                                    TTM.I_Term_ID AS TermID ,
                                    TTM.S_Term_Name AS TermName
                             FROM   EXAMINATION.T_Batch_Exam_Map TBEM
                                    INNER JOIN dbo.T_Term_Master TTM ON TBEM.I_Term_ID = TTM.I_Term_ID
                                    INNER JOIN EXAMINATION.T_Student_Marks AS TSM ON TSM.I_Batch_Exam_ID = TBEM.I_Batch_Exam_ID
                             WHERE  
                             --TBEM.Dt_Crtd_On >= @dtExamDate
                             --       AND TBEM.Dt_Crtd_On < DATEADD(d, 46,
                             --                                 @dtExamDate)
                             TSM.Dt_Exam_Date=@dtExamDate
                           ) XX ON TT.BatchID = XX.Batch
                           
        UPDATE  TT
        SET     TT.BatchStrength = XX.BStrength
        FROM    #temp TT
                INNER JOIN ( SELECT I_Batch_ID ,
                                    COUNT(DISTINCT I_Student_ID) AS BStrength
                             FROM   dbo.T_Student_Batch_Details TSBD
                             WHERE  TSBD.I_Status IN ( 1 )
                                    --AND TSBD.Dt_Valid_From < @dtExamDate
                             GROUP BY I_Batch_ID
                           ) XX ON TT.BatchID = XX.I_Batch_ID
        WHERE   TT.StudyMaterialID IS NOT NULL  
        
        UPDATE  TT
        SET     TT.IsPresent = XX.StatusID
        FROM    #temp TT
                INNER JOIN ( SELECT DISTINCT
                                    I_Student_Detail_ID AS StudentID ,
                                    1 AS StatusID
                             FROM   EXAMINATION.T_Student_Marks TSM
                             WHERE  Dt_Exam_Date = @dtExamDate
                                    AND I_Center_ID IN (
                                    SELECT  fnCenter.centerID
                                    FROM    fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) fnCenter )
                           ) XX ON TT.StudentDetailID = XX.StudentID
        WHERE   TT.StudyMaterialID IS NOT NULL
                                                       
        UPDATE  TT
        SET     TT.ExamAttnCount = XX.ExamAttnCount
        FROM    #temp TT
                INNER JOIN ( SELECT TBEM.I_Batch_ID AS BatchID ,
                                    COUNT(DISTINCT TSM.I_Student_Detail_ID) AS ExamAttnCount
                             FROM   EXAMINATION.T_Student_Marks TSM
                                    INNER JOIN EXAMINATION.T_Batch_Exam_Map TBEM ON TSM.I_Batch_Exam_ID = TBEM.I_Batch_Exam_ID
                             WHERE  TSM.Dt_Exam_Date = @dtExamDate
                             GROUP BY TBEM.I_Batch_ID
                           ) XX ON TT.BatchID = XX.BatchID
        WHERE   TT.StudyMaterialID IS NOT NULL
        
        UPDATE TT
        SET TT.ClassAttended=XX.ClsAttn
        FROM #temp TT
        INNER JOIN
        (
        SELECT TTTM.I_Center_ID AS CenterID,TTTM.I_Batch_ID AS BatchID,TSA.I_Student_Detail_ID AS StdID,COUNT(DISTINCT TSA.I_Attendance_Detail_ID) AS ClsAttn FROM dbo.T_Student_Attendance TSA
        INNER JOIN dbo.T_TimeTable_Master TTTM ON TSA.I_TimeTable_ID = TTTM.I_TimeTable_ID
        WHERE
        TTTM.I_Status=1
        AND TTTM.Dt_Schedule_Date>@dtPrevExamDate AND TTTM.Dt_Schedule_Date<@dtExamDate
        GROUP BY TTTM.I_Center_ID,TTTM.I_Batch_ID,TSA.I_Student_Detail_ID
        ) XX ON TT.BatchID=XX.BatchID AND TT.CenterID=XX.CenterID AND TT.StudentDetailID=XX.StdID
        WHERE   TT.StudyMaterialID IS NOT NULL
        
        UPDATE TT
        SET TT.ClassScheduled=XX.ClassSch
        FROM #temp TT
        INNER JOIN
        (
        SELECT TTTM.I_Center_ID AS CenterID,TTTM.I_Batch_ID AS BatchID,COUNT(DISTINCT TTTM.I_TimeTable_ID) AS ClassSch FROM dbo.T_TimeTable_Master TTTM
        WHERE
        TTTM.I_Status=1
        AND TTTM.Dt_Schedule_Date>@dtPrevExamDate AND TTTM.Dt_Schedule_Date<@dtExamDate
        GROUP BY TTTM.I_Center_ID,TTTM.I_Batch_ID
        ) XX ON TT.BatchID=XX.BatchID AND TT.CenterID=XX.CenterID
        WHERE   TT.StudyMaterialID IS NOT NULL
        
        
--        INSERT  INTO #temp1
--                ( InstanceChain ,
--                  CenterName ,
--                  BatchName ,
--                  CourseName ,
--                  StdDetailID ,
--                  StudentID ,
--                  Roll ,
--                  FirstName ,
--                  MiddleName ,
--                  LastName ,
--                  Scheduled ,
--                  Attended ,
--                  ContactNo ,
--                  Percentage ,
--                  GuardianPhNo
--                )
--                SELECT       ---Gets the No Of Classes Scheduled for the batch 
--                        FN2.instanceChain ,
--                        F.S_Center_Name ,
--                        C.S_Batch_Name ,
--                        H.S_Course_Name ,
--                        A.I_Student_Detail_ID ,
--                        A.S_Student_ID ,
--                        A.I_RollNo ,
--                        A.S_First_Name ,
--                        ISNULL(A.S_Middle_Name, '') AS "Middle Name" ,
--                        A.S_Last_Name ,  
----COUNT(D.Dt_Actual_Date) AS "SCHEDULED",  
--                        D.SCHEDULED ,
--                        ISNULL(TEMP.ATTENDED, '') AS "ATTENDED" ,
--                        A.S_Mobile_No ,
--                        ISNULL(ROUND(( CONVERT(DECIMAL, TEMP.ATTENDED)
--                                       / CONVERT(DECIMAL, D.SCHEDULED) ) * 100,
--                                     2), 0) AS PercentageAttended ,
--                        ISNULL(ISNULL(A.S_Guardian_Phone_No,
--                                      A.S_Guardian_Mobile_No), '') AS S_Guardian_Phone_No
--                FROM    T_Student_Detail A
--                        INNER JOIN T_Student_Batch_Details B ON A.I_Student_Detail_ID = B.I_Student_ID
--                                                              AND B.I_Status = 1
--                        INNER JOIN T_Student_Batch_Master C ON C.I_Batch_ID = B.I_Batch_ID
--                        INNER JOIN --T_TimeTable_Master D  
--                        ( SELECT    I_Batch_ID ,
--                                    COUNT(Dt_Schedule_Date) AS SCHEDULED
--                          FROM      T_TimeTable_Master
--                          WHERE     DATEDIFF(dd, Dt_Schedule_Date,
--                                             @dtPrevExamDate) <= 0  --this should be e.Dt_Attendance_Date  
--                                    AND DATEDIFF(dd, Dt_Schedule_Date,
--                                                 @dtExamDate) >= 0
--                          GROUP BY  I_Batch_ID
--                        ) D ON D.I_Batch_ID = C.I_Batch_ID
--                        INNER JOIN T_Center_Batch_Details E ON E.I_Batch_ID = C.I_Batch_ID
--                        INNER JOIN T_Center_Hierarchy_Name_Details F ON F.I_Center_ID = E.I_Centre_Id
--                        INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList,
--                                                              @iBrandID) FN1 ON F.I_Center_Id = FN1.CenterID
--                        INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,
--                                                              @iBrandID) FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
--                        INNER JOIN T_Course_Center_Detail G ON G.I_Centre_Id = F.I_Center_ID
--                        INNER JOIN T_Course_Master H ON C.I_Course_ID = H.I_Course_ID
--                        LEFT OUTER JOIN --- Gets the Attendance Count Student wise for the batch  
--                        ( SELECT    C.I_Batch_ID ,
--                                    A.I_Student_Detail_ID ,
--                                    A.S_Student_ID ,
--                                    COUNT(DISTINCT E.I_TimeTable_ID) AS "ATTENDED"
--                          FROM      T_Student_Detail A
--                                    INNER JOIN T_Student_Batch_Details B ON A.I_Student_Detail_ID = B.I_Student_ID
--                                    INNER JOIN T_Center_Batch_Details C ON C.I_Batch_ID = B.I_Batch_ID
--                                    INNER JOIN T_Center_Hierarchy_Name_Details D ON D.I_Center_ID = C.I_Centre_Id
--                                    LEFT JOIN T_Student_Attendance E ON B.I_Student_ID = E.I_Student_Detail_ID
--                          WHERE     --B.I_Batch_ID LIKE COALESCE(@ibatchID,B.I_Batch_ID)  
--                                    E.I_TimeTable_ID IN (
--                                    SELECT  I_TimeTable_ID
--                                    FROM    T_TimeTable_Master
--                                    WHERE   ( @sBatchIDs IS NULL
--                                              OR B.I_Batch_ID IN (
--                                              SELECT    Val
--                                              FROM      dbo.fnString2Rows(@sBatchIDs,
--                                                              ',') )
--                                            )
--                                            AND Dt_Schedule_Date BETWEEN @dtPrevExamDate
--                                                              AND
--                                                              @dtExamDate

----Added on 23.9.14
--                                            AND I_Status = 1 --Added on 23.9.14

--)
--                                    AND D.I_Center_ID IN (
--                                    SELECT  CenterList.centerID
--                                    FROM    dbo.fnGetCentersForReports(@sHierarchyList,
--                                                              @iBrandID) CenterList )
--                                    AND B.I_Status = 1   
----and D.I_Center_ID LIKE COALESCE(@icenterID,D.I_Center_ID)  
  
----and E.Dt_Crtd_ON between @dtStartDate and @dtEndDate   
----AND DATEDIFF(dd,E.Dt_Crtd_ON,@dtStartDate) <= 0    
----AND DATEDIFF(dd,E.Dt_Crtd_ON,@dtEndDate) >= 0    
--GROUP BY                            S_Student_ID ,
--                                    A.I_Student_Detail_ID ,
--                                    C.I_Batch_ID
--                        ) TEMP ON A.I_Student_Detail_ID = TEMP.I_Student_Detail_ID
--                                  AND C.I_Batch_ID = TEMP.I_Batch_ID
--                WHERE   --B.I_Batch_ID LIKE COALESCE(@ibatchID,B.I_Batch_ID)   
--                        ( @sBatchIDs IS NULL
--                          OR B.I_Batch_ID IN (
--                          SELECT    Val
--                          FROM      dbo.fnString2Rows(@sBatchIDs, ',') )
--                        )
--                        AND F.I_Center_ID IN (
--                        SELECT  CenterList.centerID
--                        FROM    dbo.fnGetCentersForReports(@sHierarchyList,
--                                                           @iBrandID) CenterList )
--                        AND B.I_Status IN  (1,2)   
----AND DATEDIFF(dd,d.Dt_Actual_Date ,@dtStartDate) <= 0  --added to check scheduled count  
----AND DATEDIFF(dd,d.Dt_Actual_Date,@dtEndDate) >= 0    --added to check scheduled count  
----and F.I_Center_ID LIKE COALESCE(@icenterID,F.I_Center_ID)  
--GROUP BY                A.I_Student_Detail_ID ,
--                        A.S_Student_ID ,
--                        A.S_First_Name ,
--                        A.S_Middle_Name ,
--                        A.S_Last_Name ,
--                        C.S_Batch_Name ,
--                        F.S_Center_Name ,
--                        H.S_Course_Name ,
--                        A.S_Mobile_No ,
--                        A.I_RollNo ,
--                        TEMP.ATTENDED ,
--                        D.SCHEDULED ,
--                        A.S_Guardian_Phone_No ,
--                        a.S_Guardian_Mobile_No ,
--                        FN2.instanceChain
--                ORDER BY F.S_Center_Name ,
--                        A.I_RollNo  
                    
                    
        --UPDATE  TT
        --SET     TT.ClassAttnPercentage = XX.Percentage
        --FROM    #temp TT
        --        INNER JOIN #temp1 XX ON TT.StudentDetailID = XX.StdDetailID
        --                                AND TT.StudyMaterialID IS NOT NULL
        --                                AND TT.BatchName=XX.BatchName
                                        
        UPDATE #temp SET ClassAttnPercentage=ISNULL(ROUND((CONVERT(DECIMAL,#temp.ClassAttended) /CONVERT(DECIMAL,#temp.ClassScheduled)) * 100, 2),0)
        WHERE StudyMaterialID IS NOT NULL
        
        UPDATE TT
        SET TT.TotalMarks=XX.TotalMarks
        FROM #temp TT
        INNER JOIN
        (                                           
        SELECT TBEM.I_Term_ID,TBEM.I_Batch_ID,TSM.I_Student_Detail_ID,SUM(TSM.I_Exam_Total) AS TotalMarks FROM EXAMINATION.T_Student_Marks AS TSM
        INNER JOIN EXAMINATION.T_Batch_Exam_Map AS TBEM ON TBEM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID
        WHERE CONVERT(DATE,TSM.Dt_Exam_Date)=CONVERT(DATE,@dtExamDate) AND TBEM.I_Status=1 
        GROUP BY TBEM.I_Term_ID,TBEM.I_Batch_ID,TSM.I_Student_Detail_ID 
        ) XX ON TT.StudentDetailID=XX.I_Student_Detail_ID AND TT.BatchID=XX.I_Batch_ID AND TT.StudyMaterialID=XX.I_Term_ID  
        
        
        UPDATE TT
        SET TT.TotalAllottedmarks=XX.TotalAllottedmarks
        FROM #temp TT
        INNER JOIN
        (                                           
        SELECT TTES.I_Term_ID,SUM(TTES.I_TotMarks) AS TotalAllottedmarks FROM dbo.T_Term_Eval_Strategy AS TTES 
        WHERE TTES.I_Status=1
        GROUP BY TTES.I_Term_ID
        ) XX ON TT.StudyMaterialID=XX.I_Term_ID 
        
        UPDATE #temp SET TotalMarksPercent=(ISNULL(TotalMarks,0)/ISNULL(TotalAllottedmarks,1))*100                                                    

        SELECT  *
        FROM    #temp T
        WHERE   StudyMaterialID IS NOT NULL ;

    END
