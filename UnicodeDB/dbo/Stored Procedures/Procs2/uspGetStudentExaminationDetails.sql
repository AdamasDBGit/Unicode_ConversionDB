CREATE PROCEDURE [dbo].[uspGetStudentExaminationDetails]
(
@iTermID AS INT,
@iBatchID AS INT,
@iCenterID AS INT

)

AS

BEGIN


CREATE TABLE #temp
(
[CENTER_NAME] nvarchar(max),
[COURSE_NAME] nvarchar(max),
[BATCH_NAME] nvarchar(max),
[TERM_ID] INT,
[TERM_NAME] nvarchar(max),
[STUDENT_ID] INT,
[STUDENT_CODE] nvarchar(max),
[STUDENT_NAME] nvarchar(max),
[SUBJECT] nvarchar(max),
[MARKS_OBTAINED] INT,
[FULL_MARKS] INT,
[TOTAL_MARKS_OBTAINED] INT,
[PERCENTAGE] REAL,
[OVERALL_RANK] INT,
[CENTER_RANK] INT,
[BATCH_RANK]INT
)





INSERT INTO #temp
	(
	
	[CENTER_NAME] ,
	[COURSE_NAME] ,
	[BATCH_NAME] ,
	[TERM_ID],
	[TERM_NAME] ,
	[STUDENT_ID] ,
	[STUDENT_CODE],
	[STUDENT_NAME] ,
	[SUBJECT],
	[MARKS_OBTAINED] ,
    [FULL_MARKS] ,
   -- [TOTAL_MARKS_OBTAINED],
    [PERCENTAGE] 
)

SELECT		
E.S_Center_Name,
S_Course_Desc,
c.S_Batch_Name ,
t2.I_Term_ID,
S_Term_Name ,
A.I_Student_Detail_ID,
S_Student_ID,
A.S_First_Name+' '+A.S_Middle_Name+' '+A.S_Last_Name,
H.S_Component_Name,
SUM(ISNULL(J.I_Exam_Total,0)) AS MARKS_OBTAINED,
SUM(G.I_TotMarks) AS FULL_MARKS,

(SUM(ISNULL(J.I_Exam_Total,0))/SUM(G.I_TotMarks))*100 AS 'PERCENTAGE'
		    
		
		
		
		FROM T_Student_Detail A 
		INNER JOIN T_Student_Batch_Details B
		ON A.I_Student_Detail_ID=B.I_Student_ID AND B.I_Status=1
		INNER JOIN T_Student_Batch_Master C
		ON C.I_Batch_ID=B.I_Batch_ID 
		INNER JOIN T_Center_Batch_Details D
		ON D.I_Batch_ID=C.I_Batch_ID
		INNER JOIN T_Center_Hierarchy_Name_Details E
		ON E.I_Center_ID=D.I_Centre_Id 
		INNER JOIN T_Course_Master F
		ON F.I_Course_ID=C.I_Course_ID
		INNER JOIN T_Term_Course_Map T1
		ON T1.I_Course_ID=F.I_Course_ID
		INNER JOIN T_Term_Master T2
		ON T2.I_Term_ID=T1.I_Term_ID
		LEFT JOIN T_Term_Eval_Strategy G
		ON G.I_Term_ID=T2.I_Term_ID AND G.I_Status=1 AND T2.I_Status=1
		LEFT JOIN T_Exam_Component_Master H
		ON H.I_Exam_Component_ID=G.I_Exam_Component_ID AND H.I_Status=1
		LEFT JOIN EXAMINATION.T_Batch_Exam_Map I
		ON I.I_Batch_ID=C.I_Batch_ID AND I.I_Exam_Component_ID=H.I_Exam_Component_ID AND I.I_Term_ID=T2.I_Term_ID
		LEFT JOIN EXAMINATION.T_Student_Marks J
		ON J.I_Batch_Exam_ID=I.I_Batch_Exam_ID AND A.I_Student_Detail_ID=J.I_Student_Detail_ID
		
							WHERE
							E.I_Center_ID=ISNULL(@iCenterID,E.I_Center_ID)
							AND
							T2.I_Term_ID=ISNULL(@iTermID,T2.I_Term_ID)

							AND
							C.I_Batch_ID=ISNULL(@iBatchID,C.I_Batch_ID)
							GROUP BY
										A.I_Student_Detail_ID,
										S_Student_ID ,
										c.S_Batch_Name ,
										S_Course_Desc ,
										S_Term_Name,
										S_Center_Name,
										A.S_First_Name,A.S_Middle_Name,A.S_Last_Name,
										T2.I_Term_ID,
										C.I_Batch_ID,
										E.I_Center_ID,
										h.S_Component_Name
										--TEMP.Center_Rank,
										--TEMP2.Batch_Rank,TEMP3.Overall_Rank
										HAVING SUM(ISNULL(J.I_Exam_Total,0))>0
										
										
			
			



