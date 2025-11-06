/*
-- =================================================================
-- Author:Chandan Dey
-- Modified By :
-- Create date:13/09/2007
-- Description: Select List Approve/Reject/Pending Status from Re-Issue Request List record in T_Student_Certificate_Request table
-- =================================================================
*/
CREATE PROCEDURE [PSCERTIFICATE].[uspGetReIssueStatusList]
(
	@iCenterID		INT = NULL,
	@iCourseID		INT = NULL,
	@iTermID		INT = NULL,
	@dtFromDate		DATETIME,
	@dtToDate		DATETIME,
	@HierarchyDetailID INT =NULL,
	@iBrandID		INT,
	@CourseFamilyIDList INT = NULL
 
)
AS
BEGIN

IF(@dtTodate IS NOT NULL)
BEGIN
	SET @dtTodate = DATEADD(dd,1,@dtTodate)
END 

--Get course list from course family
DECLARE @TempCourse TABLE
(
 I_Course_ID INT
)

IF( @CourseFamilyIDList IS NOT NULL)
 BEGIN
	INSERT INTO @TempCourse
	SELECT I_Course_ID FROM dbo.T_Course_Master 
	WHERE I_CourseFamily_ID = @CourseFamilyIDList
	AND I_Course_ID= COALESCE(@iCourseID, I_Course_ID)
 END
ELSE
	BEGIN
		INSERT INTO @TempCourse
		SELECT I_Course_ID FROM dbo.T_Course_Master 
		--WHERE I_Course_IDI_CourseFamily_ID = @CourseFamilyIDList
	END



IF(@iTermID IS NOT NULL)
	BEGIN
	   SELECT 
			DISTINCT(SD.I_Student_Detail_ID) AS  I_Student_Detail_ID
			,ISNULL(SD.S_First_Name,'') AS  S_First_Name
			,ISNULL(SD.S_Middle_Name,'') AS  S_Middle_Name
			,ISNULL(SD.S_Last_Name,'') AS  S_Last_Name
			,ISNULL(CM.S_Center_Name,'') AS  S_Center_Name
			,ISNULL(COM.S_Course_Name,'') AS S_Course_Name
			,ISNULL(TM.S_Term_Name,'') AS  S_Term_Name
			,ISNULL(SCR.Dt_Crtd_On,'') AS  Dt_Crtd_On
			,ISNULL(SPC.B_PS_Flag,0) AS B_PS_Flag
			,ISNULL(SCR.I_Status,0) AS I_Status
			,SCOD.I_Batch_ID
		 FROM [PSCERTIFICATE].T_Student_Certificate_Request SCR
			  INNER JOIN [PSCERTIFICATE].T_Student_PS_Certificate SPC
			  ON SPC.I_Student_Certificate_ID = SCR.I_Student_Certificate_ID
			  INNER JOIN dbo.T_Student_Detail SD
			  ON SD.I_Student_Detail_ID = SPC.I_Student_Detail_ID
			  INNER JOIN dbo.T_Student_Center_Detail SCD
			  ON SCD.I_Student_Detail_ID = SPC.I_Student_Detail_ID
			  INNER JOIN dbo.T_Centre_Master CM
			  ON CM.I_Centre_Id = SCD.I_Centre_Id
			  INNER JOIN dbo.T_Student_Course_Detail SCOD
				ON SD.I_Student_Detail_ID = SCOD.I_Student_Detail_ID
				AND SPC.I_Course_ID = SCOD.I_Course_ID
				AND SCOD.I_Status = 1
			  INNER JOIN dbo.T_Course_Master COM
			  ON COM.I_Course_ID = SPC.I_Course_ID
			  LEFT OUTER JOIN dbo.T_Term_Master TM
			  ON TM.I_Term_ID = SPC.I_Term_ID
	     
		 WHERE
			  SCR.I_Status IN(4,5,6)
			  --AND SCD.I_Centre_ID = COALESCE(@iCenterID, SCD.I_Centre_ID)
			  AND SCD.I_Centre_ID IN ( SELECT FN1.I_Center_ID FROM [dbo].[fnGetCenterIDFromHierarchy](@HierarchyDetailID,@iBrandID) FN1)
			  AND SPC.I_Course_ID = COALESCE(@iCourseID, SPC.I_Course_ID)
			  --AND SPC.I_Course_ID IN (SELECT I_Course_ID FROM @TempCourse)
			  AND SPC.I_Term_ID = COALESCE(@iTermID, SPC.I_Term_ID)
			  AND SCR.Dt_Crtd_On BETWEEN @dtFromDate AND @dtToDate  -->= COALESCE(@fromDate, SCR.Dt_Crtd_On)
			  --AND SCR.Dt_Crtd_On <= COALESCE(@toDate, SCR.Dt_Crtd_On)
	END
