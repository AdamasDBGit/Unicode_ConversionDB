CREATE PROCEDURE [REPORT].[RICE_PROG]
    (
      @dtExamDate DATETIME ,
      @dtstart DATETIME ,
      @sHierarchyList VARCHAR(MAX) ,
      @iBrandID INT ,
--@iCenterID INT,
      @iTermID INT
    )
AS
    BEGIN
    
        DECLARE @dtExDate DATETIME
        DECLARE @dtStDate DATETIME
        DECLARE @HList VARCHAR(MAX)
        DECLARE @BrandiD INT
        DECLARE @TermID INT
    
        SET @dtExDate = @dtExamDate
        SET @dtStDate = @dtstart
        SET @HList = @sHierarchyList
        SET @BrandiD = @iBrandID
        SET @TermID = @iTermID
    
    --PRINT @dtExamDate
    --PRINT @dtstart
    --PRINT @sHierarchyList
    --PRINT @iBrandID
    --PRINT @iTermID


        CREATE TABLE #temp
            (
              S_Center_Name VARCHAR(100) ,
              I_Student_Detail_ID INT ,
              I_Term_ID INT ,
              I_Batch_ID INT ,
              I_Center_ID INT ,
              STUDENT_CODE VARCHAR(100) ,
              NAME VARCHAR(100) ,
              StdAddress VARCHAR(MAX),
              S_Batch_Name VARCHAR(100) ,
              Course_Name VARCHAR(100) ,
              S_Term_Name VARCHAR(100) ,
              S_Component_Name VARCHAR(100) ,
              S_Course_Name VARCHAR(100) ,
              MARKS_OBTAINED REAL ,
              FULL_MARKS INT ,
              PERCENTAGE REAL ,
              Overall_Rank INT ,
              Center_Rank INT ,
              Batch_Rank INT ,
              Total_Percentage REAL ,
              S_Mobile_No VARCHAR(100) ,
              I_RollNo INT ,
              Class_Scheduled INT ,
              Class_Attended INT ,
              Homework_Assigned INT ,
		    --Homework_Submitted INT,
              S_Photo VARCHAR(100) ,
              Highest_Marks INT ,
              ExamCandidateCountBatch INT ,
              ExamCandidateCountCentre INT ,
              ExamCandidateCountOverall INT
            )

        INSERT  INTO #temp
                ( S_Center_Name ,
                  I_Student_Detail_ID ,
                  S_Photo ,
                  I_Term_ID ,
                  I_Batch_ID ,
                  I_Center_ID ,
                  STUDENT_CODE ,
                  NAME ,
                  StdAddress,
                  S_Batch_Name ,
                  S_Course_Name ,
                  S_Term_Name ,
                  S_Component_Name ,
                  S_Mobile_No ,
                  I_RollNo ,
                  MARKS_OBTAINED ,
                  FULL_MARKS ,
                  PERCENTAGE
                )
                SELECT  E.S_Center_Name ,
                        A.I_Student_Detail_ID ,
                        S_Student_Photo ,
                        T2.I_Term_ID ,
                        C.I_Batch_ID ,
                        D.I_Centre_Id ,
                        S_Student_ID AS STUDENT_CODE ,
                        A.S_First_Name + ' ' + A.S_Middle_Name + ' '
                        + A.S_Last_Name AS NAME ,
                        A.S_Curr_Address1+', '+TCM.S_City_Name+', '+TSM.S_State_Name+',Pincode- '+A.S_Curr_Pincode AS StdAddress,
                        C.S_Batch_Name ,
                        S_Course_Name ,
                        S_Term_Name ,
                        S_Component_Name ,
                        A.S_Mobile_No ,
                        ISNULL(B.I_RollNo,A.I_RollNo) AS I_RollNo ,
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
                        INNER JOIN dbo.T_State_Master AS TSM ON TSM.I_State_ID = A.I_Curr_State_ID
                        INNER JOIN dbo.T_City_Master AS TCM ON TCM.I_City_ID = A.I_Curr_City_ID
                WHERE   E.I_Center_ID IN (
                        SELECT  centerID
                        FROM    [dbo].[fnGetCentersForReports](@HList,
                                                              @BrandiD) )
                        AND T2.I_Term_ID = ISNULL(@TermID, T2.I_Term_ID)
                        AND J.Dt_Exam_Date BETWEEN DATEADD(dd, -1, @dtExDate)
                                           AND     DATEADD(dd, 20, @dtExDate)


 --'2013-07-10'-- BETWEEN @dtStart AND @dtEnd

