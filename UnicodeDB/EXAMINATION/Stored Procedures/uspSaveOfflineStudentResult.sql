/**************************************************************************************************************
Created by  : Swagata De
Date		: 25.05.2007
Description : This SP will save the offline examination results for all students of a particular center and for aparticular exam at the head office
Parameters  : 
Returns     : 
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspSaveOfflineStudentResult]	
(
	@sStudentResultXML XML 		
)
AS

BEGIN TRY
	SET NOCOUNT ON;
	
	--	Create Temporary Table To store offline student results from XML
	CREATE TABLE #tempTable
	(            
		I_Center_ID INT,
		I_Exam_ID INT,
		I_Student_Detail_ID INT,
		S_Answer_XML XML,
		N_Marks NUMERIC(8,2),
		I_Exam_Component_ID INT,
		I_Course_ID INT,
		I_Term_ID INT,
		I_Module_ID INT,
		Dt_Exam_Date DATETIME,
		I_No_Of_Attempts INT		
	)
--	Insert Values into Temporary Table
	INSERT INTO #tempTable
	SELECT T.c.value('@I_Center_ID','int'),
			T.c.value('@I_Exam_ID','int'),
			T.c.value('@I_Student_Detail_ID','int'),
			T.c.value('@S_Answer_XML','varchar(max)'),
			T.c.value('@N_Marks','numeric(8,2)'),
			0,0,0,0,NULL,
			T.c.value('@I_No_Of_Attempts','int')
	FROM   @sStudentResultXML.nodes('/StudentMarksList/StudentMarks') T(c)       
		
		--Update the entries already present
		UPDATE TSQA
		SET TSQA.I_Center_ID=TEMP1.I_Center_ID,
			TSQA.I_Exam_ID=TEMP1.I_Exam_ID,
			TSQA.I_Student_Detail_ID=TEMP1.I_Student_Detail_ID,
			TSQA.S_Answer_XML=TEMP1.S_Answer_XML,
			TSQA.N_Marks=TEMP1.N_Marks,
			TSQA.I_No_Of_Attempts=TEMP1.I_No_Of_Attempts			
		FROM EXAMINATION.T_Student_Question_Answer  TSQA ,#tempTable TEMP1
		WHERE TSQA.I_Center_ID=TEMP1.I_Center_ID
		AND TSQA.I_Exam_ID=TEMP1.I_Exam_ID
		AND	TSQA.I_Student_Detail_ID=TEMP1.I_Student_Detail_ID	

		UPDATE #tempTable
		SET #tempTable.I_Exam_Component_ID = TED.I_Exam_Component_ID,
			#tempTable.I_Course_ID = TED.I_Course_ID,
			#tempTable.I_Term_ID = TED.I_Term_ID,
			#tempTable.I_Module_ID = TED.I_Module_ID,
			#tempTable.Dt_Exam_Date = TED.Dt_Exam_Date
		FROM EXAMINATION.T_Examination_Detail TED
		WHERE TED.I_Exam_ID = #tempTable.I_Exam_ID

		UPDATE EXAMINATION.T_Student_Marks
		SET EXAMINATION.T_Student_Marks.I_Exam_Total = T.N_Marks,
			EXAMINATION.T_Student_Marks.Dt_Exam_Date = T.Dt_Exam_Date
		FROM #tempTable T
		WHERE EXAMINATION.T_Student_Marks.I_Student_Detail_ID = T.I_Student_Detail_ID 
			AND EXAMINATION.T_Student_Marks.I_Exam_Component_ID = T.I_Exam_Component_ID
			AND EXAMINATION.T_Student_Marks.I_Course_ID = T.I_Course_ID
			AND EXAMINATION.T_Student_Marks.I_Term_ID = T.I_Term_ID
			AND EXAMINATION.T_Student_Marks.I_Module_ID = T.I_Module_ID
			--AND EXAMINATION.T_Student_Marks.I_Exam_ID = T.I_Exam_ID
			
		DELETE FROM #tempTable
		WHERE #tempTable.I_Student_Detail_ID IN (SELECT TSM.I_Student_Detail_ID FROM EXAMINATION.T_Student_Marks TSM
										WHERE TSM.I_Exam_Component_ID = #tempTable.I_Exam_Component_ID
										AND TSM.I_Course_ID = #tempTable.I_Course_ID
										AND TSM.I_Term_ID = #tempTable.I_Term_ID
										AND TSM.I_Module_ID = #tempTable.I_Module_ID)
										--AND TSM.I_Exam_ID = #tempTable.I_Exam_ID)
										
		UPDATE #tempTable SET  I_Module_ID = NULL WHERE I_Module_ID = 0

		INSERT INTO EXAMINATION.T_Student_Marks
		(I_Student_Detail_ID,I_Exam_ID,I_Exam_Component_ID,I_Course_ID,I_Term_ID,I_Module_ID,I_Exam_Total,Dt_Exam_Date)
		SELECT I_Student_Detail_ID,I_Exam_ID, I_Exam_Component_ID, I_Course_ID, I_Term_ID, I_Module_ID,N_Marks,Dt_Exam_Date
		FROM #tempTable

	TRUNCATE TABLE #tempTable
	DROP TABLE #tempTable

END TRY	
	
BEGIN CATCH
--Error occurred:  

DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
SELECT	@ErrMsg = ERROR_MESSAGE(),
		@ErrSeverity = ERROR_SEVERITY()

RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