ELSE IF(@iCourseID IS NULL AND @iTermID IS NULL)
	BEGIN
	   SELECT 
			DISTINCT(SD.I_Student_Detail_ID) AS  I_Student_Detail_ID
			,ISNULL(SD.S_First_Name,'') AS  S_First_Name
			,ISNULL(SD.S_Middle_Name,'') AS  S_Middle_Name
			,ISNULL(SD.S_Last_Name,'') AS  S_Last_Name
			,ISNULL(CM.S_Center_Name,'') AS  S_Center_Name
			,ISNULL(COM.S_Course_Name,'') AS S_Course_Name
			,ISNULL(TM.S_Term_Name,'') AS  S_Term_Name
			,ISNULL(SCR.Dt_Crtd_On,'') AS  Dt_Crtd_On
			,ISNULL(SPC.B_PS_Flag,0) AS B_PS_Flag
			,ISNULL(SCR.I_Status,0) AS I_Status
			,SCOD.I_Batch_ID
		 FROM [PSCERTIFICATE].T_Student_Certificate_Request SCR
			  INNER JOIN [PSCERTIFICATE].T_Student_PS_Certificate SPC
			  ON SPC.I_Student_Certificate_ID = SCR.I_Student_Certificate_ID
			  INNER JOIN dbo.T_Student_Detail SD
			  ON SD.I_Student_Detail_ID = SPC.I_Student_Detail_ID
			  INNER JOIN dbo.T_Student_Center_Detail SCD
			  ON SCD.I_Student_Detail_ID = SPC.I_Student_Detail_ID
			  INNER JOIN dbo.T_Centre_Master CM
			  ON CM.I_Centre_Id = SCD.I_Centre_Id
			  INNER JOIN dbo.T_Student_Course_Detail SCOD
				ON SD.I_Student_Detail_ID = SCOD.I_Student_Detail_ID
				AND SPC.I_Course_ID = SCOD.I_Course_ID
				AND SCOD.I_Status = 1
			  INNER JOIN dbo.T_Course_Master COM
			  ON COM.I_Course_ID = SPC.I_Course_ID
			  LEFT OUTER JOIN dbo.T_Term_Master TM
			  ON TM.I_Term_ID = SPC.I_Term_ID
	     
		 WHERE
			  SCR.I_Status IN(4,5,6)
			  AND SCD.I_Centre_ID IN ( SELECT FN1.I_Center_ID FROM [dbo].[fnGetCenterIDFromHierarchy](@HierarchyDetailID,@iBrandID) FN1)
			  AND SCR.Dt_Crtd_On BETWEEN @dtFromDate AND @dtToDate  -->= COALESCE(@fromDate, SCR.Dt_Crtd_On)
			  AND SPC.I_Course_ID IN (SELECT I_Course_ID FROM @TempCourse)	
	END
ELSE IF(@iTermID IS NULL)
	BEGIN
	   SELECT 
			DISTINCT(SD.I_Student_Detail_ID) AS  I_Student_Detail_ID
			,ISNULL(SD.S_First_Name,'') AS  S_First_Name
			,ISNULL(SD.S_Middle_Name,'') AS  S_Middle_Name
			,ISNULL(SD.S_Last_Name,'') AS  S_Last_Name
			,ISNULL(CM.S_Center_Name,'') AS  S_Center_Name
			,ISNULL(COM.S_Course_Name,'') AS S_Course_Name
			,ISNULL(TM.S_Term_Name,'') AS  S_Term_Name
			,ISNULL(SCR.Dt_Crtd_On,'') AS  Dt_Crtd_On
			,ISNULL(SPC.B_PS_Flag,0) AS B_PS_Flag
			,ISNULL(SCR.I_Status,0) AS I_Status
			,SCOD.I_Batch_ID
		 FROM [PSCERTIFICATE].T_Student_Certificate_Request SCR
			  INNER JOIN [PSCERTIFICATE].T_Student_PS_Certificate SPC
			  ON SPC.I_Student_Certificate_ID = SCR.I_Student_Certificate_ID
			  INNER JOIN dbo.T_Student_Detail SD
			  ON SD.I_Student_Detail_ID = SPC.I_Student_Detail_ID
			  INNER JOIN dbo.T_Student_Center_Detail SCD
			  ON SCD.I_Student_Detail_ID = SPC.I_Student_Detail_ID
			  INNER JOIN dbo.T_Centre_Master CM
			  ON CM.I_Centre_Id = SCD.I_Centre_Id
			  INNER JOIN dbo.T_Student_Course_Detail SCOD
				ON SD.I_Student_Detail_ID = SCOD.I_Student_Detail_ID
				AND SPC.I_Course_ID = SCOD.I_Course_ID
				AND SCOD.I_Status = 1
			  INNER JOIN dbo.T_Course_Master COM
			  ON COM.I_Course_ID = SPC.I_Course_ID
			  LEFT OUTER JOIN dbo.T_Term_Master TM
			  ON TM.I_Term_ID = SPC.I_Term_ID
	     
		 WHERE
			  SCR.I_Status IN(4,5,6)
			  AND SCD.I_Centre_ID IN ( SELECT FN1.I_Center_ID FROM [dbo].[fnGetCenterIDFromHierarchy](@HierarchyDetailID,@iBrandID) FN1)
			  AND SPC.I_Course_ID = COALESCE(@iCourseID, SPC.I_Course_ID)
			  AND SPC.I_Term_ID IS NULL
			  AND SCR.Dt_Crtd_On BETWEEN @dtFromDate AND @dtToDate  -->= COALESCE(@fromDate, SCR.Dt_Crtd_On)
			 
	END
END
