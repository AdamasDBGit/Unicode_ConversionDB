-- =============================================
-- Author:		Arindam Roy
-- Create date: '07/30/2007'
-- Description:	This Function return a Numeric Value of Student Feedback KRA 
-- =============================================
CREATE FUNCTION [EOS].[fnGetKRAStudentFeedback]
(
	@iEmployeeID INT,
	@iCurtrentMonth INT,
	@iCurtrentYear INT
)

RETURNS  NUMERIC(8,2)

AS 

BEGIN

	DECLARE @CenterID INT
	DECLARE @AvgFeedback NUMERIC(8,2)
	
	SELECT @CenterID=I_Centre_Id FROM dbo.T_Employee_Dtls WHERE I_Employee_ID=@iEmployeeID

	 SELECT @AvgFeedback=AVG(CONVERT(NUMERIC,I_Value))
       FROM dbo.T_Student_Center_Detail SCD
			INNER JOIN dbo.T_Student_Module_Detail SMD
				ON SCD.I_Student_Detail_ID=SMD.I_Student_Detail_ID
				AND SCD.I_Status<>0
			INNER JOIN STUDENTFEATURES.T_Student_Feedback SF
				ON SMD.I_Student_Module_Detail_ID=SF.I_Student_Module_Detail_ID
			INNER JOIN STUDENTFEATURES.T_Student_Feedback_Details SFD
				ON SF.I_Student_Feedback_ID=SFD.I_Student_Feedback_ID
			INNER JOIN ACADEMICS.T_Feedback_Option_Master FOM
				ON SFD.I_Feedback_Option_Master_ID=FOM.I_Feedback_Option_Master_ID
	  WHERE SCD.I_Centre_Id=@CenterID
		AND MONTH(SF.Dt_Crtd_On)=@iCurtrentMonth
		AND YEAR(SF.Dt_Crtd_On)=@iCurtrentYear

	RETURN @AvgFeedback

END