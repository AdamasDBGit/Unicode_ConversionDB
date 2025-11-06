-- =============================================
-- Author:		Arindam Roy
-- Create date: '07/30/2007'
-- Description:	This Function return a Numeric Value of Faculty Certification KRA 
-- =============================================
CREATE FUNCTION [EOS].[fnGetKRAFacultyCertification]
(
	@iEmployeeID INT,
	@iCurtrentMonth INT,
	@iCurtrentYear INT
)

RETURNS  NUMERIC(18,2)

AS 

BEGIN

	DECLARE @FacultyCertification TABLE
	(
		I_Employee_ID INT,
		I_Centre_Id INT,
		I_Skill_ID INT,
		I_Exam_Component_ID INT
	)

	DECLARE @EmpID INT
	DECLARE @CenterID INT
	DECLARE @SkillID INT
	DECLARE @ExamComponentID INT
	DECLARE @SkillCount INT

	DECLARE FacultyCertification_cursor CURSOR FOR 
		 SELECT DISTINCT
				ED.I_Employee_ID,
				ED.I_Centre_Id,
				ESM.I_Skill_ID
		   FROM dbo.T_Employee_Dtls ED
				INNER JOIN EOS.T_Employee_Skill_Map ESM
					ON ED.I_Employee_ID=ESM.I_Employee_ID
		  WHERE ED.I_Employee_ID=@iEmployeeID

		OPEN FacultyCertification_cursor
		FETCH NEXT FROM FacultyCertification_cursor 
		INTO @EmpID,@CenterID,@SkillID

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

			INSERT INTO @FacultyCertification
			SELECT	@EmpID,@CenterID,@SkillID,@ExamComponentID

			FETCH NEXT FROM FacultyCertification_cursor 
			INTO @EmpID,@CenterID,@SkillID
		END
	CLOSE FacultyCertification_cursor
	DEALLOCATE FacultyCertification_cursor

	 SELECT @SkillCount=COUNT(DISTINCT I_Skill_ID)
	   FROM @FacultyCertification TMP
			INNER JOIN EOS.T_Employee_Exam_Result EER
				ON TMP.I_Exam_Component_ID=EER.I_Exam_Component_ID
				AND TMP.I_Employee_ID=EER.I_Employee_ID
	  WHERE EER.B_Passed=1
		AND MONTH(Dt_Crtd_On)=@iCurtrentMonth
		AND YEAR(Dt_Crtd_On)=@iCurtrentYear

	RETURN @SkillCount

END