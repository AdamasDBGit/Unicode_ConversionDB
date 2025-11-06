-- =============================================
-- Author:		Arindam Roy
-- Create date: '07/30/2007'
-- Description:	This Function return a Numeric Value of Faculty Competency KRA 
-- =============================================
CREATE FUNCTION [EOS].[fnGetKRAFacultyCompetency]
(
	@iEmployeeID INT,
	@iCurtrentMonth INT,
	@iCurtrentYear INT
)

RETURNS  NUMERIC(18,2)

AS 

BEGIN

	DECLARE @FacultyCompetency TABLE
	(
		I_Centre_Id INT,
		I_Skill_ID INT,
		I_Exam_Component_ID INT
	)	

	DECLARE @FacultySkill TABLE
	(
		I_Skill_ID INT,
		FacultyCount INT
	)

	DECLARE @CenterID INT
	DECLARE @SkillID INT
	DECLARE @ExamComponentID INT
	DECLARE @SkillCount INT

	SELECT @CenterID=I_Centre_Id FROM dbo.T_Employee_Dtls WHERE I_Employee_ID=@iEmployeeID

	DECLARE FacultyCompetency_cursor CURSOR FOR 
	SELECT I_Skill_ID
	  FROM dbo.T_EOS_Skill_Master

	OPEN FacultyCompetency_cursor
	FETCH NEXT FROM FacultyCompetency_cursor 
	INTO @SkillID

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS ( SELECT I_Exam_Component_ID
					  FROM EOS.T_Skill_Exam_Map
					 WHERE I_Centre_ID=@CenterID
					   AND I_Skill_ID=@SkillID
				  )
		BEGIN
			SELECT @ExamComponentID=I_Exam_Component_ID
			  FROM EOS.T_Skill_Exam_Map
			 WHERE I_Centre_ID=@CenterID
			   AND I_Skill_ID=@SkillID
		END
		ELSE
		BEGIN
			SELECT @ExamComponentID=I_Exam_Component_ID
			  FROM EOS.T_Skill_Exam_Map
			 WHERE I_Centre_ID IS NULL
			   AND I_Skill_ID=@SkillID
		END

		IF @ExamComponentID IS NOT NULL
		BEGIN
			INSERT INTO @FacultyCompetency
			SELECT	@CenterID,@SkillID,@ExamComponentID
		END
		SET @ExamComponentID=NULL

		FETCH NEXT FROM FacultyCompetency_cursor 
		INTO @SkillID
	END
	CLOSE FacultyCompetency_cursor
	DEALLOCATE FacultyCompetency_cursor

	INSERT INTO @FacultySkill
	 SELECT TMP.I_Skill_ID,COUNT(DISTINCT EER.I_Employee_ID) 
	   FROM EOS.T_Employee_Exam_Result EER
			INNER JOIN dbo.T_Employee_Dtls ED
				ON EER.I_Employee_ID=ED.I_Employee_ID
				AND ED.I_Centre_Id=@CenterID
			INNER JOIN @FacultyCompetency TMP
				ON EER.I_Exam_Component_ID=TMP.I_Exam_Component_ID
				AND ED.I_Centre_Id=TMP.I_Centre_Id
	  WHERE EER.B_Passed=1
--			AND ((YEAR(EER.Dt_Crtd_On)=@iCurtrentYear AND MONTH(EER.Dt_Crtd_On)<=@iCurtrentMonth) OR (YEAR(EER.Dt_Crtd_On)<=@iCurtrentYear))
   GROUP BY TMP.I_Skill_ID

	SELECT @SkillCount=COUNT(DISTINCT I_Skill_ID) 
	  FROM @FacultySkill 
	 WHERE FacultyCount>=2

	RETURN @SkillCount

END