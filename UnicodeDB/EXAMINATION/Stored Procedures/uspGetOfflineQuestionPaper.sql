/**************************************************************************************************************
Created by  : Debarshi Basu
Date		: 01.05.2007
Description : This SP will get the offline Question Paper
Parameters  : 		@iExamID int,
					@iStudentID int
**************************************************************************************************************/


CREATE PROCEDURE [EXAMINATION].[uspGetOfflineQuestionPaper]
(
	@sQuestion xml
)
AS
BEGIN		
	SELECT  DISTINCT T.c.value('@QuestionID','int') AS I_Question_ID,
			T.c.value('@QuestionType','int') AS I_Question_Type,
			T.c.value('@AnswerType','int') AS I_Answer_Type_ID,
			T.c.value('@Complexity','int') AS I_Complexity_ID,
			T.c.value('@Text','varchar(2000)') AS S_Question,
			T.c.value('@Marks','numeric(8,2)') AS N_Marks,
			T.c.value('@ImageID','int') AS I_Document_ID,
			T.c.value('@ImageName', 'VARCHAR(1000)') AS S_Document_Name,
			T.c.value('@ImageType', 'VARCHAR(50)') AS S_Document_Type,
			T.c.value('@ImagePath', 'VARCHAR(5000)') AS S_Document_Path,
			T.c.value('@ImageURL', 'VARCHAR(5000)') AS S_Document_URL
	FROM   @sQuestion.nodes('/QuestionList/Question') T(c)
	
	SELECT  DISTINCT T.c.value('@QuestionID','int') AS I_Question_ID,
			T.c.value('@QuestionChoiceID','int') AS I_Question_Choice_ID,
			T.c.value('@AnswerDesc','varchar(200)') AS S_Answer_Desc,
			T.c.value('@IsAnswer','bit') AS B_Is_Answer			
	FROM   @sQuestion.nodes('/QuestionList/Question/Answer/Answer') T(c)

	SELECT  DISTINCT T.c.value('@QuestionID','int') AS I_Question_ID,
			T.c.value('@SubQuestionID','int') AS I_SubQuestion_ID,
			T.c.value('@SubQuestionDesc','varchar(500)') AS S_SubQuestion_Desc,
			T.c.value('@SubQuestionValue','varchar(50)') AS S_SubQuestion_Value
	FROM   @sQuestion.nodes('/QuestionList/Question/SubQuestion/SubQuestion') T(c)

	SELECT  DISTINCT T.c.value('@SubQuestionID','int') AS I_SubQuestion_ID,
			T.c.value('@SubQuestionChoiceID','int') AS I_SubQuestion_Choice_ID,
			T.c.value('@SubAnswerValue','varchar(50)') AS S_SubAnswer_Value,
			T.c.value('@SubAnswerDesc','varchar(500)') AS S_SubAnswer_Desc,
			T.c.value('@IsAnswer','bit') AS B_Is_Answer
	FROM   @sQuestion.nodes('/QuestionList/Question/SubQuestion/SubQuestion/Answer/Answer') T(c)
END
