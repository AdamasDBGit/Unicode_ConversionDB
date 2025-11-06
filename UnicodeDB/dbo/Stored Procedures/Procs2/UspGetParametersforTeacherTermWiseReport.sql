CREATE PROCEDURE [dbo].[UspGetParametersforTeacherTermWiseReport] (@Year int)    
AS    
BEGIN    
    
select distinct    
    
TCCM.S_Course_Name as Course,   
TCCM.I_Course_ID as CourseID,  
TECM.S_Component_Name as Subject,   
TECM.I_Exam_Component_ID as SubjectID,  
TSBM.S_Batch_Name as Batch,   
TSBM.I_Batch_ID as BatchID,  
TED.S_First_Name +' '+ ISNULL(TED.S_Middle_Name,'')+' '+ TED.S_Last_Name AS Teachers,   
TED.I_Employee_ID As Employee_ID,  
TTM.S_Term_Name as Term  ,  
TTM.I_Term_ID as TermID  
    
from     
    
EXAMINATION.T_Student_Marks ETSM    
INNER join EXAMINATION.T_Batch_Exam_Map ETBEM on ETSM.I_Batch_Exam_ID=ETBEM.I_Batch_Exam_ID    
INNER join T_Student_Batch_Master TSBM on TSBM.I_Batch_ID=ETBEM.I_Batch_ID    
INNER join T_Term_Master TTM on TTM.I_Term_ID=ETBEM.I_Term_ID    
INNER join T_Exam_Component_Master TECM on TECM.I_Exam_Component_ID=ETBEM.I_Exam_Component_ID    
left Join T_Module_Eval_Strategy TMES on TMES.I_Exam_Component_ID=TECM.I_Exam_Component_ID and    
TMES.I_Exam_Component_ID=ETBEM.I_Exam_Component_ID     
and TMES.I_Term_ID=TTM.I_Term_ID    
left Join T_Course_Master TCCM on TCCM.I_Course_ID=TMES.I_Course_ID    
INNER JOIN EXAMINATION.T_Batch_Exam_Faculty_Map AS TBEFM ON TBEFM.I_Batch_Exam_ID = ETBEM.I_Batch_Exam_ID    
INNER JOIN dbo.T_Employee_Dtls AS TED ON TED.I_Employee_ID = TBEFM.I_Employee_ID    
and TED.I_Status=3    
    
    
where     
    
TTM.I_Brand_ID=107     
and TMES.I_Status=1    
and Replace (Right (TCCM.S_Course_Name,5),')','')=@Year    
group by     
    
TCCM.S_Course_Name,TSBM.S_Batch_Name,    
TECM.S_Component_Name,    
(TED.S_First_Name +' '+ ISNULL(TED.S_Middle_Name,'')+' '+ TED.S_Last_Name),    
TTM.S_Term_Name  ,  
TCCM.I_Course_ID,TECM.I_Exam_Component_ID,TSBM.I_Batch_ID,TED.I_Employee_ID,  
TTM.I_Term_ID  
    
order by TCCM.S_Course_Name,TSBM.S_Batch_Name,    
TECM.S_Component_Name,    
(TED.S_First_Name +' '+ ISNULL(TED.S_Middle_Name,'')+' '+ TED.S_Last_Name),    
TTM.S_Term_Name    
;    
    
    
    
    
    
END
