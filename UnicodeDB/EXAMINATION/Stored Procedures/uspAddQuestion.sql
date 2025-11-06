/**************************************************************************************************************
Created by  : Debarshi Basu
Date		: 01.05.2007
Description : This SP will save the Question Details
Parameters  : 	@iQuestionPoolID int,
				@sQuestion xml,
				@sCreatedBy varchar(20),
				@DtCreatedOn datetime,
				@sUpdatedBy  varchar(20),
				@DtUpdatedOn datetime
**************************************************************************************************************/


CREATE PROCEDURE [EXAMINATION].[uspAddQuestion]
	@iQuestionPoolID int,
	@sQuestion xml,
	@sCreatedBy varchar(20),
	@DtCreatedOn datetime,
	@sUpdatedBy  varchar(20),
	@DtUpdatedOn datetime
AS
BEGIN TRY	

	DECLARE @iQuestionID INT
	
--	Create Temporary Table To store Question properties from XML
	CREATE TABLE #tempTable
	(            
		I_Question_Type int,
		I_Answer_Type_ID int,
		I_Complexity_ID int,
		S_Question NVARCHAR(2500),
		S_Question_Options nvarchar(4000),
		I_Document_ID int
	)

--	Insert Values into Temporary Table
	INSERT INTO #tempTable
	SELECT T.c.value('@QuestionType','int'),
			T.c.value('@AnswerType','int'),
			T.c.value('@Complexity','int'),
			T.c.value('@Text','nvarchar(2500)'),
			T.c.value('@Options', 'nvarchar(4000)'),
			T.c.value('@Image','int')
	FROM   @sQuestion.nodes('/Question') T(c)
	
    
	
--	Insert values into the Question Pool table from temporary table
	INSERT INTO EXAMINATION.T_Question_Pool
	(I_Pool_ID,I_Answer_Type_ID,S_Question,S_Question_Options,I_Question_Type,I_Complexity_ID,I_Document_ID,
	Dt_Question_Upload_Date,S_Crtd_By,Dt_Crtd_On)
	SELECT 
	@iQuestionPoolID,I_Answer_Type_ID,S_Question,S_Question_Options,I_Question_Type,I_Complexity_ID,I_Document_ID,
	@DtCreatedOn,@sCreatedBy,@DtCreatedOn 
	FROM #tempTable

--	Take the Question ID of the inserted question
	SELECT @iQuestionID = @@IDENTITY 

--	CREATE Temp Table to store Question Choice from XML
	CREATE TABLE #tempQChoice
	(   
		B_Is_Answer bit,
		S_Answer_Desc nvarchar(2000)
	)

--	Insert Values into Temporary Table
	INSERT INTO #tempQChoice
	SELECT T.c.value('@CorrectAnswer','bit'),
			T.c.value('@Text','nvarchar(2000)')
	FROM   @sQuestion.nodes('/Question/Answer/Answer') T(c)

--	Insert values into T_Question_Choices
	INSERT INTO EXAMINATION.T_Question_Choices
	(I_Question_ID,B_Is_Answer,S_Answer_Desc)
	SELECT @iQuestionID, B_Is_Answer,S_Answer_Desc 
	FROM #tempQChoice

--	CREATE Temp Table to store Sub Question from XML
	CREATE TABLE #tempSubQuestion
	(   
		AutoId int identity(1,1),
		ID int,
		I_SubQuestion_Type INT,
		S_SubQuestion_Text nvarchar(500),
		S_SubQuestion_Value nvarchar(50),
		I_Document_ID INT
	)

--	Insert Values into Temporary Table
	INSERT INTO #tempSubQuestion
	(ID,I_SubQuestion_Type,S_SubQuestion_Text,S_SubQuestion_Value,I_Document_ID)
	SELECT	T.c.value('@ID','int'),
			T.c.value('@SubQuestionType','int'),
			T.c.value('@Desc','nvarchar(500)'),
			T.c.value('@Value','nvarchar(50)'),
			T.c.value('@Image','int')
	FROM   @sQuestion.nodes('/Question/SubQuestion/SubQuestion') T(c)

--	CREATE Temp Table to store Sub Question Choices from XML
	CREATE TABLE #tempSubChoice
	(   
		S_SubQuestion_ID int,
		I_Question_Choice_Type INT,
		S_SubAnswer_Value nvarchar(50),
		S_SubAnswer_Desc nvarchar(500),
		I_Document_ID INT,
		B_Is_Answer bit		
	)

--	Insert Values into Temporary Table
	INSERT INTO #tempSubChoice
	(   
		S_SubQuestion_ID,
		I_Question_Choice_Type,
		S_SubAnswer_Value,
		S_SubAnswer_Desc,
		I_Document_ID,
		B_Is_Answer	
	)
	SELECT	T.c.value('@ID','int'),
			T.c.value('@QuestionChoiceType', 'int'),
			T.c.value('@Value','nvarchar(50)'),
			T.c.value('@Text','nvarchar(500)'),
			T.c.value('@Image','int'),
			T.c.value('@CorrectAnswer','bit')
	FROM   @sQuestion.nodes('/Question/SubQuestion/SubQuestion/Answer/Answer') T(c)

--	Insert SubQuestion and SubQuestionChoice
	DECLARE @iCount int
	DECLARE @iSubQuestionID int
	DECLARE @iSubQIDTemp int
	DECLARE @iRowCountSubQ int
	SELECT @iRowCountSubQ = count(AutoId) FROM #tempSubQuestion
	SET @iCount = 1
	
	WHILE (@iCount <= @iRowCountSubQ)
	BEGIN
		SELECT @iSubQIDTemp = ID FROM #tempSubQuestion WHERE AutoId = @iCount
		
--		Insert Values in Sub Question Table
		INSERT INTO EXAMINATION.T_SubQuestion
		(I_Question_ID,I_SubQuestion_Type,S_SubQuestion_Desc,I_Document_ID,S_SubQuestion_Value,
		S_Crtd_By,Dt_Crtd_On)
		SELECT @iQuestionID,I_SubQuestion_Type,S_SubQuestion_Text,I_Document_ID,S_SubQuestion_Value,
		@sCreatedBy,@DtCreatedOn FROM #tempSubQuestion WHERE AutoId = @iCount

		SELECT @iSubQuestionID = @@IDENTITY
		
--		INSERT Into Sub Question Choices
		INSERT INTO EXAMINATION.T_SubQuestion_Choice
		(I_SubQuestion_ID,I_SubQuestion_Choice_Type,S_SubAnswer_Value,S_SubAnswer_Desc,I_Document_ID,
		B_Is_Answer,S_Crtd_By,Dt_Crtd_On)
		SELECT @iSubQuestionID,I_Question_Choice_Type,S_SubAnswer_Value,S_SubAnswer_Desc,I_Document_ID,
		B_Is_Answer,@sCreatedBy,@DtCreatedOn FROM #tempSubChoice
		WHERE S_SubQuestion_ID = @iSubQIDTemp

		SET @iCount = @iCount + 1
	END
	
	TRUNCATE TABLE #tempTable
	DROP TABLE #tempTable

	TRUNCATE TABLE #tempQChoice
	DROP TABLE #tempQChoice

	TRUNCATE TABLE #tempSubQuestion
	DROP TABLE #tempSubQuestion

	TRUNCATE TABLE #tempSubChoice
	DROP TABLE #tempSubChoice

END TRY
BEGIN CATCH
--Error occurred:  

DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
SELECT	@ErrMsg = ERROR_MESSAGE(),
		@ErrSeverity = ERROR_SEVERITY()

RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
