CREATE PROC [REPORT].[uspGetMonthlyExamPerformanceAnalysisReport]
    (
      @dtStartDate DATE ,
      @dtEndDate DATE ,
      @sHierarchyID VARCHAR(MAX) ,
      @iBrandID INT ,
      @iStudentID INT = NULL ,
      @iBatchID INT ,
      @sExamComponentID VARCHAR(MAX) = NULL
    )
AS 
    BEGIN

        CREATE TABLE #examComp ( ExamCompID INT )

        INSERT  INTO #examComp
                ( ExamCompID 
                )
                SELECT  FSR.Val
                FROM    dbo.fnString2Rows(@sExamComponentID, ',') FSR

        IF ( SELECT COUNT(ExamCompID)
             FROM   #examComp EC
           ) = 0 
            BEGIN
                INSERT  INTO #examComp
                        ( ExamCompID 
                        )
                        SELECT  I_Exam_Component_ID
                        FROM    dbo.T_Exam_Component_Master TECM
                        WHERE   I_Brand_ID = @iBrandID
                                AND I_Status = 1

            END

        CREATE TABLE #studentid ( StudentID INT )

        IF @iStudentID IS NULL 
            BEGIN
                INSERT  INTO #studentid
                        ( StudentID 
                        )
                        SELECT  TSD.I_Student_Detail_ID
                        FROM    dbo.T_Student_Detail TSD
                                INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                        WHERE   TSBD.I_Status = 1
                                AND TSBD.I_Batch_ID = @iBatchID 
            END
        ELSE 
            BEGIN
                INSERT  INTO #studentid
                        ( StudentID )
                VALUES  ( @iStudentID  -- StudentID - int
                          )
            END

--SELECT * FROM #studentid S;

--SELECT * FROM #examComp EC;



        SELECT  TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                TSD.I_Student_Detail_ID ,
                TSD.S_Student_ID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TSD.S_Mobile_No,
                TSD.S_Phone_No,
                TTM.I_Term_ID ,
                TTM.S_Term_Name ,
                TSBM.I_Batch_ID ,
                TSBM.S_Batch_Name ,
                TECM.I_Exam_Component_ID ,
                TECM.S_Component_Name ,
                TSM.I_Exam_Total ,
                TTES.I_TotMarks ,
                TECM.S_Component_Name + ' ('
                + CAST(TTES.I_TotMarks AS VARCHAR) + ')' AS ExamTot
        FROM    EXAMINATION.T_Student_Marks TSM
                INNER JOIN EXAMINATION.T_Batch_Exam_Map TBEM ON TSM.I_Batch_Exam_ID = TBEM.I_Batch_Exam_ID
                INNER JOIN dbo.T_Student_Batch_Master TSBM ON TBEM.I_Batch_ID = TSBM.I_Batch_ID
                INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCHND.I_Center_ID = TCBD.I_Centre_Id
                INNER JOIN dbo.T_Student_Detail TSD ON TSM.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                INNER JOIN dbo.T_Term_Master TTM ON TBEM.I_Term_ID = TTM.I_Term_ID
--INNER JOIN dbo.T_Term_Eval_Strategy TTES ON TBEM.I_Exam_Component_ID=TTES.I_Exam_Component_ID
                INNER JOIN dbo.T_Exam_Component_Master TECM ON TBEM.I_Exam_Component_ID = TECM.I_Exam_Component_ID
                INNER JOIN dbo.T_Term_Eval_Strategy TTES ON TECM.I_Exam_Component_ID = TTES.I_Exam_Component_ID
                                                            AND TCM.I_Course_ID = TTES.I_Course_ID
                                                            AND TTM.I_Term_ID = TTES.I_Term_ID
        WHERE   TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyID, @iBrandID) FGCFR )
                AND TSM.Dt_Exam_Date >= @dtStartDate
                AND TSM.Dt_Exam_Date < DATEADD(d,1,@dtEndDate)
                --AND TSBM.I_Batch_ID=@iBatchID
                AND TCM.I_Status = 1
                AND TTM.I_Status = 1
                AND TECM.I_Status = 1
                AND TSD.I_Student_Detail_ID IN ( SELECT S.StudentID
                                                 FROM   #studentid S )
                AND TECM.I_Exam_Component_ID IN ( SELECT    EC.ExamCompID
                                                  FROM      #examComp EC )
                AND TTES.I_Status = 1
        ORDER BY TCHND.I_Center_ID ,
                TSD.I_Student_Detail_ID ,
                TTM.I_Term_ID ,
                TECM.I_Exam_Component_ID
        --END
        
        
    END
