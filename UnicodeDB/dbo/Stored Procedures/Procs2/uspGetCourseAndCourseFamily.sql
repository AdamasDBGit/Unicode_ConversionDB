CREATE PROC [dbo].[uspGetCourseAndCourseFamily]
AS 
BEGIN

SET NOCOUNT ON

    SELECT DISTINCT 
           CFM.I_CourseFamily_ID,
	       CFM.S_CourseFamily_Name,	  
	       CFM.I_Brand_ID,	  
	       CM.I_Course_ID,
	       CM.I_Brand_ID,
	       CM.I_CourseFamily_ID,
	       CM.S_Course_Code,
	       CM.S_Course_Name,
	       CM.S_Course_Desc,
	       CM.I_Grading_Pattern_ID,
	       CM.I_No_Of_Session,
	       CM.I_Certificate_ID,
	       CM.I_Document_ID,
	       CM.C_AptitudeTestReqd,
	       CM.C_IsCareerCourse,
	       CM.C_IsShortTermCourse,
	       CM.C_IsPlacementApplicable,
	       CM.I_Is_Editable  
	       FROM T_Course_Master CM
    INNER JOIN T_CourseFamily_Master CFM
    ON CM.I_CourseFamily_ID = CFM.I_CourseFamily_ID
    WHERE CM.I_Status <> 0
    AND CFM.I_Status <> 0

END