--AND
--C.I_Batch_ID=32
GROUP BY                A.I_Student_Detail_ID ,
                        S_Student_ID ,
                        S_Student_Photo ,
                        C.S_Batch_Name ,
			--S_Course_Desc ,
                        S_Term_Name ,
                        S_Center_Name ,
                        A.S_First_Name ,
                        A.S_Middle_Name ,
                        A.S_Last_Name ,
                        A.S_Curr_Address1+', '+TCM.S_City_Name+', '+TSM.S_State_Name+',Pincode- '+A.S_Curr_Pincode,
                        T2.I_Term_ID ,
                        C.I_Batch_ID ,
                        E.I_Center_ID ,
                        C.I_Batch_ID ,
                        D.I_Centre_Id ,
                        S_Course_Name ,
                        S_Component_Name ,
                        A.S_Mobile_No ,
                        ISNULL(B.I_RollNo,A.I_RollNo)
	--		HAVING

 --SUM(ISNULL(J.I_Exam_Total,0))>0
			--ORDER BY
			--MARKS_OBTAINED DESC
			
			
	--SELECT * FROM #temp;		
		
			
        UPDATE  T2
        SET     T2.Overall_Rank = T1.Overall_Rank ,
                T2.ExamCandidateCountOverall = T1.ExamCandidateCount
        FROM    ( 
        --SELECT    SM.I_Student_Detail_ID ,
 --                           BEM.I_Term_ID ,
 --                           DENSE_RANK() OVER ( PARTITION BY BEM.I_Term_ID ORDER BY SUM(ISNULL(SM.I_Exam_Total,
 --                                                             0)) DESC ) AS [Overall_Rank]
 --                 FROM      EXAMINATION.T_Student_Marks SM
 --                           INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM ON BEM.I_Batch_Exam_ID = SM.I_Batch_Exam_ID
 --                                                             AND SM.Dt_Exam_Date BETWEEN @dtExamDate
 --                                                             AND
 --                                                             DATEADD(dd, 25,
 --                                                             @dtExamDate)
 ---- AND SM.Dt_Crtd_On<'2013-03-31'                   
 --                 GROUP BY  I_Student_Detail_ID ,
 --                           BEM.I_Term_ID
                  SELECT    TR.I_Student_Detail_ID ,
                            TR.I_Term_ID ,
                            TR.Overall_Rank ,
                            TC.ExamCandidateCount
                  FROM      ( SELECT    SM.I_Student_Detail_ID ,
                                        BEM.I_Term_ID ,
                                        DENSE_RANK() OVER ( PARTITION BY BEM.I_Term_ID ORDER BY SUM(ISNULL(SM.I_Exam_Total,
                                                              0)) DESC ) AS [Overall_Rank]
                              FROM      EXAMINATION.T_Student_Marks SM
                                        INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM ON BEM.I_Batch_Exam_ID = SM.I_Batch_Exam_ID
                                                              AND SM.Dt_Exam_Date BETWEEN @dtExamDate
                                                              AND
                                                              DATEADD(dd, 25,
                                                              @dtExamDate)
 --'2013-07-10'-- AND SM.Dt_Crtd_On<'2013-03-31'                   
                              GROUP BY  I_Student_Detail_ID ,
                                        BEM.I_Term_ID
                            ) TR
                            INNER JOIN ( SELECT BEM.I_Term_ID ,
                                                COUNT(DISTINCT SM.I_Student_Detail_ID) AS ExamCandidateCount
                                         FROM   EXAMINATION.T_Student_Marks SM
                                                INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM ON BEM.I_Batch_Exam_ID = SM.I_Batch_Exam_ID
                                                              AND SM.Dt_Exam_Date BETWEEN @dtExamDate
                                                              AND
                                                              DATEADD(dd, 25,
                                                              @dtExamDate)
 --'2013-07-10'-- AND SM.Dt_Crtd_On<'2013-03-31'                   
                                         GROUP BY  --I_Student_Detail_ID ,
                                                BEM.I_Term_ID 
                                       ) TC ON --TC.I_Batch_ID = TR.I_Batch_ID
                           --TC.I_Center_ID = TR.I_Center_ID
                           TC.I_Term_ID = TR.I_Term_ID
                ) T1
                INNER JOIN #temp T2 ON T1.I_Student_Detail_ID = T2.I_Student_Detail_ID
                                       AND T1.I_Term_ID = T2.I_Term_ID
	--SELECT * FROM #temp;
	
        UPDATE  T2
        SET     T2.Center_Rank = T1.Center_Rank ,
                T2.ExamCandidateCountCentre = T1.ExamCandidateCount
        FROM    ( 
        --SELECT    SM.I_Student_Detail_ID ,
   --                         BEM.I_Term_ID ,
   --                         DENSE_RANK() OVER ( PARTITION BY BEM.I_Term_ID,
   --                                             SM.I_Center_ID ORDER BY SUM(ISNULL(SM.I_Exam_Total,
   --                                                           0)) DESC ) AS [Center_Rank]
   --               FROM      EXAMINATION.T_Student_Marks SM
   --                         INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM ON BEM.I_Batch_Exam_ID = SM.I_Batch_Exam_ID
   --                                                           AND SM.Dt_Exam_Date BETWEEN @dtExamDate
   --                                                           AND
   --                                                           DATEADD(dd, 25,
   --                                                           @dtExamDate)
   ----@dtExamDate-- AND SM.Dt_Crtd_On<'2013-03-31'                   
   --               GROUP BY  I_Student_Detail_ID ,
   --                         BEM.I_Term_ID ,
   --                         SM.I_Center_ID
                  SELECT    TR.I_Student_Detail_ID ,
                            TR.I_Term_ID ,
                            TR.Center_Rank ,
                            TC.ExamCandidateCount
                  FROM      ( SELECT    SM.I_Student_Detail_ID ,
                                        BEM.I_Term_ID ,
                                        SM.I_Center_ID ,
                                        DENSE_RANK() OVER ( PARTITION BY BEM.I_Term_ID,
                                                            SM.I_Center_ID ORDER BY SUM(ISNULL(SM.I_Exam_Total,
                                                              0)) DESC ) AS [Center_Rank]
                              FROM      EXAMINATION.T_Student_Marks SM
                                        INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM ON BEM.I_Batch_Exam_ID = SM.I_Batch_Exam_ID
                                                              AND SM.Dt_Exam_Date BETWEEN @dtExamDate
                                                              AND
                                                              DATEADD(dd, 25,
                                                              @dtExamDate)
 --'2013-07-10'-- AND SM.Dt_Crtd_On<'2013-03-31'                   
                              GROUP BY  I_Student_Detail_ID ,
                                        BEM.I_Term_ID ,
                                        SM.I_Center_ID
                            ) TR
                            INNER JOIN ( SELECT BEM.I_Term_ID ,
                                                SM.I_Center_ID ,
                                                COUNT(DISTINCT SM.I_Student_Detail_ID) AS ExamCandidateCount
                                         FROM   EXAMINATION.T_Student_Marks SM
                                                INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM ON BEM.I_Batch_Exam_ID = SM.I_Batch_Exam_ID
                                                              AND SM.Dt_Exam_Date BETWEEN @dtExamDate
                                                              AND
                                                              DATEADD(dd, 25,
                                                              @dtExamDate)
 --'2013-07-10'-- AND SM.Dt_Crtd_On<'2013-03-31'                   
                                         GROUP BY  --I_Student_Detail_ID ,
                                                BEM.I_Term_ID ,
                                                SM.I_Center_ID
                                       ) TC ON --TC.I_Batch_ID = TR.I_Batch_ID
                           TC.I_Center_ID = TR.I_Center_ID
                                               AND TC.I_Term_ID = TR.I_Term_ID
                ) T1
                INNER JOIN #temp T2 ON T1.I_Student_Detail_ID = T2.I_Student_Detail_ID
                                       AND T1.I_Term_ID = T2.I_Term_ID
				
				--SELECT * FROM #temp;
				
				
        UPDATE  T2
        SET     T2.Batch_Rank = T1.Batch_Rank ,
                T2.ExamCandidateCountBatch = T1.ExamCandidateCount
        FROM    ( 
      --SELECT    SM.I_Student_Detail_ID ,
 --                           BEM.I_Term_ID ,
 --                           DENSE_RANK() OVER ( PARTITION BY BEM.I_Term_ID,
 --                                               SM.I_Center_ID, BEM.I_Batch_ID ORDER BY SUM(ISNULL(SM.I_Exam_Total,
 --                                                             0)) DESC ) AS [Batch_Rank]
 --                 FROM      EXAMINATION.T_Student_Marks SM
 --                           INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM ON BEM.I_Batch_Exam_ID = SM.I_Batch_Exam_ID
 --                                                             AND SM.Dt_Exam_Date BETWEEN @dtExamDate
 --                                                             AND
 --                                                             DATEADD(dd, 25,
 --                                                             @dtExamDate)
 ----'2013-07-10'-- AND SM.Dt_Crtd_On<'2013-03-31'                   
 --                 GROUP BY  I_Student_Detail_ID ,
 --                           BEM.I_Term_ID ,
 --                           SM.I_Center_ID ,
 --                           BEM.I_Batch_ID
                  SELECT    TR.I_Student_Detail_ID ,
                            TR.I_Term_ID ,
                            TR.Batch_Rank ,
                            TC.ExamCandidateCount
                  FROM      ( SELECT    SM.I_Student_Detail_ID ,
                                        BEM.I_Term_ID ,
                                        SM.I_Center_ID ,
                                        BEM.I_Batch_ID ,
                                        DENSE_RANK() OVER ( PARTITION BY BEM.I_Term_ID,
                                                            SM.I_Center_ID,
                                                            BEM.I_Batch_ID ORDER BY SUM(ISNULL(SM.I_Exam_Total,
                                                              0)) DESC ) AS [Batch_Rank]
                              FROM      EXAMINATION.T_Student_Marks SM
                                        INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM ON BEM.I_Batch_Exam_ID = SM.I_Batch_Exam_ID
                                                              AND SM.Dt_Exam_Date BETWEEN @dtExamDate
                                                              AND
                                                              DATEADD(dd, 25,
                                                              @dtExamDate)
 --'2013-07-10'-- AND SM.Dt_Crtd_On<'2013-03-31'                   
                              GROUP BY  I_Student_Detail_ID ,
                                        BEM.I_Term_ID ,
                                        SM.I_Center_ID ,
                                        BEM.I_Batch_ID
                            ) TR
                            INNER JOIN ( SELECT BEM.I_Term_ID ,
                                                SM.I_Center_ID ,
                                                BEM.I_Batch_ID ,
                                                COUNT(DISTINCT SM.I_Student_Detail_ID) AS ExamCandidateCount
                                         FROM   EXAMINATION.T_Student_Marks SM
                                                INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM ON BEM.I_Batch_Exam_ID = SM.I_Batch_Exam_ID
                                                              AND SM.Dt_Exam_Date BETWEEN @dtExamDate
                                                              AND
                                                              DATEADD(dd, 25,
                                                              @dtExamDate)
 --'2013-07-10'-- AND SM.Dt_Crtd_On<'2013-03-31'                   
                                         GROUP BY  --I_Student_Detail_ID ,
                                                BEM.I_Term_ID ,
                                                SM.I_Center_ID ,
                                                BEM.I_Batch_ID
                                       ) TC ON TC.I_Batch_ID = TR.I_Batch_ID
                                               AND TC.I_Center_ID = TR.I_Center_ID
                                               AND TC.I_Term_ID = TR.I_Term_ID
                ) T1
                INNER JOIN #temp T2 ON T1.I_Student_Detail_ID = T2.I_Student_Detail_ID
                                       AND T1.I_Term_ID = T2.I_Term_ID
		
		--SELECT * FROM #temp;		
				
				
				
				
        UPDATE  T1
        SET     T1.Class_Scheduled = T3.Scheduled
        FROM    ( SELECT /*T2.I_Term_ID,*/
                            T2.I_Batch_ID ,
                            COUNT(DISTINCT I_TimeTable_ID/*I_Session_ID*/) Scheduled
                  FROM      T_TimeTable_Master T2
                  WHERE     T2.I_Center_ID IN (
                            SELECT  centerID
                            FROM    [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) )
                            AND /*I_Session_ID is not null and*/ T2.Dt_Schedule_Date BETWEEN @dtstart
                                                              AND
                                                              @dtExamDate
                  GROUP BY /*T2.I_Term_ID,*/ T2.I_Batch_ID
                ) T3
                INNER JOIN #temp T1 ON /*T1.I_Term_ID=T3.I_Term_ID AND */T1.I_Batch_ID = T3.I_Batch_ID
				
				--SELECT * FROM #temp;
				
				
        UPDATE  T1
        SET     T1.Class_Attended = T3.Attended
        FROM    ( SELECT /*T2.I_Term_ID,*/
                            T2.I_Student_Detail_ID ,
                            COUNT(DISTINCT I_TimeTable_ID/*I_Session_ID*/) Attended
                  FROM      T_Student_Attendance_Details T2
                  WHERE     T2.I_Centre_Id IN (
                            SELECT  centerID
                            FROM    [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) ) /*and I_Session_ID is not null*/
                            AND T2.I_TimeTable_ID IN (
                            SELECT  I_TimeTable_ID
                            FROM    T_TimeTable_Master
                            WHERE   I_Center_ID IN (
                                    SELECT  centerID
                                    FROM    [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) )
                                    AND Dt_Schedule_Date BETWEEN @dtstart AND @dtExamDate )
                  GROUP BY /*T2.I_Term_ID,*/ T2.I_Student_Detail_ID
                ) T3
                INNER JOIN #temp T1 ON /*T1.I_Term_ID=T3.I_Term_ID AND*/ T1.I_Student_Detail_ID = T3.I_Student_Detail_ID
				--SELECT * FROM #temp;
				
				
				
        UPDATE  T1
        SET     T1.Homework_Assigned = T3.Assigned
        FROM    ( SELECT    T2.I_Batch_ID ,
                            COUNT(DISTINCT I_Homework_ID) Assigned
                  FROM      EXAMINATION.T_Homework_Master T2
                  WHERE     T2.I_Center_ID IN (
                            SELECT  centerID
                            FROM    [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) )
                            AND T2.Dt_Crtd_On >= DATEADD(dd, 1, @dtstart)
                            AND T2.Dt_Crtd_On < @dtExamDate
                            AND T2.I_Status = 1
                  GROUP BY  T2.I_Batch_ID
                ) T3
                INNER JOIN #temp T1 ON T1.I_Batch_ID = T3.I_Batch_ID
				--SELECT * FROM #temp;
	
				--UPDATE  T1
				
				--SET T1.Homework_Submitted = T3.submitted
				
        SELECT  *
        FROM    ( SELECT    hs.I_Student_Detail_ID AS StdID ,
                            ISNULL(COUNT(DISTINCT ( hm.I_Homework_ID )), 0) "Homework_Submitted"
                  FROM      EXAMINATION.T_Homework_Submission hs
                            INNER JOIN EXAMINATION.T_Homework_Master hm ON hs.I_Homework_ID = hm.I_Homework_ID
                  WHERE     hm.I_Center_ID IN (
                            SELECT  centerID
                            FROM    [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) )
                            AND hm.I_Status = 1
                            AND hm.Dt_Crtd_On >= DATEADD(dd, 1, @dtstart)
                            AND hm.Dt_Crtd_On < @dtExamDate
                  GROUP BY  hs.I_Student_Detail_ID
                ) T3
                RIGHT JOIN #temp T1 ON T1.I_Student_Detail_ID = T3.StdID
		
	
--SELECT * FROM #temp;  -- where Homework_Submitted>Homework_Assigned ORDER BY S_Batch_Name,I_RollNo

        UPDATE  #temp
        SET     Class_Attended = Class_Scheduled
        WHERE   Class_Attended > Class_Scheduled--akash
        
        --OPTION(RECOMPILE);
        
        

  		
    END
