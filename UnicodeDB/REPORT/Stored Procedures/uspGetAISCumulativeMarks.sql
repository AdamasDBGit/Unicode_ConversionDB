      CREATE PROCEDURE [REPORT].[uspGetAISCumulativeMarks]   --exec REPORT.uspGetAISCumulativeMarks 9197,null,2771,107,'53'
        (
          @iBatchID INT ,
          @iExamComponentID INT = NULL ,
          @iStudentDetailID INT = NULL ,
          @iBrandId INT ,
          @sHierarchyList VARCHAR(MAX)
        )
      AS
        BEGIN
      
      --DECLARE @iBatchID INT=9215
      --DECLARE @iExamComponentID INT =NULL
      --DECLARE @iStudentDetailID INT=NULL     
      --DECLARE @iBrandId INT =107
      --DECLARE @sHierarchyList VARCHAR(MAX)='53'
            SELECT  T2.* ,
                    CASE WHEN T2.I_Sequence = 1
                         THEN ROUND(CAST(( 40.00 / 100.00 ) * T2.TermwiseTotal AS DECIMAL(14,2)),0)
                         WHEN T2.I_Sequence = 2
                         THEN ROUND(CAST(( 60.00 / 100.00 ) * T2.TermwiseTotal AS DECIMAL(14,2)),0)
                    END AS CumulativeMarks ,
                    SUM(CASE WHEN T2.I_Sequence = 1
                         THEN ROUND(CAST(( 40.00 / 100.00 ) * T2.TermwiseTotal AS DECIMAL(14,2)),0)
                         WHEN T2.I_Sequence = 2
                         THEN ROUND(CAST(( 60.00 / 100.00 ) * T2.TermwiseTotal AS DECIMAL(14,2)),0)
                        END) AS CumulativeTotal
            FROM    ( SELECT    T1.S_Course_Name ,
                                T1.S_Term_Name ,
                                T1.I_Sequence ,
                                T1.S_Batch_Name ,
                                T1.NAME ,
                                T1.StdID ,
                                T1.S_Student_ID ,
                                T1.S_First_Name ,
                                T1.I_Exam_Component_ID ,
                                T1.S_Component_Name ,
                                SUM(ROUND(T1.WeightedTotal,0)) AS TermwiseTotal
                      FROM      ( SELECT    S_Course_Name ,
                                            S_Term_Name ,
                                            TTCM.I_Sequence ,
                                            S_Batch_Name ,
                                            E.S_First_Name + ' '
                                            + E.S_Middle_Name + ' '
                                            + E.S_Last_Name AS NAME ,
                                            E.I_Student_Detail_ID AS StdID ,
                                            S_Student_ID ,
                                            S_First_Name ,
                                            S_Module_Name ,
                                            A.I_Exam_Component_ID ,
                                            S_Component_Name ,
                                            I_Exam_Total ,
                                            CAST(SUM(( ISNULL(B.N_Weightage,
                                                              B.I_TotMarks)
                                                       / B.I_TotMarks )
                                                     * ISNULL(ROUND(D.I_Exam_Total,0),
                                                              0)) AS DECIMAL(14,
                                                              2)) AS WeightedTotal
                                  FROM      T_Exam_Component_Master A
                                            INNER JOIN T_Module_Eval_Strategy B ON A.I_Exam_Component_ID = B.I_Exam_Component_ID
                                                              AND A.I_Status = 1
                                                              AND B.I_Status = 1
                                            INNER JOIN EXAMINATION.T_Batch_Exam_Map C ON C.I_Exam_Component_ID = A.I_Exam_Component_ID
                                                              AND A.I_Status = 1
                                                              AND B.I_Module_ID = C.I_Module_ID
                                                              AND B.I_Term_ID = C.I_Term_ID
                                                              AND C.I_Status = 1
                                            INNER JOIN EXAMINATION.T_Student_Marks D ON D.I_Batch_Exam_ID = C.I_Batch_Exam_ID
                                            INNER JOIN T_Student_Detail E ON E.I_Student_Detail_ID = D.I_Student_Detail_ID
                                            INNER JOIN T_Module_Master F ON F.I_Module_ID = B.I_Module_ID
                                            INNER JOIN T_Course_Master G ON G.I_Course_ID = B.I_Course_ID
                                            INNER JOIN T_Term_Master I ON I.I_Term_ID = C.I_Term_ID
                                            INNER JOIN T_Student_Batch_Master H ON H.I_Batch_ID = C.I_Batch_ID
                                            INNER JOIN dbo.T_Term_Course_Map
                                            AS TTCM ON TTCM.I_Term_ID = I.I_Term_ID
                                                       AND TTCM.I_Course_ID = H.I_Course_ID
                                  WHERE     E.I_Student_Detail_ID = ISNULL(@iStudentDetailID,
                                                              E.I_Student_Detail_ID)
                                            AND H.I_Batch_ID = @iBatchID
                                            AND A.I_Exam_Component_ID = ISNULL(@iExamComponentID,
                                                              A.I_Exam_Component_ID)
                                            AND A.I_Exam_Component_ID NOT IN (59,25)                  
                                            AND D.I_Center_ID IN (
                                            SELECT  CenterList.centerID
                                            FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                              CAST(@iBrandId AS INT)) CenterList )
                                  GROUP BY  S_Course_Name ,
                                            S_Term_Name ,
                                            TTCM.I_Sequence ,
                                            S_Batch_Name ,
                                            E.S_First_Name + ' '
                                            + E.S_Middle_Name + ' '
                                            + E.S_Last_Name ,
                                            E.I_Student_Detail_ID ,
                                            S_Student_ID ,
                                            S_First_Name ,
                                            S_Module_Name ,
                                            A.I_Exam_Component_ID ,
                                            S_Component_Name ,
                                            I_Exam_Total
                                ) AS T1
                      GROUP BY  T1.S_Course_Name ,
                                T1.S_Term_Name ,
                                T1.I_Sequence ,
                                T1.S_Batch_Name ,
                                T1.NAME ,
                                T1.StdID ,
                                T1.S_Student_ID ,
                                T1.S_First_Name ,
                                T1.I_Exam_Component_ID ,
                                T1.S_Component_Name
                    ) T2
                    
                    GROUP BY T2.S_Course_Name ,
                                T2.S_Term_Name ,
                                T2.I_Sequence ,
                                T2.S_Batch_Name ,
                                T2.NAME ,
                                T2.StdID ,
                                T2.S_Student_ID ,
                                T2.S_First_Name ,
                                T2.I_Exam_Component_ID ,
                                T2.S_Component_Name ,
                                T2.TermwiseTotal
                
                
        END
