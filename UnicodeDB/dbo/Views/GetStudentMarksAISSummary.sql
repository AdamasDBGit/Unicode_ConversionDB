



CREATE VIEW [dbo].[GetStudentMarksAISSummary]
AS

select T1.S_Brand_Name,T1.S_Course_Name,T1.S_Batch_Name,T1.S_Term_Name,--T1.S_Module_Name,
T1.S_Component_Name,T1.MarksPercentage,
COUNT(DISTINCT T1.I_Student_Detail_ID) as StudentCount 
from
(
	select TCHND.I_Brand_ID,TCHND.S_Brand_Name,TCM.I_Course_ID,TCM.S_Course_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Name,TTM.I_Term_ID,TTM.S_Term_Name,
	--TMM.I_Module_ID,TMM.S_Module_Name,
	TECM.I_Exam_Component_ID,TECM.S_Component_Name,
	TSD.I_Student_Detail_ID,TSD.S_Student_ID,SUM(ISNULL(TSM.I_Exam_Total,0)) as MarksObtained,SUM(TMES.I_TotMarks) as Totalmarks,SUM(TMES.N_Weightage) as Weightage,
	ROUND((CAST(SUM(TMES.N_Weightage) as DECIMAL(14,2))/CAST(SUM(TMES.I_TotMarks) as DECIMAL(14,2)))*CAST(SUM(ISNULL(TSM.I_Exam_Total,0)) as DECIMAL(14,2)),0) as ActualMarksObtained,
	ROUND((ROUND((CAST(SUM(TMES.N_Weightage) as DECIMAL(14,2))/CAST(SUM(TMES.I_TotMarks) as DECIMAL(14,2)))*CAST(SUM(ISNULL(TSM.I_Exam_Total,0)) as DECIMAL(14,2)),0)*100)/CAST(SUM(TMES.N_Weightage) as DECIMAL(14,2)),0) as MarksPercentage
	from EXAMINATION.T_Student_Marks TSM
	inner join EXAMINATION.T_Batch_Exam_Map TBEM on TSM.I_Batch_Exam_ID=TBEM.I_Batch_Exam_ID and TBEM.I_Status=1
	inner join T_Student_Batch_Master TSBM on TBEM.I_Batch_ID=TSBM.I_Batch_ID
	inner join T_Term_Master TTM on TBEM.I_Term_ID=TTM.I_Term_ID
	inner join T_Module_Master TMM on TBEM.I_Module_ID=TMM.I_Module_ID
	inner join T_Exam_Component_Master TECM on TBEM.I_Exam_Component_ID=TECM.I_Exam_Component_ID
	inner join T_Course_Master TCM on TSBM.I_Course_ID=TCM.I_Course_ID
	inner join T_Student_Detail TSD on TSM.I_Student_Detail_ID=TSD.I_Student_Detail_ID
	inner join T_Center_Hierarchy_Name_Details TCHND on TSM.I_Center_ID=TCHND.I_Center_ID
	inner join T_Module_Eval_Strategy TMES on TBEM.I_Module_ID=TMES.I_Module_ID and TBEM.I_Exam_Component_ID=TMES.I_Exam_Component_ID and TBEM.I_Term_ID=TMES.I_Term_ID
												and TMES.I_Status=1
	where
	TCHND.I_Brand_ID=107 and TCM.S_Course_Name like '%2021%' and TMES.N_Weightage>0 and TSM.I_Exam_Total IS NOT NULL and TSM.I_Exam_Total!=0.01
	--and TCM.I_Course_ID=689 and TSBM.I_Batch_ID=10350 and TECM.I_Exam_Component_ID=6
	group by TCHND.I_Brand_ID,TCHND.S_Brand_Name,TCM.I_Course_ID,TCM.S_Course_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Name,TTM.I_Term_ID,TTM.S_Term_Name,
	--TMM.I_Module_ID,TMM.S_Module_Name,
	TECM.I_Exam_Component_ID,TECM.S_Component_Name,
	TSD.I_Student_Detail_ID,TSD.S_Student_ID
	--order by TSD.S_Student_ID
) T1
group by T1.S_Brand_Name,T1.S_Course_Name,T1.S_Batch_Name,T1.S_Term_Name,--T1.S_Module_Name,
T1.S_Component_Name,T1.MarksPercentage