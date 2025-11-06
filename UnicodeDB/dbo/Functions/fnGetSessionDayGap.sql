-- =============================================
-- Author:		Swagata De
-- Create date: '23/04/2007'
-- Description:	This Function returns the session day gap for a particular student in a particular 
--				center AND FOR a particular course
-- Return: sessionday gap (int)
-- =============================================

CREATE FUNCTION [dbo].[fnGetSessionDayGap]
(
	@iStudentDetailId INT,
	@iCenterId INT,
	@iCourseId INT
)  
RETURNS  INT

AS
BEGIN 
DECLARE @iSessionDayGap INT
DECLARE @tblTemp TABLE
	(
		[ID] int identity(1,1),
		CourseID int,		
		DeliveryPatternId int,		
		SessionDayGapDP int		
	)

--Get all courses that a student has taken
	
	INSERT INTO @tblTemp(CourseID)
	SELECT I_Course_ID FROM dbo.T_Student_Course_Detail
	WHERE I_Student_Detail_ID=@iStudentDetailId

	UPDATE TT
	SET TT.DeliveryPatternId=TTEMP.I_Delivery_Pattern_ID
	FROM @tblTemp TT,
	(SELECT CDM.I_Delivery_Pattern_ID,CDM.I_Course_ID,CDM.N_Course_Duration 
	FROM dbo.T_Course_Delivery_Map CDM,(SELECT CCDF.I_Course_Delivery_ID FROM dbo.T_Course_Center_Delivery_FeePlan CCDF,
	(SELECT I_Course_Center_ID FROM dbo.T_Course_Center_Detail WHERE I_Centre_Id=@iCenterId
	AND I_Course_ID IN (SELECT CourseID FROM @tblTemp)) CCD WHERE CCDF.I_Course_Center_ID=CCD.I_Course_Center_ID)TCCD
	WHERE CDM.I_Course_Delivery_ID = TCCD.I_Course_Delivery_ID) TTEMP	
	WHERE TT.CourseID=TTEMP.I_Course_ID
--Get all delivery pattern Ids
	UPDATE TT
	SET TT.SessionDayGapDP=DPM.N_Session_Day_Gap
	FROM @tblTemp TT,dbo.T_Delivery_Pattern_Master DPM
	WHERE TT.DeliveryPatternId=DPM.I_Delivery_Pattern_ID AND DPM.I_Status<>0

	SET @iSessionDayGap=( SELECT SessionDayGapDP FROM @tblTemp WHERE CourseID=@iCourseId)
	RETURN @iSessionDayGap
END