CREATE PROCEDURE [REPORT].[UspGetPreAssessmentAnalysis]
(
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@dtStartDate datetime,
	@dtEndDate datetime
)
AS
	Begin
		DECLARE @Assess TABLE
		(
			ID INT IDENTITY(1,1),
			CenterID INT,
			Center VARCHAR(250),
			CourseFamily Varchar(250),
			CourseID INT,
			CourseName Varchar(250),
			CourseFamilyName Varchar(250),
			NoOfEnquiry BIGINT,
			AssessedEnQ BIGINT,
			SuggestedSame BIGINT,
			SuggestedDifferent BIGINT,
			AdmittedSame BIGINT,
			AdmittedDifferent BIGINT
		)
		
		INSERT INTO @Assess
		(
		[CenterID],
		[Center],
		[CourseFamily],
		[CourseID],
		[CourseName],
		[CourseFamilyName]
		)
		Select distinct
			   FN1.centerID,
			   FN1.centerName,
			   CFM.S_CourseFamily_Name,
			   tacm.I_Course_ID,
			   CM.S_Course_Name,
			   CFM.S_CourseFamily_Name
		FROM ASSESSMENT.T_Student_Assessment_Map TSAM
				INNER JOIN ASSESSMENT.T_Assessment_Course_Map AS tacm ON tsam.I_PreAssessment_ID = tacm.I_PreAssessment_ID
				INNER JOIN dbo.T_Enquiry_Regn_Detail AS terd ON terd.I_Enquiry_Regn_ID = tsam.I_Enquiry_Regn_ID
				INNER JOIN [dbo].[fnGetCentersForReports](1, 2) FN1
				ON terd.I_Centre_Id=FN1.CenterID
				INNER JOIN dbo.T_Course_Master CM ON tacm.I_Course_ID=CM.I_Course_ID
				INNER JOIN dbo.T_CourseFamily_Master CFM ON CM.I_CourseFamily_ID=CFM.I_CourseFamily_ID
		WHERE TSAM.B_Is_Complete=1
		
		UPDATE @Assess SET NoOfEnquiry=ISNULL(ENQUIRY,0),
		AssessedEnQ=ISNULL(ASSESSED,0),
		SuggestedSame=ISNULL(SUGGESTED,0),
		SuggestedDifferent=ISNULL(SUGGESTDIFF,0),
		AdmittedSame=ISNULL(ADMITTED,0),
		AdmittedDifferent=ISNULL(ADMITDIFF,0)
		FROM @Assess A 
		Left JOIN
		(
			SELECT EC.I_Course_ID,ERD.I_Centre_Id,COUNT(distinct ERD.I_Enquiry_Regn_ID) AS ENQUIRY
			FROM dbo.T_Enquiry_Regn_Detail ERD
			INNER JOIN dbo.T_Enquiry_Course EC ON ERD.I_Enquiry_Regn_ID=EC.I_Enquiry_Regn_ID
			WHERE ERD.Dt_Crtd_On BETWEEN @dtStartDate AND @dtEndDate
			GROUP BY EC.I_Course_ID,ERD.I_Centre_Id
		)
		AS ENQ ON A.CenterID=ENQ.I_Centre_Id AND A.CourseID=ENQ.I_Course_ID
		LEFT JOIN
		(
			SELECT tacm.I_Course_ID,ERD.I_Centre_Id,COUNT(Distinct TSAM.I_Enquiry_Regn_ID) AS ASSESSED
			FROM dbo.T_Enquiry_Regn_Detail ERD
			INNER JOIN dbo.T_Enquiry_Course EC ON ERD.I_Enquiry_Regn_ID=EC.I_Enquiry_Regn_ID
			INNER JOIN ASSESSMENT.T_Student_Assessment_Map TSAM ON ERD.I_Enquiry_Regn_ID=TSAM.I_Enquiry_Regn_ID
			AND TSAM.B_Is_Complete=1
			INNER JOIN ASSESSMENT.T_Assessment_Course_Map AS tacm ON tsam.I_PreAssessment_ID = tacm.I_PreAssessment_ID
			AND EC.I_Course_ID=tacm.I_Course_ID
			WHERE ERD.Dt_Crtd_On BETWEEN @dtStartDate AND @dtEndDate
			GROUP BY tacm.I_Course_ID,ERD.I_Centre_Id
		)
		AS ASSESS ON A.CenterID=ASSESS.I_Centre_Id AND A.CourseID=ASSESS.I_Course_ID
		LEFT JOIN
		(
			SELECT TACCM.I_Course_ID,ERD.I_Centre_Id,COUNT(distinct TSAM.I_Enquiry_Regn_ID) AS SUGGESTED
			FROM dbo.T_Enquiry_Regn_Detail ERD
			INNER JOIN dbo.T_Enquiry_Course EC ON ERD.I_Enquiry_Regn_ID=EC.I_Enquiry_Regn_ID
			INNER JOIN ASSESSMENT.T_Student_Assessment_Suggestion TSAS ON ERD.I_Enquiry_Regn_ID=TSAS.I_Enquiry_Regn_ID
			INNER JOIN ASSESSMENT.T_Student_Assessment_Map TSAM ON TSAS.I_Enquiry_Regn_ID=TSAM.I_Enquiry_Regn_ID
			AND TSAM.B_Is_Complete=1
			INNER JOIN ASSESSMENT.T_Assessment_CourseList_Course_Map TACCM ON TSAS.I_CourseList_ID=TACCM.I_Course_List_ID
			AND EC.I_Course_ID=TACCM.I_Course_ID
			WHERE ERD.Dt_Crtd_On BETWEEN @dtStartDate AND @dtEndDate
			GROUP BY TACCM.I_Course_ID,ERD.I_Centre_Id
		)
		AS SUGGEST ON A.CenterID=SUGGEST.I_Centre_Id AND A.CourseID=SUGGEST.I_Course_ID
		LEFT JOIN
		(
			SELECT EC.I_Course_ID,ERD.I_Centre_Id,COUNT(distinct TSAM.I_Enquiry_Regn_ID) AS SUGGESTDIFF
			FROM dbo.T_Enquiry_Regn_Detail ERD
			INNER JOIN dbo.T_Enquiry_Course EC ON ERD.I_Enquiry_Regn_ID=EC.I_Enquiry_Regn_ID
			INNER JOIN ASSESSMENT.T_Student_Assessment_Suggestion TSAS ON ERD.I_Enquiry_Regn_ID=TSAS.I_Enquiry_Regn_ID
			INNER JOIN ASSESSMENT.T_Student_Assessment_Map TSAM ON TSAS.I_Enquiry_Regn_ID=TSAM.I_Enquiry_Regn_ID
			AND TSAM.B_Is_Complete=1
			INNER JOIN ASSESSMENT.T_Assessment_CourseList_Course_Map TACCM ON TSAS.I_CourseList_ID=TACCM.I_Course_List_ID
			AND EC.I_Course_ID<>TACCM.I_Course_ID
			AND TSAM.I_Enquiry_Regn_ID not in
			(
				SELECT distinct TSAM.I_Enquiry_Regn_ID
				FROM dbo.T_Enquiry_Regn_Detail ERD
				INNER JOIN dbo.T_Enquiry_Course EC ON ERD.I_Enquiry_Regn_ID=EC.I_Enquiry_Regn_ID
				INNER JOIN ASSESSMENT.T_Student_Assessment_Suggestion TSAS ON ERD.I_Enquiry_Regn_ID=TSAS.I_Enquiry_Regn_ID
				INNER JOIN ASSESSMENT.T_Student_Assessment_Map TSAM ON TSAS.I_Enquiry_Regn_ID=TSAM.I_Enquiry_Regn_ID
				AND TSAM.B_Is_Complete=1
				INNER JOIN ASSESSMENT.T_Assessment_CourseList_Course_Map TACCM ON TSAS.I_CourseList_ID=TACCM.I_Course_List_ID
				AND EC.I_Course_ID=TACCM.I_Course_ID
			)
			--WHERE ERD.Dt_Crtd_On BETWEEN @dtStartDate AND @dtEndDate
			GROUP BY EC.I_Course_ID,ERD.I_Centre_Id
		)
		AS SUGGESTDIFF ON A.CenterID=SUGGESTDIFF.I_Centre_Id AND A.CourseID=SUGGESTDIFF.I_Course_ID
		LEFT JOIN
		(
			SELECT EC.I_Course_ID,ERD.I_Centre_Id,COUNT(distinct TSAM.I_Enquiry_Regn_ID) AS ADMITTED
			FROM dbo.T_Enquiry_Regn_Detail ERD
			INNER JOIN dbo.T_Enquiry_Course EC ON ERD.I_Enquiry_Regn_ID=EC.I_Enquiry_Regn_ID
			INNER JOIN ASSESSMENT.T_Student_Assessment_Suggestion TSAS ON ERD.I_Enquiry_Regn_ID=TSAS.I_Enquiry_Regn_ID
			INNER JOIN ASSESSMENT.T_Student_Assessment_Map TSAM ON TSAS.I_Enquiry_Regn_ID=TSAM.I_Enquiry_Regn_ID
			AND TSAM.B_Is_Complete=1
			INNER JOIN ASSESSMENT.T_Assessment_CourseList_Course_Map TACCM ON TSAS.I_CourseList_ID=TACCM.I_Course_List_ID
			AND EC.I_Course_ID=TACCM.I_Course_ID
			INNER JOIN dbo.T_Student_Detail TSD ON TSAS.I_Enquiry_Regn_ID=TSD.I_Enquiry_Regn_ID
			INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSD.I_Student_Detail_ID=TSBD.I_Student_ID
			INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID=TSBM.I_Batch_ID
			AND TACCM.I_Course_ID=TSBM.I_Course_ID
			WHERE ERD.Dt_Crtd_On BETWEEN @dtStartDate AND @dtEndDate
			GROUP BY EC.I_Course_ID,ERD.I_Centre_Id
		)
		AS ADMITSAME ON A.CenterID=ADMITSAME.I_Centre_Id AND A.CourseID=ADMITSAME.I_Course_ID
		LEFT JOIN
		(
			SELECT EC.I_Course_ID,ERD.I_Centre_Id,COUNT(distinct TSAM.I_Enquiry_Regn_ID) AS ADMITDIFF
			FROM dbo.T_Enquiry_Regn_Detail ERD
			INNER JOIN dbo.T_Enquiry_Course EC ON ERD.I_Enquiry_Regn_ID=EC.I_Enquiry_Regn_ID
			INNER JOIN ASSESSMENT.T_Student_Assessment_Suggestion TSAS ON ERD.I_Enquiry_Regn_ID=TSAS.I_Enquiry_Regn_ID
			INNER JOIN ASSESSMENT.T_Student_Assessment_Map TSAM ON TSAS.I_Enquiry_Regn_ID=TSAM.I_Enquiry_Regn_ID
			AND TSAM.B_Is_Complete=1
			INNER JOIN ASSESSMENT.T_Assessment_CourseList_Course_Map TACCM ON TSAS.I_CourseList_ID=TACCM.I_Course_List_ID
			AND EC.I_Course_ID=TACCM.I_Course_ID
			INNER JOIN dbo.T_Student_Detail TSD ON TSAS.I_Enquiry_Regn_ID=TSD.I_Enquiry_Regn_ID
			INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSD.I_Student_Detail_ID=TSBD.I_Student_ID
			INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID=TSBM.I_Batch_ID
			AND TACCM.I_Course_ID<>TSBM.I_Course_ID
			WHERE ERD.Dt_Crtd_On BETWEEN @dtStartDate AND @dtEndDate
			GROUP BY EC.I_Course_ID,ERD.I_Centre_Id
		)
		AS ADMITDIFF ON A.CenterID=ADMITDIFF.I_Centre_Id AND A.CourseID=ADMITDIFF.I_Course_ID

		SELECT TCHNM.S_Brand_Name,TCHNM.S_Region_Name,TCHNM.S_Territiry_Name,TCHNM.S_City_Name,TCHNM.S_Center_Name,A.* 
		FROM @Assess A
		INNER JOIN T_Center_Hierarchy_Name_Details TCHNM ON A.CenterID=TCHNM.I_Center_ID
		ORDER BY Center
	End
	
	
--Select * from ASSESSMENT.T_Assessment_CourseList_Course_Map WHERE I_Course_List_ID in
--(
--Select I_CourseList_ID from ASSESSMENT.T_Student_Assessment_Suggestion Where I_Enquiry_Regn_ID in
--(
--Select I_Enquiry_Regn_ID from ASSESSMENT.T_Student_Assessment_Map Where B_Is_Complete=1 --And I_Enquiry_Regn_ID=338338
--)
--)

--Select * from dbo.T_Course_Center_Detail