UPDATE T1 SET T1.OVERALL_RANK = T2.Overall_Rank 

FROM 

#temp T1 

LEFT JOIN 

(

				SELECT  SM.I_Student_Detail_ID,
						BEM.I_Term_ID,
						DENSE_RANK() OVER ( PARTITION BY BEM.I_Term_ID ORDER BY SUM(ISNULL(SM.I_Exam_Total,0)) DESC ) AS [Overall_Rank]
							FROM EXAMINATION.T_Student_Marks SM INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM
							ON BEM.I_Batch_Exam_ID=SM.I_Batch_Exam_ID                  
							GROUP BY
							I_Student_Detail_ID,
							BEM.I_Term_ID
			
				
				) T2
							ON T1.STUDENT_ID=T2.I_Student_Detail_ID AND T1.TERM_ID=T2.I_Term_ID
							
							
	UPDATE T1 SET T1.CENTER_RANK = T2.Center_Rank

FROM 

#temp T1 

LEFT JOIN 

(

				SELECT  SM.I_Student_Detail_ID,
						BEM.I_Term_ID,
				
						DENSE_RANK() OVER ( PARTITION BY BEM.I_Term_ID,SM.I_Center_ID ORDER BY SUM(ISNULL(SM.I_Exam_Total,0)) DESC ) AS [Center_Rank]
				FROM EXAMINATION.T_Student_Marks SM INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM
				ON BEM.I_Batch_Exam_ID=SM.I_Batch_Exam_ID                  
				GROUP BY
				I_Student_Detail_ID,
				BEM.I_Term_ID,
				SM.I_Center_ID
			
				
				) T2
							ON T1.STUDENT_ID=T2.I_Student_Detail_ID AND T1.TERM_ID=T2.I_Term_ID
							
							
	
	UPDATE T1 SET T1.BATCH_RANK = T2.Batch_Rank 

	FROM 

	#temp T1 

	LEFT JOIN 

(
						SELECT  SM.I_Student_Detail_ID,
						BEM.I_Term_ID,
						DENSE_RANK() OVER ( PARTITION BY BEM.I_Term_ID,SM.I_Center_ID,BEM.I_Batch_ID ORDER BY SUM(ISNULL(SM.I_Exam_Total,0)) DESC ) AS [Batch_Rank]
				
				FROM EXAMINATION.T_Student_Marks SM INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM
				ON BEM.I_Batch_Exam_ID=SM.I_Batch_Exam_ID                  
				GROUP BY
				I_Student_Detail_ID,
				BEM.I_Term_ID,
				SM.I_Center_ID,
				BEM.I_Batch_ID
			
				
				) T2
							ON T1.STUDENT_ID=T2.I_Student_Detail_ID AND T1.TERM_ID=T2.I_Term_ID						
							
							
UPDATE T1 SET T1.TOTAL_MARKS_OBTAINED = T2.TOTAL_MARKS_OBTAINED

	FROM 

	#temp T1 

	LEFT JOIN 

(
						SELECT		SM.I_Student_Detail_ID,
									BEM.I_Term_ID,
									SUM(ISNULL(SM.I_Exam_Total,0)) AS TOTAL_MARKS_OBTAINED
				
				FROM EXAMINATION.T_Student_Marks SM INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM
				ON BEM.I_Batch_Exam_ID=SM.I_Batch_Exam_ID                  
				GROUP BY
				I_Student_Detail_ID,
				BEM.I_Term_ID,
				SM.I_Center_ID,
				BEM.I_Batch_ID
			
				
				) T2
							ON T1.STUDENT_ID=T2.I_Student_Detail_ID AND T1.TERM_ID=T2.I_Term_ID								
			
			
			SELECT * FROM #temp

END
