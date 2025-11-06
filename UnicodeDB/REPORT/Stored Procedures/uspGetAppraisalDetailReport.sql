CREATE PROCEDURE [REPORT].[uspGetAppraisalDetailReport]
    (
      @dtExamDate DATETIME ,
      @dtstart DATETIME ,
      @sHierarchyList VARCHAR(MAX) ,
      @iBrandID INT ,
      @iBatchID VARCHAR(MAX)
    )
AS 
    BEGIN
    
   --PRINT 'Create Temp Tables'
    -------------------Create temporary tables start---------------------------
    
    CREATE TABLE #temp1
            (
              S_Center_Name VARCHAR(100) ,
              I_Student_Detail_ID INT ,
              I_Term_ID INT ,
              I_Batch_ID INT ,
              I_Center_ID INT ,
              STUDENT_CODE VARCHAR(100) ,
              NAME VARCHAR(100) ,
              S_Batch_Name VARCHAR(100) ,
              Course_Name VARCHAR(100) ,
              S_Term_Name VARCHAR(100) ,
              S_Component_Name VARCHAR(100) ,
              S_Course_Name VARCHAR(100) ,
              MARKS_OBTAINED REAL ,
              FULL_MARKS INT ,
              PERCENTAGE REAL ,
              Category VARCHAR(MAX) ,
              RankCategory VARCHAR(MAX) ,
              RankNo INT ,
              Total_Percentage REAL ,
              S_Mobile_No VARCHAR(100) ,
              I_RollNo INT ,
              Class_Scheduled INT ,
              Class_Attended INT ,
              Homework_Assigned INT
		    --Homework_Submitted INT,
		    --S_Photo VARCHAR(100),
		    --Highest_Marks INT
            )

        CREATE TABLE #temp2
            (
              S_Center_Name VARCHAR(100) ,
              I_Student_Detail_ID INT ,
              I_Term_ID INT ,
              I_Batch_ID INT ,
              I_Center_ID INT ,
              STUDENT_CODE VARCHAR(100) ,
              NAME VARCHAR(100) ,
              S_Batch_Name VARCHAR(100) ,
              Course_Name VARCHAR(100) ,
              S_Term_Name VARCHAR(100) ,
              S_Component_Name VARCHAR(100) ,
              S_Course_Name VARCHAR(100) ,
              MARKS_OBTAINED REAL ,
              FULL_MARKS INT ,
              PERCENTAGE REAL ,
              Category VARCHAR(MAX) ,
              RankCategory VARCHAR(MAX) ,
              RankNo INT ,
              Total_Percentage REAL ,
              S_Mobile_No VARCHAR(100) ,
              I_RollNo INT ,
              Class_Scheduled INT ,
              Class_Attended INT ,
              Homework_Assigned INT ,
              Homework_Submitted INT ,
              MathTeacher VARCHAR(MAX) ,
              EnglishTeacher VARCHAR(MAX) ,
              GITeacher VARCHAR(MAX) ,
              Mentor VARCHAR(MAX) ,
              HistBatchStrength INT ,
              CurrBatchStrength INT ,
              BatchDuration INT ,
              Board VARCHAR(MAX) ,
              Contact VARCHAR(MAX)
		    --Homework_Submitted INT,
		    --S_Photo VARCHAR(100),
		    --Highest_Marks INT
            )
  
  --SELECT 'Start'          
-------------------Create temporary tables end---------------------------  
    
    IF (@iBatchID IS NOT NULL OR @iBatchID!='')
    BEGIN


                  
            
