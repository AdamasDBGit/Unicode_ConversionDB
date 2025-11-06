CREATE PROCEDURE [REPORT].[uspGetAISAggregateInDescOrder] 
    ( 
      @sHierarchyList VARCHAR(MAX) , 
      @iBrandID INT ,  
      @iTermID INT, 
      @iBatchID INT 
    ) 
AS 
    BEGIN
    
		select H.S_Student_ID as 'Student ID', D.S_Batch_Name, H.S_First_Name + ' ' +H.S_Middle_Name + ' ' + H.S_Last_Name as 'Student Name', SUM(ROUND(ISNULL(I_Exam_Total,0), 0)) as 'Aggregate Marks'
		from EXAMINATION.T_Student_Marks A
		inner join EXAMINATION.T_Batch_Exam_Map B on B.I_Batch_Exam_ID=A.I_Batch_Exam_ID
		inner join T_Student_Detail H on H.I_Student_Detail_ID = A.I_Student_Detail_ID
		inner join T_Student_Batch_Details C on C.I_Batch_ID=B.I_Batch_ID and C.I_Student_ID=A.I_Student_Detail_ID
		inner join T_Student_Batch_Master D on D.I_Batch_ID=B.I_Batch_ID
		INNER JOIN T_Module_Term_Map E ON B.I_Module_ID = E.I_Module_ID AND B.I_Term_ID = E.I_Term_ID AND E.I_Status = 1  
		INNER JOIN T_Module_Eval_Strategy F ON F.I_Module_ID = B.I_Module_ID AND F.I_Term_ID = B.I_Term_ID AND F.I_Exam_Component_ID = B.I_Exam_Component_ID AND F.I_Status = 1 
		INNER JOIN dbo.T_Exam_Component_Master G ON B.I_Exam_Component_ID = G.I_Exam_Component_ID 
		where C.I_Status in (1,2)
		and 
		B.I_Batch_ID=@iBatchID and E.I_Term_ID=@iTermID and G.I_Exam_Component_ID in (51,
		5,
		6,
		7,
		8,
		9,
		10,
		11,
		12,
		13,
		14,
		15,
		16,
		17,
		18,
		19,
		20,
		21,
		22,
		23,
		26,
		27,
		28,
		29,
		30,
		31,
		32,
		33,
		34,
		35,
		36,
		37,
		38,
		39,
		40,
		41,
		42,
		43,
		44) 
		group by D.S_Batch_Name,H.S_Student_ID, H.S_First_Name,H.S_Middle_Name,H.S_Last_Name
		order by [Aggregate Marks] desc
     
	END
