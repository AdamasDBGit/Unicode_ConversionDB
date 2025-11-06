
CREATE PROCEDURE [REPORT].[uspMarksTabulation_BKP_NOV2023] --[REPORT].[uspGetStudentsInternalMarks] 746,3,9,17,NULL,1,107,1       
    (
      @iBatchID INT ,
      @iTermID INT ,
      @iModuleID INT ,
      @iExamComponentID INT ,
      @iStudentDetailID INT ,    
      --@iCenterID INT,
      @iBrandId INT ,
      @sHierarchyList VARCHAR(MAX),
      @dCumulativeP DECIMAL(14,2)=NULL
    )
AS 
    BEGIN




        SELECT  S_Course_Name ,
                S_Term_Name ,
                S_Batch_Name ,
                E.S_First_Name + ' ' + E.S_Middle_Name + ' ' + E.S_Last_Name AS NAME ,
                E.I_Student_Detail_ID AS StdID ,
                S_Student_ID ,
                S_First_Name ,
                S_Module_Name ,
                A.I_Exam_Component_ID ,
                S_Component_Name ,
                I_Exam_Total ,
                I_TotMarks--,SUM(I_Exam_Total)
        INTO    #temp1
        FROM    T_Exam_Component_Master A
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
--INNER JOIN T_Student_Batch_Details K ON K.I_Batch_ID=C.I_Batch_ID AND K.I_Status=1
                INNER JOIN T_Student_Batch_Master H ON H.I_Batch_ID = C.I_Batch_ID
                                                       AND H.I_Batch_ID IN (
                                                       SELECT I_Batch_ID
                                                       FROM   T_Student_Batch_Details
                                                       WHERE  I_Batch_ID = ISNULL(@iBatchID,
                                                              I_Batch_ID)
                                                              AND I_Status IN (1,2) )
        WHERE   E.I_Student_Detail_ID = ISNULL(@iStudentDetailID,
                                               E.I_Student_Detail_ID)
                AND H.I_Batch_ID = ISNULL(@iBatchID, C.I_Batch_ID)
                AND B.I_Term_ID = @iTermID--@iTermID
                AND B.I_Module_ID = ISNULL(@iModuleID, B.I_Module_ID)
                AND A.I_Exam_Component_ID = ISNULL(@iExamComponentID,
                                                   A.I_Exam_Component_ID)
                AND D.I_Center_ID IN (
                SELECT  CenterList.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                   CAST(@iBrandID AS INT)) CenterList )
        ORDER BY E.S_First_Name ,
                S_Module_Name

        SELECT  I_Student_Detail_ID ,
                x.I_Exam_Component_ID ,
                SUM(ISNULL(I_Exam_Total, 0)) AS MARKS ,
                CAST(SUM((ISNULL(C.N_Weightage,C.I_TotMarks)/C.I_TotMarks)*ISNULL(B.I_Exam_Total,0)) AS DECIMAL(14,2)) AS WeightedTotal,
                SUM(ISNULL(C.I_TotMarks, 0)) AS TOTAL
        INTO    #temp2
        FROM    T_Exam_Component_Master x
                INNER JOIN T_Module_Eval_Strategy C ON C.I_Exam_Component_ID = x.I_Exam_Component_ID
                                                       AND x.I_Status = 1
                                                       AND C.I_Status = 1
                INNER JOIN EXAMINATION.T_Batch_Exam_Map A ON x.I_Exam_Component_ID = A.I_Exam_Component_ID
                                                             AND x.I_Status = 1
                                                             AND C.I_Module_ID = A.I_Module_ID
                                                             AND A.I_Term_ID = C.I_Term_ID
                                                             AND C.I_Status = 1
                INNER JOIN EXAMINATION.T_Student_Marks B ON A.I_Batch_Exam_ID = B.I_Batch_Exam_ID
        WHERE   A.I_Batch_ID = ISNULL(@iBatchID, A.I_Batch_ID)
                AND A.I_Term_ID = @iTermID
                AND A.I_Module_ID = ISNULL(@iModuleID, A.I_Module_ID)
                AND A.I_Exam_Component_ID = ISNULL(@iExamComponentID,
                                                   A.I_Exam_Component_ID)
                AND B.I_Center_ID IN (
                SELECT  CenterList.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                   CAST(@iBrandID AS INT)) CenterList )
        GROUP BY I_Student_Detail_ID ,
                x.I_Exam_Component_ID



--SELECT C.I_Module_ID,I_Student_Detail_ID,A.I_Exam_Component_ID,SUM(isnull(I_Exam_Total,0)) as SUB_MARKS,SUM(C.I_TotMarks)AS SUB_TOTAL INTO #temp3
-- FROM 
-- T_Exam_Component_Master x inNER JOIN 
-- EXAMINATION.T_Batch_Exam_Map A on x.I_Exam_Component_ID=A.I_Exam_Component_ID AND x.I_Status=1
-- INNER JOIN EXAMINATION.T_Student_Marks B
--ON A.I_Batch_Exam_ID=B.I_Batch_Exam_ID INNER JOIN T_Module_Eval_Strategy C
--ON C.I_Module_ID=A.I_Module_ID AND A.I_Term_ID=C.I_Term_ID AND C.I_Status=1 AND X.I_Exam_Component_ID=C.I_Exam_Component_ID
--WHERE
--A.I_Batch_ID=ISNULL(@iBatchID,A.I_Batch_ID)
--AND
--A.I_Term_ID=@iTermID
--AND A.I_Module_ID= ISNULL(@iModuleID,A.I_Module_ID)
--AND A.I_Exam_Component_ID=ISNULL(@iExamComponentID,A.I_Exam_Component_ID)
--AND B.I_Center_ID IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList) 
--GROUP BY
--C.I_Module_ID,A.I_Exam_Component_ID,I_Student_Detail_ID







        SELECT  A.*,B.MARKS,B.WeightedTotal,ROUND(CAST((ISNULL(@dCumulativeP,0.00)/100.00)*CAST(B.WeightedTotal AS DECIMAL(14,2)) AS DECIMAL(14,2)),0) 
        AS Cumulative
        FROM    #temp1 A
                INNER JOIN #temp2 B ON A.StdID = B.I_Student_Detail_ID
                                       AND A.I_Exam_Component_ID = B.I_Exam_Component_ID
--INNER JOIN #temp3 C ON C.I_Student_Detail_ID=A.StdID



    END