-------------------Populate Base Table start-----------------------------            
        INSERT  INTO #temp1
                ( S_Center_Name ,
                  I_Student_Detail_ID ,
                  I_Term_ID ,
                  I_Batch_ID ,
                  I_Center_ID ,
                  STUDENT_CODE ,
                  NAME ,
                  S_Batch_Name ,
                  Course_Name ,
                  S_Term_Name ,
                  S_Mobile_No ,
                  I_RollNo ,
                  Category ,
                  MARKS_OBTAINED ,
                  FULL_MARKS ,
                  PERCENTAGE 
                )
                SELECT  E.S_Center_Name ,
                        A.I_Student_Detail_ID ,
			--S_Student_Photo,
                        T2.I_Term_ID ,
                        C.I_Batch_ID ,
                        D.I_Centre_Id ,
                        S_Student_ID AS STUDENT_CODE ,
                        A.S_First_Name + ' ' + A.S_Middle_Name + ' '
                        + A.S_Last_Name AS NAME ,
                        c.S_Batch_Name ,
                        S_Course_Name ,
                        S_Term_Name ,
			--S_Component_Name,
                        A.S_Mobile_No ,
                        A.I_RollNo AS I_RollNo ,
                        'Monthly Test Score' AS Category ,
                        SUM(ISNULL(J.I_Exam_Total, 0)) / 1.00 AS MARKS_OBTAINED ,
                        SUM(G.I_TotMarks) AS FULL_MARKS ,
                        ( SUM(ISNULL(CAST(J.I_Exam_Total AS DECIMAL), 0))
                          / SUM(CAST(G.I_TotMarks AS DECIMAL)) ) * 100 AS 'PERCENTAGE'
                FROM    T_Student_Detail A
                        INNER JOIN T_Student_Batch_Details B ON A.I_Student_Detail_ID = B.I_Student_ID
                                                              AND ( B.I_Status = 1
                                                              OR B.I_Status = 2
                                                              )
                        INNER JOIN T_Student_Batch_Master C ON C.I_Batch_ID = B.I_Batch_ID
                        INNER JOIN T_Center_Batch_Details D ON D.I_Batch_ID = C.I_Batch_ID
                        INNER JOIN T_Center_Hierarchy_Name_Details E ON E.I_Center_ID = D.I_Centre_Id
                        INNER JOIN T_Course_Master F ON F.I_Course_ID = C.I_Course_ID
                        INNER JOIN T_Term_Course_Map T1 ON T1.I_Course_ID = F.I_Course_ID
                        INNER JOIN T_Term_Master T2 ON T2.I_Term_ID = T1.I_Term_ID
                        LEFT JOIN T_Term_Eval_Strategy G ON G.I_Term_ID = T2.I_Term_ID
                                                            AND G.I_Status = 1
                                                            AND T2.I_Status = 1
                        LEFT JOIN T_Exam_Component_Master H ON H.I_Exam_Component_ID = G.I_Exam_Component_ID
                                                              AND H.I_Status = 1
                        LEFT JOIN EXAMINATION.T_Batch_Exam_Map I ON I.I_Batch_ID = C.I_Batch_ID
                                                              AND I.I_Exam_Component_ID = H.I_Exam_Component_ID
                                                              AND I.I_Term_ID = T2.I_Term_ID
                        LEFT JOIN EXAMINATION.T_Student_Marks J ON J.I_Batch_Exam_ID = I.I_Batch_Exam_ID
                                                              AND A.I_Student_Detail_ID = J.I_Student_Detail_ID
                        INNER JOIN T_Enquiry_Regn_Detail K ON A.I_Enquiry_Regn_ID = K.I_Enquiry_Regn_ID
                WHERE   E.I_Center_ID IN (
                        SELECT  centerID
                        FROM    [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) )
--AND
--T2.I_Term_ID=ISNULL(@iTermID,T2.I_Term_ID)
                        AND ( J.Dt_Exam_Date BETWEEN DATEADD(dd, -1, @dtstart)
                                             AND     DATEADD(dd, 1,
                                                             @dtExamDate) )
                        AND C.I_Batch_ID IN (
                        SELECT  BatchID.Val
                        FROM    dbo.fnString2Rows(@iBatchID, ',') AS BatchID )


 --'2013-07-10'-- BETWEEN @dtStart AND @dtEnd

--AND
--C.I_Batch_ID=32
GROUP BY                D.I_Centre_ID ,
                        S_Center_Name ,
                        S_Course_Name ,
                        C.I_Batch_ID ,
                        C.S_Batch_Name ,
                        A.I_Student_Detail_ID ,
                        S_Student_ID ,
                        A.S_First_Name + ' ' + A.S_Middle_Name + ' '
                        + A.S_Last_Name ,
                        A.I_RollNo ,
                        A.S_Mobile_No ,
                        T2.I_Term_ID ,
                        S_Term_Name
                        
-------------------Populate Base Table end-----------------------------
 --SELECT 'Base Table Populated'                       
