CREATE PROCEDURE [REPORT].[uspGetAISClassPerformanceReportBasedOnAggregate] 
    ( 
      @sHierarchyList VARCHAR(MAX) , 
      @iBrandID INT ,  
      @iTermID INT, 
      @iBatchID INT 
    ) 
AS 
    BEGIN 
			select ABC.S_Batch_Name,SUM(ABC.Below40) as 'Below 40',SUM(ABC._41to50) as '41-50',SUM(ABC._51to60) as '51-60',SUM(ABC._61to70) as '61-70',SUM(ABC._71to80) as '71-80',SUM(ABC._81to90) as '81-90',SUM(ABC._91to100) as '91-100'  from
			(select (case 
			when (sum(I_Exam_Total)/Sum(I_TotMarks)*100)<=40 then 1
			else 0
			end) as Below40,
			(case 
			when (sum(I_Exam_Total)/Sum(I_TotMarks)*100)>40 and (sum(I_Exam_Total)/Sum(I_TotMarks)*100)<=50 then 1
			else 0
			end) as _41to50,
			(case 
			when (sum(I_Exam_Total)/Sum(I_TotMarks)*100)>50 and (sum(I_Exam_Total)/Sum(I_TotMarks)*100)<=60 then 1
			else 0
			end) as _51to60,
			(case 
			when (sum(I_Exam_Total)/Sum(I_TotMarks)*100)>60 and (sum(I_Exam_Total)/Sum(I_TotMarks)*100)<=70 then 1
			else 0
			end) as _61to70,
			(case 
			when (sum(I_Exam_Total)/Sum(I_TotMarks)*100)>70 and (sum(I_Exam_Total)/Sum(I_TotMarks)*100)<=80 then 1
			else 0
			end) as _71to80,
			(case 
			when (sum(I_Exam_Total)/Sum(I_TotMarks)*100)>80 and (sum(I_Exam_Total)/Sum(I_TotMarks)*100)<=90 then 1
			else 0
			end) as _81to90,
			(case 
			when (sum(I_Exam_Total)/Sum(I_TotMarks)*100)>90 then 1
			else 0
			end) as _91to100
			,H.S_Student_ID as StudentID, 
			D.S_Batch_Name ,
			H.S_First_Name + ' ' +H.S_Middle_Name + ' ' + H.S_Last_Name as StudentName, 
			SUM(ROUND(ISNULL(I_Exam_Total,0), 0)) as AggregateMarks, 
			SUM(ROUND(ISNULL(I_TotMarks,0), 0)) as TotalMarks, 
			(SUM(ROUND(ISNULL(I_Exam_Total,0), 0))/SUM(ROUND(ISNULL(I_TotMarks,0), 0))*100) as Percentage
			
			from EXAMINATION.T_Student_Marks A
			inner join EXAMINATION.T_Batch_Exam_Map B on B.I_Batch_Exam_ID=A.I_Batch_Exam_ID
			inner join T_Student_Detail H on H.I_Student_Detail_ID = A.I_Student_Detail_ID
			inner join T_Student_Batch_Details C on C.I_Batch_ID=B.I_Batch_ID and C.I_Student_ID=A.I_Student_Detail_ID
			inner join T_Student_Batch_Master D on D.I_Batch_ID=B.I_Batch_ID
			INNER JOIN T_Module_Term_Map E ON B.I_Module_ID = E.I_Module_ID AND B.I_Term_ID = E.I_Term_ID AND E.I_Status = 1  
			INNER JOIN T_Module_Eval_Strategy F ON F.I_Module_ID = B.I_Module_ID AND F.I_Term_ID = B.I_Term_ID AND F.I_Exam_Component_ID = B.I_Exam_Component_ID AND F.I_Status = 1 
			INNER JOIN dbo.T_Exam_Component_Master G ON B.I_Exam_Component_ID = G.I_Exam_Component_ID 
			where B.I_Term_ID=@iTermID and B.I_Batch_ID=@iBatchID and C.I_Status in (1,2) and G.I_Exam_Component_ID in (51,
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
			group by  D.S_Batch_Name,H.S_Student_ID, H.S_First_Name,H.S_Middle_Name,H.S_Last_Name
			) 
			ABC
			group by ABC.S_Batch_Name 
	END
