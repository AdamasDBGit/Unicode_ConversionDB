CREATE PROCEDURE [dbo].[uspPopulateCourse]  
	@iCourseID int
AS
BEGIN

	SET NOCOUNT OFF;

	DECLARE @iGradingPatternID int;
	DECLARE @iGradingPatternDetailID int;
	DECLARE @iCourseFeePlanID int;

	SELECT 
	@iGradingPatternID = CM.I_Grading_Pattern_ID
	FROM dbo.T_COURSE_MASTER CM 
	WHERE CM.I_Course_ID = @iCourseID
	AND CM.I_Status=1
	

	SELECT 
	CM.I_Course_ID,CM.I_CourseFamily_ID,CM.I_Brand_ID,CM.S_Course_Code,
	CM.S_Course_Name,CM.I_Grading_Pattern_ID,CM.S_Course_Desc,
	CM.I_Certificate_ID,CM.S_Crtd_By,CM.I_No_Of_Session,CM.S_Upd_By,
	CM.C_AptitudeTestReqd,CM.Dt_Crtd_On,CM.Dt_Upd_On,CM.I_Status,
	CR.S_Certificate_Name,
	CF.S_CourseFamily_Name
	FROM dbo.T_Course_Master CM
    LEFT OUTER JOIN dbo.T_Certificate_Master CR
	ON CM.I_Certificate_ID = CR.I_Certificate_ID
	LEFT OUTER JOIN dbo.T_CourseFamily_Master CF	
	ON CM.I_CourseFamily_ID = CF.I_courseFamily_ID
	WHERE CM.I_Course_ID = @iCourseID
	AND CM.I_Status=1


	SELECT 
	I_Grading_Pattern_ID,S_Pattern_Name,I_Status,
	S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On
	FROM dbo.T_Grading_Pattern_Master 
	WHERE I_Grading_Pattern_ID = @iGradingPatternID
	AND I_Status=1

	SELECT 
	I_Grading_Pattern_Detail_ID,I_Grading_Pattern_Detail_ID,
	S_Grade_Type,I_MinMarks,I_MaxMarks
	FROM dbo.T_Grading_Pattern_Detail
	WHERE I_Grading_Pattern_Detail_ID = @iGradingPatternDetailID 


	SELECT
	DPM.I_Delivery_Pattern_ID,DPM.S_Pattern_Name,DPM.I_Status,DPM.I_No_Of_Session,
	DPM.N_Session_Day_Gap,DPM.S_Crtd_By,DPM.S_Upd_By,DPM.Dt_Crtd_On,DPM.Dt_Upd_On
	FROM dbo.T_Delivery_Pattern_Master DPM
	INNER JOIN dbo.T_Course_Delivery_Map CDM
	ON DPM.I_Delivery_Pattern_ID = CDM.I_Delivery_Pattern_ID
	AND CDM.I_Course_ID = @iCourseID 
	AND DPM.I_Status=1
	AND CDM.I_Status=1
			

	SELECT
	I_Course_Fee_Plan_ID,S_Fee_Plan_Name,I_Course_Delivery_ID,
	I_Course_ID,I_Currency_ID,S_Crtd_By,C_Is_LumpSum,N_TotalLumpSum,
	S_Upd_By,Dt_Crtd_On,N_TotalInstallment,Dt_Upd_On
	FROM dbo.T_Course_Fee_Plan
	WHERE I_Course_ID = @iCourseID


	SELECT 
	FD.I_Fee_Component_ID,FD.I_Course_Fee_Plan_ID,FD.I_Item_Value,
	FD.N_CompanyShare,FD.I_Installment_No,I_Sequence,C_Is_LumpSum,I_Display_Fee_Component_ID, 
	FD.S_Crtd_By,Dt_Crtd_On,S_Upd_By,Dt_Upd_On
	FROM dbo.T_Course_Fee_Plan_Detail FD
	WHERE I_Course_Fee_Plan_ID = @iCourseFeePlanID

    SELECT * FROM dbo.T_Term_Master 
	WHERE I_Term_ID IN
	(SELECT I_Term_ID FROM dbo.T_Term_Course_Map
	 WHERE I_Course_ID = @iCourseID
	 AND I_Status <> 0
	 AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())
	 AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE()))

END