-------------------Populate Marks Data Start---------------------------                        
        INSERT  INTO #temp2
                ( S_Center_Name ,
                  I_Student_Detail_ID ,
                  I_Term_ID ,
                  I_Batch_ID ,
                  I_Center_ID ,
                  STUDENT_CODE ,
                  NAME ,
                  S_Batch_Name ,
                  Course_Name ,
                  S_Term_Name ,
                  S_Mobile_No ,
                  I_RollNo ,
                  Category ,
                  MARKS_OBTAINED ,
                  FULL_MARKS ,
                  PERCENTAGE 
                )
                SELECT  E.S_Center_Name ,
                        A.I_Student_Detail_ID ,
			--S_Student_Photo,
                        T2.I_Term_ID ,
                        C.I_Batch_ID ,
                        D.I_Centre_Id ,
                        S_Student_ID AS STUDENT_CODE ,
                        A.S_First_Name + ' ' + A.S_Middle_Name + ' '
                        + A.S_Last_Name AS NAME ,
                        c.S_Batch_Name ,
                        S_Course_Name ,
                        S_Term_Name ,
			--S_Component_Name,
                        A.S_Mobile_No ,
                        A.I_RollNo AS I_RollNo ,
                        'Monthly Test Score' AS Category ,
                        SUM(ISNULL(J.I_Exam_Total, 0)) / 1.00 AS MARKS_OBTAINED ,
                        SUM(G.I_TotMarks) AS FULL_MARKS ,
                        ( SUM(ISNULL(CAST(J.I_Exam_Total AS DECIMAL), 0))
                          / SUM(CAST(G.I_TotMarks AS DECIMAL)) ) * 100 AS 'PERCENTAGE'
                FROM    T_Student_Detail A
                        INNER JOIN T_Student_Batch_Details B ON A.I_Student_Detail_ID = B.I_Student_ID
                                                              AND ( B.I_Status = 1
                                                              OR B.I_Status = 2
                                                              )
                        INNER JOIN T_Student_Batch_Master C ON C.I_Batch_ID = B.I_Batch_ID
                        INNER JOIN T_Center_Batch_Details D ON D.I_Batch_ID = C.I_Batch_ID
                        INNER JOIN T_Center_Hierarchy_Name_Details E ON E.I_Center_ID = D.I_Centre_Id
                        INNER JOIN T_Course_Master F ON F.I_Course_ID = C.I_Course_ID
                        INNER JOIN T_Term_Course_Map T1 ON T1.I_Course_ID = F.I_Course_ID
                        INNER JOIN T_Term_Master T2 ON T2.I_Term_ID = T1.I_Term_ID
                        LEFT JOIN T_Term_Eval_Strategy G ON G.I_Term_ID = T2.I_Term_ID
                                                            AND G.I_Status = 1
                                                            AND T2.I_Status = 1
                        LEFT JOIN T_Exam_Component_Master H ON H.I_Exam_Component_ID = G.I_Exam_Component_ID
                                                              AND H.I_Status = 1
                        LEFT JOIN EXAMINATION.T_Batch_Exam_Map I ON I.I_Batch_ID = C.I_Batch_ID
                                                              AND I.I_Exam_Component_ID = H.I_Exam_Component_ID
                                                              AND I.I_Term_ID = T2.I_Term_ID
                        LEFT JOIN EXAMINATION.T_Student_Marks J ON J.I_Batch_Exam_ID = I.I_Batch_Exam_ID
                                                              AND A.I_Student_Detail_ID = J.I_Student_Detail_ID
                        INNER JOIN T_Enquiry_Regn_Detail K ON A.I_Enquiry_Regn_ID = K.I_Enquiry_Regn_ID
                WHERE   E.I_Center_ID IN (
                        SELECT  centerID
                        FROM    [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) )
--AND
--T2.I_Term_ID=ISNULL(@iTermID,T2.I_Term_ID)
                        AND ( J.Dt_Exam_Date BETWEEN DATEADD(dd, -1, @dtstart)
                                             AND     DATEADD(dd, 1,
                                                             @dtExamDate) )
                        AND C.I_Batch_ID IN (
                        SELECT  BatchID.Val
                        FROM    dbo.fnString2Rows(@iBatchID, ',') AS BatchID )


 --'2013-07-10'-- BETWEEN @dtStart AND @dtEnd

