/**************************************************************************************************************
Created by  : Debarshi Basu
Date		: 09.05.2007
Description : This SP will save the student list for offline exam for each center
Parameters  : 
Returns     : 
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspSaveOfflineStudentListForCenter]
	(
		@iCenterID INT,
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
		ID INT IDENTITY(1,1),
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
	
	DECLARE @iCount INT, @iActualCount INT
	SET @iCount = 1
	SELECT @iActualCount = COUNT(*) FROM #tempTable
	
	WHILE (@iCount <= @iActualCount)
	BEGIN
		SELECT @iStudentID = I_Student_ID FROM #tempTable WHERE ID = @ICount
		--Check if student list for the particular exam already present in table or not
		IF EXISTS(SELECT * FROM EXAMINATION.T_Student_Question_Answer WHERE I_Exam_ID=  @iExamID 
							AND I_Student_Detail_ID = @iStudentID AND I_Center_ID =@iCenterID )
		BEGIN	
		--Update the student entries already present in the table
			UPDATE TSQA
			SET 			
			TSQA.S_Upd_By=	@sUpdBy,
			TSQA.Dt_Upd_On=	@dtUpdDt
			FROM EXAMINATION.T_Student_Question_Answer  TSQA ,#tempTable TEMP1
			WHERE TSQA.I_Exam_ID = TEMP1.I_Exam_ID
			AND TSQA.I_Center_ID = @iCenterID
			AND I_Student_Detail_ID = @iStudentID
		END
		ELSE
		BEGIN		
		--Insert the student list in the table	
			INSERT INTO EXAMINATION.T_Student_Question_Answer 
			(
				I_Center_ID,
				I_Exam_ID,
				I_Student_Detail_ID,						
				S_Crtd_By,
				Dt_Crtd_On
			)
			VALUES(@iCenterID,@iExamID,@iStudentID,@sCrtdBy,@dtCrtdDt)
	   END	
	   
	   SET @iCount = @iCount + 1	
	END
END TRY	
	
BEGIN CATCH
--Error occurred:  

DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
SELECT	@ErrMsg = ERROR_MESSAGE(),
		@ErrSeverity = ERROR_SEVERITY()

RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
