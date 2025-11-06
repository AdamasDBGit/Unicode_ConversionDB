/**************************************************************************************************************
Created by  : Swagata De
Date		: 09.05.2007
Description : This SP will save the student list for offline exam
Parameters  : 
Returns     : 
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspSaveOfflineStudentList]
	(
		@iExamID INT,	
		@sStudentXML XML,
		@sCrtdBy VARCHAR(20),
		@sUpdBy VARCHAR(20),
		@dtCrtdDt DATETIME,
		@dtUpdDt DATETIME		
	)
AS

BEGIN TRY
	SET NOCOUNT ON;	
	DECLARE	
	@iStudentID VARCHAR(200), 
    @sStudentCode VARCHAR(500)
   

	--	Create Temporary Table To store offline student attributes from XML
	CREATE TABLE #tempTable
	( 
		I_Exam_ID int,           
		I_Student_ID int,
		S_Student_Code varchar(500)		
	)

--	Insert Values into Temporary Table
	INSERT INTO #tempTable(I_Student_ID,S_Student_Code)
	SELECT T.c.value('@I_Student_ID','int'),
			T.c.value('@S_Student_Code','varchar(500)')			
	FROM   @sStudentXML.nodes('/OfflineStudentList/Student') T(c)
	
	UPDATE  #tempTable
	SET  I_Exam_ID=@iExamID
		--Check if student list for the particular exam already present in table or not
		IF EXISTS(SELECT * FROM EXAMINATION.T_Student_Question_Answer WHERE I_Exam_ID=  @iExamID)
		BEGIN	
		--Update the student entries already present in the table
			UPDATE TSQA
			SET 
			TSQA.I_Student_Detail_ID=TEMP1.I_Student_ID	,
			TSQA.S_Upd_By=	@sUpdBy,
			TSQA.Dt_Upd_On=	@dtUpdDt
			FROM EXAMINATION.T_Student_Question_Answer  TSQA ,#tempTable TEMP1
			WHERE TSQA.I_Exam_ID = TEMP1.I_Exam_ID
		END
		ELSE
		BEGIN		
		--Insert the student list in the table	
			INSERT INTO EXAMINATION.T_Student_Question_Answer 
			(
				I_Exam_ID,
				I_Student_Detail_ID						
			
			)
			SELECT I_Exam_ID,I_Student_ID FROM #tempTable 
			
			UPDATE EXAMINATION.T_Student_Question_Answer 
			SET S_Crtd_By=@sCrtdBy,
				Dt_Crtd_On=@dtCrtdDt
			WHERE I_Exam_ID=@iExamID
	   END		

END TRY	
	
BEGIN CATCH
--Error occurred:  

DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
SELECT	@ErrMsg = ERROR_MESSAGE(),
		@ErrSeverity = ERROR_SEVERITY()

RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