--AND
--C.I_Batch_ID=32
GROUP BY                D.I_Centre_ID ,
                        S_Center_Name ,
                        S_Course_Name ,
                        C.I_Batch_ID ,
                        C.S_Batch_Name ,
                        A.I_Student_Detail_ID ,
                        S_Student_ID ,
                        A.S_First_Name + ' ' + A.S_Middle_Name + ' '
                        + A.S_Last_Name ,
                        A.I_RollNo ,
                        A.S_Mobile_No ,
                        T2.I_Term_ID ,
                        S_Term_Name
                        
  -- SELECT 'Final Table Populated'                     
                        SELECT * FROM #temp2
                        
                        
                        END
                        
                        ELSE
                        
                        BEGIN
                        	-------------------Create temporary tables start---------------------------
      --  CREATE TABLE #temp1
      --      (
      --        S_Center_Name VARCHAR(100) ,
      --        I_Student_Detail_ID INT ,
      --        I_Term_ID INT ,
      --        I_Batch_ID INT ,
      --        I_Center_ID INT ,
      --        STUDENT_CODE VARCHAR(100) ,
      --        NAME VARCHAR(100) ,
      --        S_Batch_Name VARCHAR(100) ,
      --        Course_Name VARCHAR(100) ,
      --        S_Term_Name VARCHAR(100) ,
      --        S_Component_Name VARCHAR(100) ,
      --        S_Course_Name VARCHAR(100) ,
      --        MARKS_OBTAINED REAL ,
      --        FULL_MARKS INT ,
      --        PERCENTAGE REAL ,
      --        Category VARCHAR(MAX) ,
      --        RankCategory VARCHAR(MAX) ,
      --        RankNo INT ,
      --        Total_Percentage REAL ,
      --        S_Mobile_No VARCHAR(100) ,
      --        I_RollNo INT ,
      --        Class_Scheduled INT ,
      --        Class_Attended INT ,
      --        Homework_Assigned INT
		    ----Homework_Submitted INT,
		    ----S_Photo VARCHAR(100),
		    ----Highest_Marks INT
      --      )

      --  CREATE TABLE #temp2
      --      (
      --        S_Center_Name VARCHAR(100) ,
      --        I_Student_Detail_ID INT ,
      --        I_Term_ID INT ,
      --        I_Batch_ID INT ,
      --        I_Center_ID INT ,
      --        STUDENT_CODE VARCHAR(100) ,
      --        NAME VARCHAR(100) ,
      --        S_Batch_Name VARCHAR(100) ,
      --        Course_Name VARCHAR(100) ,
      --        S_Term_Name VARCHAR(100) ,
      --        S_Component_Name VARCHAR(100) ,
      --        S_Course_Name VARCHAR(100) ,
      --        MARKS_OBTAINED REAL ,
      --        FULL_MARKS INT ,
      --        PERCENTAGE REAL ,
      --        Category VARCHAR(MAX) ,
      --        RankCategory VARCHAR(MAX) ,
      --        RankNo INT ,
      --        Total_Percentage REAL ,
      --        S_Mobile_No VARCHAR(100) ,
      --        I_RollNo INT ,
      --        Class_Scheduled INT ,
      --        Class_Attended INT ,
      --        Homework_Assigned INT ,
      --        Homework_Submitted INT ,
      --        MathTeacher VARCHAR(MAX) ,
      --        EnglishTeacher VARCHAR(MAX) ,
      --        GITeacher VARCHAR(MAX) ,
      --        Mentor VARCHAR(MAX) ,
      --        HistBatchStrength INT ,
      --        CurrBatchStrength INT ,
      --        BatchDuration INT ,
      --        Board VARCHAR(MAX) ,
      --        Contact VARCHAR(MAX)
		    --Homework_Submitted INT,
		    --S_Photo VARCHAR(100),
		    --Highest_Marks INT
            --)
            
-------------------Create temporary tables end---------------------------            
            
