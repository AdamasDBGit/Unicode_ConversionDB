-- =============================================
-- Author:		Arindam Roy
-- Create date: '12/31/2007'
-- Description:	This Function return the GPA for faculty.
-- =============================================
CREATE FUNCTION [REPORT].[fnGetFacultyGPAForReports]
(
	@sModuleName VARCHAR(250),
	@iEmployeeId INT,
	@dtStartDate DATETIME,
	@dtEndDate DATETIME
)

RETURNS NUMERIC(8,2)

AS 

BEGIN

	DECLARE @AvgGPA NUMERIC(8,2)

	 SELECT @AvgGPA=AVG(CONVERT(NUMERIC,I_Value))
	   FROM dbo.T_Student_Module_Detail SMD
			INNER JOIN STUDENTFEATURES.T_Student_Feedback SF
				ON SMD.I_Student_Module_Detail_ID=SF.I_Student_Module_Detail_ID
			INNER JOIN STUDENTFEATURES.T_Student_Feedback_Details SFD
				ON SF.I_Student_Feedback_ID=SFD.I_Student_Feedback_ID
			INNER JOIN ACADEMICS.T_Feedback_Option_Master FOM
				ON SFD.I_Feedback_Option_Master_ID=FOM.I_Feedback_Option_Master_ID	
	  WHERE SMD.I_Module_ID IN (SELECT I_Module_ID FROM dbo.T_Module_Master WHERE S_Module_Name = @sModuleName)--@iModuleID
		AND SF.I_Employee_ID=@iEmployeeId
		AND SF.Dt_Crtd_On >=@dtStartDate
		AND SF.Dt_Crtd_On < DATEADD(DAY,1,@dtEndDate)
	
	RETURN @AvgGPA
END