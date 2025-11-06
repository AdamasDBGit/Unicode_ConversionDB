/****************************************************************
Author	:     Swagatam Sarkar
Date	:	  02/Jan/2008
Description : This SP retrieves the Marks Distribution of a Term
				
****************************************************************/

CREATE PROCEDURE [REPORT].[uspGetMarksDistributionReport]
(
	-- Add the parameters for the stored procedure here
	@sHierarchyList varchar(100),
	@iBrandID int,
	@DtFrmDate datetime,
	@DtToDate datetime,
	@iCourseFamilyID int,
	@svCourseFamilyName varchar(50),
	@iCourseID int,
	@svCourseName varchar(50),
	@iTermID INT = NULL,
	@svTermName varchar(50) = NULL
)
AS
BEGIN TRY
	BEGIN
		
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @StudentMarks TABLE
	(
		I_Centre_ID INT,
		S_Center_Name VARCHAR(50),
		S_Course_Name VARCHAR(50),
		S_Term_Name VARCHAR(50),
		I_Student_Detail_ID INT,
		S_Title VARCHAR(10),
		S_First_Name VARCHAR(50),
		S_Middle_Name VARCHAR(50),
		S_Last_Name VARCHAR(50),
		S_Term_Final_Marks INT
	)

	DECLARE @CenterReport TABLE
	(
		I_Centre_ID INT,
		S_Center_Name VARCHAR(50),
		S_Course_Family_Name VARCHAR(50),
		S_Course_Name VARCHAR(50),
		S_Term_Name VARCHAR(50),
		Total_Students INT,
		Total_LT_40 INT,
		Total_LT_50 INT,
		Total_LT_60 INT,
		Total_LT_70 INT,
		Total_LT_80 INT,
		Total_LT_90 INT,
		Total_LT_95 INT,
		Total_LT_100 INT
	)

	DECLARE @iTotalStudents INT, @iTotalLT40 INT, @iTotalLT50 INT, @iTotalLT60 INT, @iTotalLT70 INT
	DECLARE @iTotalLT80 INT, @iTotalLT90 INT, @iTotalLT95 INT, @iTotalLT100 INT
	DECLARE @sCourseFamilyName VARCHAR(50)
	SET @sCourseFamilyName = (SELECT S_CourseFamily_Name FROM dbo.T_CourseFamily_Master WHERE I_CourseFamily_ID = @iCourseFamilyID)

	IF (@DtToDate IS NOT NULL)
	BEGIN
		SET @DtToDate = DATEADD(dd,1,@DtToDate)
	END

	DECLARE @iCenterID INT

	DECLARE CenterList CURSOR FOR
	SELECT CenterID FROM [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID)

	OPEN CenterList
	FETCH NEXT FROM CenterList INTO @iCenterID
	
	WHILE @@FETCH_STATUS = 0
	BEGIN

		DELETE FROM @StudentMarks

		INSERT INTO @StudentMarks
		SELECT DISTINCT TCM.I_Centre_Id,TCM.S_Center_Name,CM.S_Course_Name,TM.S_Term_Name,
			STD.I_Student_Detail_ID,SD.S_Title,SD.S_First_Name,SD.S_Middle_Name,SD.S_Last_Name,
			STD.S_Term_Final_Marks
		FROM dbo.T_Student_Term_Detail STD
		INNER JOIN dbo.T_Student_Detail SD 
			ON STD.I_Student_Detail_ID = SD.I_Student_Detail_ID
		INNER JOIN dbo.T_Student_Center_Detail SCEN 
			ON SD.I_Student_Detail_ID=SCEN.I_Student_Detail_ID
			AND SCEN.I_Centre_Id = @iCenterID
		INNER JOIN PSCERTIFICATE.T_Student_PS_Certificate SPC 
			ON SPC.I_Student_Detail_ID = SD.I_Student_Detail_ID 
			AND SPC.I_Course_ID = STD.I_Course_ID AND ISNULL(SPC.I_Term_ID,STD.I_Term_ID) = STD.I_Term_ID
			AND SPC.Dt_Certificate_Issue_Date BETWEEN @DtFrmDate AND @DtToDate
			--AND SPC.B_PS_Flag = 1
		INNER JOIN PSCERTIFICATE.T_Certificate_Logistic CL
			ON CL.I_Student_Certificate_ID = SPC.I_Student_Certificate_ID
			AND CL.I_Status = 1
		INNER JOIN dbo.T_Course_Master CM
			ON STD.I_Course_ID = CM.I_Course_ID
		INNER JOIN dbo.T_Term_Master TM
			ON STD.I_Term_ID = TM.I_Term_ID
		INNER JOIN dbo.T_Centre_Master TCM
			ON SCEN.I_Centre_Id = TCM.I_Centre_Id
		WHERE STD.S_Term_Final_Marks IS NOT NULL AND STD.S_Term_Final_Marks < 100
			AND STD.I_Course_ID = @iCourseID
			AND STD.I_Term_ID = ISNULL(@iTermID,STD.I_Term_ID)
		ORDER BY STD.S_Term_Final_Marks DESC

		SET @iTotalStudents = (SELECT COUNT(*) FROM @StudentMarks)
		SET @iTotalLT40 = (SELECT COUNT(*) FROM @StudentMarks WHERE S_Term_Final_Marks < 40)
		SET @iTotalLT50 = (SELECT COUNT(*) FROM @StudentMarks WHERE S_Term_Final_Marks >= 40 AND S_Term_Final_Marks < 50)
		SET @iTotalLT60 = (SELECT COUNT(*) FROM @StudentMarks WHERE S_Term_Final_Marks >= 50 AND S_Term_Final_Marks < 60)
		SET @iTotalLT70 = (SELECT COUNT(*) FROM @StudentMarks WHERE S_Term_Final_Marks >= 60 AND S_Term_Final_Marks < 70)
		SET @iTotalLT80 = (SELECT COUNT(*) FROM @StudentMarks WHERE S_Term_Final_Marks >= 70 AND S_Term_Final_Marks < 80)
		SET @iTotalLT90 = (SELECT COUNT(*) FROM @StudentMarks WHERE S_Term_Final_Marks >= 80 AND S_Term_Final_Marks < 90)
		SET @iTotalLT95 = (SELECT COUNT(*) FROM @StudentMarks WHERE S_Term_Final_Marks >= 90 AND S_Term_Final_Marks < 95)
		SET @iTotalLT100 = (SELECT COUNT(*) FROM @StudentMarks WHERE S_Term_Final_Marks >= 95 AND S_Term_Final_Marks < 100)

		INSERT INTO @CenterReport
		SELECT DISTINCT I_Centre_Id,S_Center_Name,@sCourseFamilyName,S_Course_Name,S_Term_Name,
						@iTotalStudents AS Total_Students,@iTotalLT40 AS Total_LT_40,
						@iTotalLT50 AS Total_LT_50,@iTotalLT60 AS Total_LT_60,
						@iTotalLT70 AS Total_LT_70,@iTotalLT80 AS Total_LT_80,
						@iTotalLT90 AS Total_LT_90,@iTotalLT95 AS Total_LT_95,
						@iTotalLT100 AS Total_LT_100
		FROM @StudentMarks

		FETCH NEXT FROM CenterList INTO @iCenterID

	END
	
	CLOSE CenterList
	DEALLOCATE CenterList

	SELECT CR.*,FN2.InstanceChain FROM @CenterReport CR
	INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
		ON CR.I_Centre_Id=FN1.CenterID
	INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
		ON FN1.HierarchyDetailID=FN2.HierarchyDetailID

	END
END TRY

BEGIN CATCH
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