-------------------Populate Base Table start-----------------------------            
        INSERT  INTO #temp1
                ( S_Center_Name ,
                  I_Student_Detail_ID ,
                  I_Term_ID ,
                  I_Batch_ID ,
                  I_Center_ID ,
                  STUDENT_CODE ,
                  NAME ,
                  S_Batch_Name ,
                  Course_Name ,
                  S_Term_Name ,
                  S_Mobile_No ,
                  I_RollNo ,
                  Category ,
                  MARKS_OBTAINED ,
                  FULL_MARKS ,
                  PERCENTAGE 
                )
                SELECT  E.S_Center_Name ,
                        A.I_Student_Detail_ID ,
			--S_Student_Photo,
                        T2.I_Term_ID ,
                        C.I_Batch_ID ,
                        D.I_Centre_Id ,
                        S_Student_ID AS STUDENT_CODE ,
                        A.S_First_Name + ' ' + A.S_Middle_Name + ' '
                        + A.S_Last_Name AS NAME ,
                        c.S_Batch_Name ,
                        S_Course_Name ,
                        S_Term_Name ,
			--S_Component_Name,
                        A.S_Mobile_No ,
                       A.I_RollNo AS I_RollNo ,
                        'Monthly Test Score' AS Category ,
                        SUM(ISNULL(J.I_Exam_Total, 0)) / 1.00 AS MARKS_OBTAINED ,
                        SUM(G.I_TotMarks) AS FULL_MARKS ,
                        ( SUM(ISNULL(CAST(J.I_Exam_Total AS DECIMAL), 0))
                          / SUM(CAST(G.I_TotMarks AS DECIMAL)) ) * 100 AS 'PERCENTAGE'
                FROM    T_Student_Detail A
                        INNER JOIN T_Student_Batch_Details B ON A.I_Student_Detail_ID = B.I_Student_ID
                                                              AND ( B.I_Status = 1
                                                              OR B.I_Status = 2
                                                              )
                        INNER JOIN T_Student_Batch_Master C ON C.I_Batch_ID = B.I_Batch_ID
                        INNER JOIN T_Center_Batch_Details D ON D.I_Batch_ID = C.I_Batch_ID
                        INNER JOIN T_Center_Hierarchy_Name_Details E ON E.I_Center_ID = D.I_Centre_Id
                        INNER JOIN T_Course_Master F ON F.I_Course_ID = C.I_Course_ID
                        INNER JOIN T_Term_Course_Map T1 ON T1.I_Course_ID = F.I_Course_ID
                        INNER JOIN T_Term_Master T2 ON T2.I_Term_ID = T1.I_Term_ID
                        LEFT JOIN T_Term_Eval_Strategy G ON G.I_Term_ID = T2.I_Term_ID
                                                            AND G.I_Status = 1
                                                            AND T2.I_Status = 1
                        LEFT JOIN T_Exam_Component_Master H ON H.I_Exam_Component_ID = G.I_Exam_Component_ID
                                                              AND H.I_Status = 1
                        LEFT JOIN EXAMINATION.T_Batch_Exam_Map I ON I.I_Batch_ID = C.I_Batch_ID
                                                              AND I.I_Exam_Component_ID = H.I_Exam_Component_ID
                                                              AND I.I_Term_ID = T2.I_Term_ID
                        LEFT JOIN EXAMINATION.T_Student_Marks J ON J.I_Batch_Exam_ID = I.I_Batch_Exam_ID
                                                              AND A.I_Student_Detail_ID = J.I_Student_Detail_ID
                        INNER JOIN T_Enquiry_Regn_Detail K ON A.I_Enquiry_Regn_ID = K.I_Enquiry_Regn_ID
                WHERE   E.I_Center_ID IN (
                        SELECT  centerID
                        FROM    [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) )
--AND
--T2.I_Term_ID=ISNULL(@iTermID,T2.I_Term_ID)
                        AND ( J.Dt_Exam_Date>=DATEADD(dd, 0, @dtstart)
                                             AND J.Dt_Exam_Date<DATEADD(dd, 1,
                                                             @dtExamDate) )
                        --AND C.I_Batch_ID IN (
                        --SELECT  BatchID.Val
                        --FROM    dbo.fnString2Rows(@iBatchID, ',') AS BatchID )


 --'2013-07-10'-- BETWEEN @dtStart AND @dtEnd

--AND
--C.I_Batch_ID=32
GROUP BY                D.I_Centre_ID ,
                        S_Center_Name ,
                        S_Course_Name ,
                        C.I_Batch_ID ,
                        C.S_Batch_Name ,
                        A.I_Student_Detail_ID ,
                        S_Student_ID ,
                        A.S_First_Name + ' ' + A.S_Middle_Name + ' '
                        + A.S_Last_Name ,
                        A.I_RollNo ,
                        A.S_Mobile_No ,
                        T2.I_Term_ID ,
                        S_Term_Name
                        
-------------------Populate Base Table end-----------------------------
                        
