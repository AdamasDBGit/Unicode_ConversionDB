CREATE PROCEDURE [REPORT].[uspGetStudentsInternalMarks] --[REPORT].[uspGetStudentsInternalMarks] 746,3,9,17,NULL,1,107,1           
    (          
      @iBatchID INT ,          
      @iTermID INT ,          
      @iModuleID INT  ,          
      @iExamComponentID INT  ,          
      @iStudentDetailID INT  ,     
      @iBrandId INT,        
   @sHierarchyList VARCHAR(MAX)          
    )          
AS          
    
BEGIN    
    
    
    
    
SELECT  S_Course_Name, S_Batch_Name,E.S_First_Name+' '+E.S_Middle_Name+' '+E.S_Last_Name AS NAME,E.I_Student_Detail_ID AS StdID,S_Student_ID,J.S_First_Name+' '+J.S_Last_Name AS Teacher_Name,S_Module_Name,A.I_Exam_Component_ID,S_Component_Name,I_Exam_Total,I_TotMarks--,SUM(I_Exam_Total)    
    
INTO #temp1    
    
FROM T_Exam_Component_Master A INNER JOIN T_Module_Eval_Strategy B    
ON A.I_Exam_Component_ID=B.I_Exam_Component_ID AND A.I_Status=1    
INNER JOIN EXAMINATION.T_Batch_Exam_Map C ON C.I_Exam_Component_ID =A.I_Exam_Component_ID AND A.I_Status=1 AND B.I_Module_ID=C.I_Module_ID    
INNER JOIN EXAMINATION.T_Student_Marks D ON D.I_Batch_Exam_ID=C.I_Batch_Exam_ID     
INNER JOIN T_Student_Detail E ON E.I_Student_Detail_ID=D.I_Student_Detail_ID    
INNER JOIN T_Module_Master F ON F.I_Module_ID=B.I_Module_ID    
INNER JOIN T_Course_Master G ON G.I_Course_ID=B.I_Course_ID   


LEFT JOIN T_Student_Batch_Master H ON H.I_Batch_ID=C.I_Batch_ID  
--LEFT JOIN T_Center_Batch_Details I ON H.I_Batch_ID=I.I_Batch_ID
LEFT JOIN EXAMINATION.T_Batch_Exam_Faculty_Map K ON K.I_Batch_Exam_ID=C.I_Batch_Exam_ID
LEFT JOIN T_Employee_Dtls J ON J.I_Employee_ID=K.I_Employee_ID  
WHERE     
E.I_Student_Detail_ID =ISNULL(@iStudentDetailID,E.I_Student_Detail_ID)    
AND H.I_Batch_ID =ISNULL(@iBatchID,C.I_Batch_ID)    
AND B.I_Term_ID =@iTermID--@iTermID    
AND B.I_Module_ID= ISNULL(@iModuleID,B.I_Module_ID)    
AND A.I_Exam_Component_ID=ISNULL(@iExamComponentID,A.I_Exam_Component_ID)    
AND D.I_Center_ID IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList)     
    
    
ORDER BY  E.S_First_Name  
    
SELECT I_Student_Detail_ID,SUM(I_Exam_Total) as MARKS,SUM(C.I_TotMarks)AS TOTAL INTO #temp2    
 FROM     
 T_Exam_Component_Master x inNER JOIN     
 EXAMINATION.T_Batch_Exam_Map A on x.I_Exam_Component_ID=A.I_Exam_Component_ID AND x.I_Status=1    
 INNER JOIN EXAMINATION.T_Student_Marks B    
ON A.I_Batch_Exam_ID=B.I_Batch_Exam_ID INNER JOIN T_Module_Eval_Strategy C    
ON C.I_Module_ID=A.I_Module_ID AND A.I_Term_ID=C.I_Term_ID AND C.I_Status=1 AND X.I_Exam_Component_ID=C.I_Exam_Component_ID    
WHERE    
A.I_Batch_ID=ISNULL(@iBatchID,A.I_Batch_ID)    
AND    
A.I_Term_ID=@iTermID    
AND A.I_Module_ID= ISNULL(@iModuleID,A.I_Module_ID)    
AND A.I_Exam_Component_ID=ISNULL(@iExamComponentID,A.I_Exam_Component_ID)    
AND B.I_Center_ID IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList)     
GROUP BY    
I_Student_Detail_ID    
    
    
    
SELECT * FROM #temp1 A INNER JOIN #temp2 B ON  A.StdID=B.I_Student_Detail_ID  
ORDER BY A.NAME ASC  
    
    
    
END
