/**************************************************************************************************************
Created by  : Debarshi Basu
Date		: 09.05.2007
Description : This SP will save the Eligibility List for Examination
Parameters  : 
Returns     : 
**************************************************************************************************************/
CREATE PROCEDURE [EXAMINATION].[uspSaveEligibilityList] 
	@iExamID int,
	@sRegistrationNumber VARCHAR(20),
	@sStudentList xml,
	@sCreatedBy varchar(20),
	@DtCreatedOn datetime,
	@sUpdatedBy  varchar(20),
	@DtUpdatedOn datetime
AS
BEGIN

	CREATE TABLE #tempTable
	(            
		I_Student_Detail_ID int
	)

	INSERT INTO #tempTable
	SELECT T.c.value('@ID','int')     
	FROM   @sStudentList.nodes('/Registration/Student') T(c)

	DELETE FROM EXAMINATION.T_Eligibility_List
	WHERE I_Student_Detail_ID NOT IN 
		(SELECT I_Student_Detail_ID FROM #tempTable )
		AND I_Exam_ID = @iExamID
	
	INSERT INTO EXAMINATION.T_Eligibility_List
	(I_Student_Detail_ID,
	I_Exam_ID,
	S_Registration_No,
	S_Crtd_By,
	S_Upd_By,
	Dt_Crtd_On,
	Dt_Upd_On,
	C_Appeared_For_Exam)
	SELECT I_Student_Detail_ID,
	@iExamID,null,@sCreatedBy,@sUpdatedBy,
	@DtCreatedOn,@DtUpdatedOn,'N'
	FROM #tempTable
	WHERE I_Student_Detail_ID NOT IN 
	(SELECT I_Student_Detail_ID FROM EXAMINATION.T_Eligibility_List WHERE I_Exam_ID = @iExamID)

	TRUNCATE TABLE #tempTable
	DROP TABLE #tempTable

END
