-- =============================================
-- Author:		Arindam Roy
-- Create date: '07/30/2007'
-- Description:	This Function return a Numeric Value of Adherence to Exam Schedule KRA 
-- =============================================
CREATE FUNCTION [EOS].[fnGetKRAExamSchedule]
(
	@iEmployeeID INT,
	@iCurtrentMonth INT,
	@iCurtrentYear INT
)
RETURNS  @rtnTable TABLE
(
	TotalStudent INT,
	AppearedStudent INT
)

AS 

BEGIN

	DECLARE @CenterID INT
	DECLARE @TotalStudent INT
	DECLARE @AppearedStudent INT

	SELECT @CenterID=I_Centre_Id FROM dbo.T_Employee_Dtls WHERE I_Employee_ID=@iEmployeeID

--Total Student
	 SELECT @TotalStudent=COUNT(EL.I_Student_Detail_ID)
	   FROM EXAMINATION.T_Examination_Detail ED
			INNER JOIN EXAMINATION.T_Eligibility_List EL
			ON ED.I_Exam_ID=EL.I_Exam_ID
	  WHERE MONTH(ED.Dt_Exam_Date)=@iCurtrentMonth
		AND	YEAR(ED.Dt_Exam_Date)=@iCurtrentYear
		AND	ED.I_Centre_Id=@CenterID

--Appeared Student
	 SELECT @AppearedStudent=COUNT(EL.I_Student_Detail_ID)
	   FROM EXAMINATION.T_Examination_Detail ED
			INNER JOIN EXAMINATION.T_Eligibility_List EL
			ON ED.I_Exam_ID=EL.I_Exam_ID
			INNER JOIN EXAMINATION.T_Student_Marks SM
			ON ED.I_Exam_ID=SM.I_Exam_ID
			AND EL.I_Student_Detail_ID=SM.I_Student_Detail_ID
	  WHERE MONTH(ED.Dt_Exam_Date)=@iCurtrentMonth
		AND	YEAR(ED.Dt_Exam_Date)=@iCurtrentYear
		AND	ED.I_Centre_Id=@CenterID

	INSERT INTO @rtnTable
		SELECT	@TotalStudent,
				@AppearedStudent

	RETURN;

END