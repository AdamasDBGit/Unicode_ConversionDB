-- EXEC [REPORT].[uspGetExamDistributionReport] '127',109,NULL,'44,33',NULL,'2013-01-01','2013-08-31'
CREATE PROCEDURE [REPORT].[uspGetExamDistributionReport]
    (
      @sHierarchyList VARCHAR(MAX) ,
      @iBrandID INT ,
      @CourseId INT = NULL ,
      @TermId VARCHAR(8000) = NULL ,
      @BatchId VARCHAR(8000) = NULL ,
      @StartDate DATETIME = NULL ,
      @EndDate DATETIME = NULL  
    )
AS 
    BEGIN
        DECLARE @tmpBatch TABLE
            (
              id INT IDENTITY ,
              BatchID INT
            )
   
   
   
        DECLARE @tmpTerm TABLE
            (
              id INT IDENTITY ,
              TermID INT
            ) 
    
    
        IF ( @BatchId IS NULL
             OR @BatchId = ''
           ) 
            BEGIN
                INSERT  INTO @tmpBatch
                        ( BatchID
                        )
                        ( SELECT DISTINCT
                                    I_Batch_ID
                          FROM      EXAMINATION.T_Batch_Exam_Map
                          UNION
                          SELECT DISTINCT
                                    I_batch_ID
                          FROM      T_Center_Batch_Details
                        )
            END
        ELSE 
            BEGIN
                INSERT  INTO @tmpBatch
                        ( BatchID
                        )
                        SELECT  *
                        FROM    [fnSplitter](@BatchId)
            END
    
        IF ( @TermId IS NULL
             OR @TermId = ''
           ) 
            BEGIN
                INSERT  INTO @tmpTerm
                        ( TermID
                        )
                        SELECT DISTINCT
                                I_Term_ID
                        FROM    T_Term_Eval_Strategy
            END
        ELSE 
            BEGIN
                INSERT  INTO @tmpTerm
                        ( TermID
                        )
                        SELECT  *
                        FROM    [fnSplitter](@TermId)
            END
    
    
        DECLARE @tmpCentre TABLE
            (
              id INT IDENTITY ,
              BrandID INT ,
              HierarchyDetailID INT ,
              CenterID INT ,
              CenterCode VARCHAR(250) ,
              CenterName VARCHAR(500)
            )
	
        INSERT  INTO @tmpCentre
                SELECT  *
                FROM    dbo.fnGetCentersForReports(@sHierarchyList, @iBrandID) 
  
  
  
        SELECT  TTES.I_Course_ID ,
                TTES.I_Term_ID ,
                TTES.I_Exam_Component_ID ,
                TTES.I_TotMarks
        INTO    #ExamTotalMarks
        FROM    dbo.T_Term_Eval_Strategy AS TTES
                INNER JOIN @tmpTerm A ON A.TermID = TTES.I_Term_ID
        WHERE   TTES.I_Course_ID = COALESCE(@CourseId, TTES.I_Course_ID)
                AND I_Status = 1
        ORDER BY TTES.I_Course_ID ,
                TTES.I_Term_ID ,
                TTES.I_Exam_Component_ID

 


        SELECT  TCBD.I_Centre_Id ,
                TTES.I_Course_ID ,
                TTES.I_Term_ID ,
                TTES.I_Exam_Component_ID ,
                TBEM.I_Batch_ID ,
                TBEM.I_Batch_Exam_ID ,
                TSM.I_Student_Detail_ID ,
                TTES.I_TotMarks ,
                TSM.I_Exam_Total ,
                CASE WHEN TSM.I_Exam_Total <> 0
                     THEN CONVERT(NUMERIC(5, 2), ROUND(( TSM.I_Exam_Total
                                                         * 100 )
                                                       / TTES.I_TotMarks, 2))
                     ELSE 0
                END AS I_PERCENTAGE
        INTO    #ExamStudentPercentage
        FROM    EXAMINATION.T_Batch_Exam_Map AS TBEM
                INNER JOIN #ExamTotalMarks AS TTES ON TTES.I_Exam_Component_ID = TBEM.I_Exam_Component_ID
                                                      AND TTES.I_Term_ID = TBEM.I_Term_ID
                INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON TBEM.I_Batch_ID = TSBD.I_Batch_ID
                INNER JOIN EXAMINATION.T_Student_Marks AS TSM ON TSM.I_Student_Detail_ID = TSBD.I_Student_ID
                                                              AND TSM.I_Batch_Exam_ID = TBEM.I_Batch_Exam_ID
                INNER JOIN dbo.T_Center_Batch_Details AS TCBD ON TBEM.I_Batch_ID = TCBD.I_Batch_ID
                INNER JOIN @tmpCentre A ON A.CenterID = TCBD.I_Centre_Id
                INNER JOIN @tmpTerm B ON B.TermID = TTES.I_Term_ID
                INNER JOIN @tmpBatch C ON C.BatchID = TBEM.I_Batch_ID
                INNER JOIN @tmpBatch D ON D.BatchID = TSBD.I_Batch_ID
        WHERE   TTES.I_Course_ID = COALESCE(@CourseId, TTES.I_Course_ID)
                AND TBEM.I_Module_ID IS NULL
                AND TSM.Dt_Exam_Date BETWEEN ISNULL(@StartDate,
                                                    TSM.Dt_Exam_Date)
                                     AND     ISNULL(@EndDate, TSM.Dt_Exam_Date)
                AND TSBD.I_Status = 1
        ORDER BY TCBD.I_Centre_Id ,
                TTES.I_Course_ID ,
                TTES.I_Term_ID ,
                TTES.I_Exam_Component_ID ,
                TBEM.I_Batch_ID ,
                TBEM.I_Batch_Exam_ID ,
                TSM.I_Student_Detail_ID


        CREATE TABLE #tblResult
            (
              I_Centre_Id INT ,
              I_Course_ID INT ,
              I_Term_ID VARCHAR(250) ,
              I_Exam_Component_ID VARCHAR(150) ,
              I_Batch_ID INT ,
              I_Batch_Exam_ID INT
            )
            
        INSERT  INTO #tblResult
                SELECT DISTINCT
                        ESP.I_Centre_Id ,
                        ESP.I_Course_ID ,
                        ESP.I_Term_ID ,
                        ESP.I_Exam_Component_ID ,
                        ESP.I_Batch_ID ,
                        ESP.I_Batch_Exam_ID
                FROM    #ExamStudentPercentage AS ESP
                ORDER BY ESP.I_Course_ID ,
                        ESP.I_Term_ID ,
                        ESP.I_Exam_Component_ID ,
                        ESP.I_Batch_ID ,
                        ESP.I_Batch_Exam_ID			
			
        SELECT  TBR.I_Centre_Id ,
                TBR.I_Course_ID ,
                TBR.I_Term_ID ,
                TBR.I_Exam_Component_ID ,
                TBR.I_Batch_ID ,
                TBR.I_Batch_Exam_ID ,
                TCM.S_Center_Name ,
                TCM2.S_Course_Name ,
                TTM.S_Term_Name ,
                TECM.S_Component_Name ,
                TSBM.S_Batch_Name ,
                FN2.instanceChain ,
                ( SELECT    COUNT(1)
                  FROM      #ExamStudentPercentage AS ESP
                  WHERE     ESP.I_Course_ID = TBR.I_Course_ID
                            AND ESP.I_Term_ID = TBR.I_Term_ID
                            AND ESP.I_Exam_Component_ID = TBR.I_Exam_Component_ID
                            AND ESP.I_Batch_ID = TBR.I_Batch_ID
                            AND ESP.I_Batch_Exam_ID = TBR.I_Batch_Exam_ID
                            AND ESP.I_PERCENTAGE < 40
                ) AS NO_LESS_40 ,
                ( SELECT    COUNT(1)
                  FROM      #ExamStudentPercentage AS ESP
                  WHERE     ESP.I_Course_ID = TBR.I_Course_ID
                            AND ESP.I_Term_ID = TBR.I_Term_ID
                            AND ESP.I_Exam_Component_ID = TBR.I_Exam_Component_ID
                            AND ESP.I_Batch_ID = TBR.I_Batch_ID
                            AND ESP.I_Batch_Exam_ID = TBR.I_Batch_Exam_ID
                            AND ESP.I_PERCENTAGE >= 40
                            AND ESP.I_PERCENTAGE < 50
                ) AS NO_LESS_50 ,
                ( SELECT    COUNT(1)
                  FROM      #ExamStudentPercentage AS ESP
                  WHERE     ESP.I_Course_ID = TBR.I_Course_ID
                            AND ESP.I_Term_ID = TBR.I_Term_ID
                            AND ESP.I_Exam_Component_ID = TBR.I_Exam_Component_ID
                            AND ESP.I_Batch_ID = TBR.I_Batch_ID
                            AND ESP.I_Batch_Exam_ID = TBR.I_Batch_Exam_ID
                            AND ESP.I_PERCENTAGE >= 50
                            AND ESP.I_PERCENTAGE < 60
                ) AS NO_LESS_60 ,
                ( SELECT    COUNT(1)
                  FROM      #ExamStudentPercentage AS ESP
                  WHERE     ESP.I_Course_ID = TBR.I_Course_ID
                            AND ESP.I_Term_ID = TBR.I_Term_ID
                            AND ESP.I_Exam_Component_ID = TBR.I_Exam_Component_ID
                            AND ESP.I_Batch_ID = TBR.I_Batch_ID
                            AND ESP.I_Batch_Exam_ID = TBR.I_Batch_Exam_ID
                            AND ESP.I_PERCENTAGE >= 60
                            AND ESP.I_PERCENTAGE < 70
                ) AS NO_LESS_70 ,
                ( SELECT    COUNT(1)
                  FROM      #ExamStudentPercentage AS ESP
                  WHERE     ESP.I_Course_ID = TBR.I_Course_ID
                            AND ESP.I_Term_ID = TBR.I_Term_ID
                            AND ESP.I_Exam_Component_ID = TBR.I_Exam_Component_ID
                            AND ESP.I_Batch_ID = TBR.I_Batch_ID
                            AND ESP.I_Batch_Exam_ID = TBR.I_Batch_Exam_ID
                            AND ESP.I_PERCENTAGE >= 70
                            AND ESP.I_PERCENTAGE < 80
                ) AS NO_LESS_80 ,
                ( SELECT    COUNT(1)
                  FROM      #ExamStudentPercentage AS ESP
                  WHERE     ESP.I_Course_ID = TBR.I_Course_ID
                            AND ESP.I_Term_ID = TBR.I_Term_ID
                            AND ESP.I_Exam_Component_ID = TBR.I_Exam_Component_ID
                            AND ESP.I_Batch_ID = TBR.I_Batch_ID
                            AND ESP.I_Batch_Exam_ID = TBR.I_Batch_Exam_ID
                            AND ESP.I_PERCENTAGE >= 80
                            AND ESP.I_PERCENTAGE < 90
                ) AS NO_LESS_90 ,
                ( SELECT    COUNT(1)
                  FROM      #ExamStudentPercentage AS ESP
                  WHERE     ESP.I_Course_ID = TBR.I_Course_ID
                            AND ESP.I_Term_ID = TBR.I_Term_ID
                            AND ESP.I_Exam_Component_ID = TBR.I_Exam_Component_ID
                            AND ESP.I_Batch_ID = TBR.I_Batch_ID
                            AND ESP.I_Batch_Exam_ID = TBR.I_Batch_Exam_ID
                            AND ESP.I_PERCENTAGE >= 90
                            AND ESP.I_PERCENTAGE < 95
                ) AS NO_LESS_95 ,
                ( SELECT    COUNT(1)
                  FROM      #ExamStudentPercentage AS ESP
                  WHERE     ESP.I_Course_ID = TBR.I_Course_ID
                            AND ESP.I_Term_ID = TBR.I_Term_ID
                            AND ESP.I_Exam_Component_ID = TBR.I_Exam_Component_ID
                            AND ESP.I_Batch_ID = TBR.I_Batch_ID
                            AND ESP.I_Batch_Exam_ID = TBR.I_Batch_Exam_ID
                            AND ESP.I_PERCENTAGE >= 95
                            AND ESP.I_PERCENTAGE <= 100
                ) AS NO_LESS_100 ,
                ( SELECT    COUNT(1)
                  FROM      #ExamStudentPercentage AS ESP
                  WHERE     ESP.I_Course_ID = TBR.I_Course_ID
                            AND ESP.I_Term_ID = TBR.I_Term_ID
                            AND ESP.I_Exam_Component_ID = TBR.I_Exam_Component_ID
                            AND ESP.I_Batch_ID = TBR.I_Batch_ID
                            AND ESP.I_Batch_Exam_ID = TBR.I_Batch_Exam_ID
                ) AS TOTAL_COUNT
        FROM    #tblResult TBR
                INNER JOIN dbo.T_Centre_Master AS TCM ON TBR.I_Centre_Id = TCM.I_Centre_Id
                INNER JOIN dbo.T_Course_Master AS TCM2 ON TCM2.I_Course_ID = TBR.I_Course_ID
                INNER JOIN dbo.T_Term_Master AS TTM ON TBR.I_Term_ID = TTM.I_Term_ID
                INNER JOIN dbo.T_Exam_Component_Master AS TECM ON TECM.I_Exam_Component_ID = TBR.I_Exam_Component_ID
                INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TBR.I_Batch_ID = TSBM.I_Batch_ID
                INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                          @iBrandID) FN1 ON TCM.I_Centre_Id = FN1.CenterID
                INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,
                                                              @iBrandID) FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
        ORDER BY TCM.S_Center_Name ,
                TCM2.S_Course_Name ,
                TTM.S_Term_Name ,
                TECM.S_Component_Name ,
                TSBM.S_Batch_Name

        DROP TABLE #ExamTotalMarks
        DROP TABLE #ExamStudentPercentage
        DROP TABLE #tblResult
  
  
      

    END