-------------------Populate Marks Data Start---------------------------                        
        INSERT  INTO #temp2
                ( S_Center_Name ,
                  I_Student_Detail_ID ,
                  I_Term_ID ,
                  I_Batch_ID ,
                  I_Center_ID ,
                  STUDENT_CODE ,
                  NAME ,
                  S_Batch_Name ,
                  Course_Name ,
                  S_Term_Name ,
                  S_Mobile_No ,
                  I_RollNo ,
                  Category ,
                  MARKS_OBTAINED ,
                  FULL_MARKS ,
                  PERCENTAGE 
                )
                SELECT  E.S_Center_Name ,
                        A.I_Student_Detail_ID ,
			--S_Student_Photo,
                        T2.I_Term_ID ,
                        C.I_Batch_ID ,
                        D.I_Centre_Id ,
                        S_Student_ID AS STUDENT_CODE ,
                        A.S_First_Name + ' ' + A.S_Middle_Name + ' '
                        + A.S_Last_Name AS NAME ,
                        c.S_Batch_Name ,
                        S_Course_Name ,
                        S_Term_Name ,
			--S_Component_Name,
                        A.S_Mobile_No ,
                        A.I_RollNo AS I_RollNo ,
                        'Monthly Test Score' AS Category ,
                        SUM(ISNULL(J.I_Exam_Total, 0)) / 1.00 AS MARKS_OBTAINED ,
                        SUM(G.I_TotMarks) AS FULL_MARKS ,
                        ( SUM(ISNULL(CAST(J.I_Exam_Total AS DECIMAL), 0))
                          / SUM(CAST(G.I_TotMarks AS DECIMAL)) ) * 100 AS 'PERCENTAGE'
                FROM    T_Student_Detail A
                        INNER JOIN T_Student_Batch_Details B ON A.I_Student_Detail_ID = B.I_Student_ID
                                                              AND ( B.I_Status = 1
                                                              OR B.I_Status = 2
                                                              )
                        INNER JOIN T_Student_Batch_Master C ON C.I_Batch_ID = B.I_Batch_ID
                        INNER JOIN T_Center_Batch_Details D ON D.I_Batch_ID = C.I_Batch_ID
                        INNER JOIN T_Center_Hierarchy_Name_Details E ON E.I_Center_ID = D.I_Centre_Id
                        INNER JOIN T_Course_Master F ON F.I_Course_ID = C.I_Course_ID
                        INNER JOIN T_Term_Course_Map T1 ON T1.I_Course_ID = F.I_Course_ID
                        INNER JOIN T_Term_Master T2 ON T2.I_Term_ID = T1.I_Term_ID
                        LEFT JOIN T_Term_Eval_Strategy G ON G.I_Term_ID = T2.I_Term_ID
                                                            AND G.I_Status = 1
                                                            AND T2.I_Status = 1
                        LEFT JOIN T_Exam_Component_Master H ON H.I_Exam_Component_ID = G.I_Exam_Component_ID
                                                              AND H.I_Status = 1
                        LEFT JOIN EXAMINATION.T_Batch_Exam_Map I ON I.I_Batch_ID = C.I_Batch_ID
                                                              AND I.I_Exam_Component_ID = H.I_Exam_Component_ID
                                                              AND I.I_Term_ID = T2.I_Term_ID
                        LEFT JOIN EXAMINATION.T_Student_Marks J ON J.I_Batch_Exam_ID = I.I_Batch_Exam_ID
                                                              AND A.I_Student_Detail_ID = J.I_Student_Detail_ID
                        INNER JOIN T_Enquiry_Regn_Detail K ON A.I_Enquiry_Regn_ID = K.I_Enquiry_Regn_ID
                WHERE   E.I_Center_ID IN (
                        SELECT  centerID
                        FROM    [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) )
--AND
--T2.I_Term_ID=ISNULL(@iTermID,T2.I_Term_ID)
                        AND ( J.Dt_Exam_Date>=DATEADD(dd, 0, @dtstart)
                                             AND J.Dt_Exam_Date<DATEADD(dd, 1,
                                                             @dtExamDate) )
                        --AND C.I_Batch_ID IN (
                        --SELECT  BatchID.Val
                        --FROM    dbo.fnString2Rows(@iBatchID, ',') AS BatchID )


 --'2013-07-10'-- BETWEEN @dtStart AND @dtEnd

--AND
--C.I_Batch_ID=32
GROUP BY                D.I_Centre_ID ,
                        S_Center_Name ,
                        S_Course_Name ,
                        C.I_Batch_ID ,
                        C.S_Batch_Name ,
                        A.I_Student_Detail_ID ,
                        S_Student_ID ,
                        A.S_First_Name + ' ' + A.S_Middle_Name + ' '
                        + A.S_Last_Name ,
                        A.I_RollNo ,
                        A.S_Mobile_No ,
                        T2.I_Term_ID ,
                        S_Term_Name
 --OPTION(RECOMPILE);                       
                        
                        SELECT * FROM #temp2
                        END
                        
                       

END
