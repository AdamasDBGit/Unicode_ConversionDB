CREATE PROCEDURE [REPORT].[UspGetPreAssessmentResult]
(
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@dtStartDate datetime,
	@dtEndDate datetime
)
AS
	Begin
	
		DECLARE @ENQUIREDCOURSELIST VARCHAR(250)
		DECLARE @SUGGESTEDCOURSELIST VARCHAR(250)
		DECLARE @ADMITTEDCOURSELIST VARCHAR(250)
		DECLARE @TOTCOUNT INT
		DECLARE @CTR INT=1
		DECLARE @ENQ_ID INT

		DECLARE @PreAssessmentAnalysis TABLE
		(
			ID INT IDENTITY(1,1),
			I_Enquiry_Regn_ID INT,
			S_Enquiry_No VARCHAR(20),
			STUDENTNAME VARCHAR(750),
			ASSESSMENT VARCHAR(250),
			ExamComponantTypeID INT,
			ExamComponantTypeName VARCHAR(250),
			ExamComponantID INT,
			ExamComponantName Varchar(250),
			COMPETANCY VARCHAR(250),
			COMPITANCYMARKS INT,
			TOTAL_MARKS INT,
			RATING INT,
			ENQUIREDCOURSE VARCHAR(800),
			SUGGESTEDCOURSE VARCHAR(800),
			ADMITTEDCOURSE VARCHAR(800)
		)
		
		INSERT INTO @PreAssessmentAnalysis
		(
			[I_Enquiry_Regn_ID],
			[S_Enquiry_No],
			[STUDENTNAME],
			[ASSESSMENT],
			[ExamComponantTypeID],
			[ExamComponantTypeName],
			[ExamComponantID],
			[ExamComponantName],
			[COMPETANCY],
			[COMPITANCYMARKS],
			[TOTAL_MARKS],
			[RATING]
		)
		SELECT DISTINCT 
			   ERD.I_Enquiry_Regn_ID,
			   ERD.S_Enquiry_No,
			   ISNULL(ERD.S_First_Name,'')+' '+ISNULL(ERD.S_Middle_Name,'') AS STUDENTNAME,
			   Pm.S_PreAssessment_Name,
			   ETM.I_Exam_Type_Master_ID,
			   ETM.S_Exam_Type_Name,
			   PEM.I_Exam_Component_ID,
			   ECM.S_Component_Name,
			   CD.S_Competency_Name,
			   SCMD.N_Marks_Obtained,
			   SCMD.N_Total_Marks,
			   SAM.Total_Marks
		FROM ASSESSMENT.T_Student_Assessment_Map SAM
			   INNER JOIN dbo.T_Enquiry_Regn_Detail ERD ON SAM.I_Enquiry_Regn_ID=ERD.I_Enquiry_Regn_ID
			   INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
			   ON ERD.I_Centre_Id=FN1.CenterID 
			   INNER JOIN ASSESSMENT.T_PreAssessment_ExamComponent_Mapping PEM ON SAM.I_PreAssessment_ID=PEM.I_PreAssessment_ID
			   AND SAM.I_Exam_Component_ID=PEM.I_Exam_Component_ID
			   INNER JOIN dbo.T_Exam_Component_Master ECM ON ECM.I_Exam_Component_ID=PEM.I_Exam_Component_ID
			   INNER JOIN dbo.T_Exam_Type_Master ETM ON ECM.I_Exam_Type_Master_ID=ETM.I_Exam_Type_Master_ID
			   INNER JOIN ASSESSMENT.T_PreAssessment_Master PM ON PEM.I_PreAssessment_ID=PM.I_PreAssessment_ID
			   LEFT JOIN ASSESSMENT.T_Student_Competency_Marks_Details SCMD ON SAM.I_Enquiry_Regn_ID=SCMD.I_Enquiry_Regn_ID
			   AND SAM.I_Exam_Component_ID=SCMD.I_Exam_Component_ID
			   LEFT JOIN ASSESSMENT.T_Competency_Details CD ON CD.I_Competency_ID=SCMD.I_Competency_ID
		WHERE ERD.Dt_Crtd_On BETWEEN @dtStartDate AND @dtEndDate
		
		SELECT @TOTCOUNT=COUNT(*) FROM @PreAssessmentAnalysis
		
		WHILE @CTR <= @TOTCOUNT
			BEGIN
				SELECT @ENQ_ID=E.I_Enquiry_Regn_ID FROM @PreAssessmentAnalysis E WHERE E.ID=@CTR
				
				SET @ENQUIREDCOURSELIST=NULL
				SET @SUGGESTEDCOURSELIST=NULL
				SET @ADMITTEDCOURSELIST=NULL
				
				SELECT @ENQUIREDCOURSELIST=COALESCE(@ENQUIREDCOURSELIST+',', '') +S_Course_Name
				from
				(
				SELECT Distinct CM.S_Course_Name 
				FROM dbo.T_Enquiry_Regn_Detail ERD
					 INNER JOIN dbo.T_Enquiry_Course TEC ON ERD.I_Enquiry_Regn_ID=TEC.I_Enquiry_Regn_ID
					 INNER JOIN dbo.T_Course_Master CM ON TEC.I_Course_ID=CM.I_Course_ID
				WHERE ERD.I_Enquiry_Regn_ID=@ENQ_ID
				)
				as TMP
				
				SELECT @SUGGESTEDCOURSELIST=COALESCE(@SUGGESTEDCOURSELIST+',', '') +S_Course_Name
				from
				(
				SELECT Distinct CM.S_Course_Name 
				FROM ASSESSMENT.T_Student_Assessment_Suggestion TSAS
					 INNER JOIN ASSESSMENT.T_Student_Assessment_Map TSAM ON TSAS.I_Enquiry_Regn_ID=TSAM.I_Enquiry_Regn_ID
					 AND TSAM.B_Is_Complete=1
					 INNER JOIN ASSESSMENT.T_Assessment_CourseList_Course_Map TACCM ON TSAS.I_CourseList_ID=TACCM.I_Course_List_ID
					 INNER JOIN dbo.T_Course_Master CM ON TACCM.I_Course_ID=CM.I_Course_ID
				WHERE TSAS.I_Enquiry_Regn_ID=@ENQ_ID
				)
				as TMP
				
				SELECT @ADMITTEDCOURSELIST=COALESCE(@ADMITTEDCOURSELIST+',', '') +S_Course_Name
				from
				(
				SELECT Distinct CM.S_Course_Name 
				FROM dbo.T_Enquiry_Regn_Detail ERD
					 INNER JOIN dbo.T_Student_Detail SD ON ERD.I_Enquiry_Regn_ID=SD.I_Enquiry_Regn_ID
					 INNER JOIN dbo.T_Student_Batch_Details TSBD ON SD.I_Student_Detail_ID=TSBD.I_Student_ID
					 INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID=TSBM.I_Batch_ID	
					 INNER JOIN dbo.T_Course_Master CM ON TSBM.I_Course_ID=CM.I_Course_ID
				WHERE ERD.I_Enquiry_Regn_ID=@ENQ_ID
				)
				as TMP

				
				UPDATE @PreAssessmentAnalysis SET 
				ENQUIREDCOURSE=@ENQUIREDCOURSELIST,
				SUGGESTEDCOURSE=@SUGGESTEDCOURSELIST,
				ADMITTEDCOURSE=@ADMITTEDCOURSELIST
				WHERE ID=@CTR
			SET @CTR=@CTR+1
			END
		
		SELECT * FROM @PreAssessmentAnalysis
	END
	
	
	
--Select * from ASSESSMENT.T_Student_Competency_Marks_Details
SELECT * FROM ASSESSMENT.T_PreAssessment_ExamComponent_Mapping AS tpaecm Where tpaecm.I_PreAssessment_ID in
(
Select I_PreAssessment_ID from ASSESSMENT.T_Student_Assessment_Map Where I_Enquiry_Regn_ID=338358
)
--SELECT * FROM dbo.T_Exam_Component_Master AS tecm
--SELECT * FROM dbo.T_Exam_Type_Master AS tetm
SELECT * FROM ASSESSMENT.T_Student_Competency_Marks_Details

		--SELECT DISTINCT 
		--	   ERD.I_Enquiry_Regn_ID,
		--	   ERD.S_Enquiry_No,
		--	   ISNULL(ERD.S_First_Name,'')+' '+ISNULL(ERD.S_Middle_Name,'') AS STUDENTNAME,
		--	   Pm.S_PreAssessment_Name,
		--	   ETM.I_Exam_Type_Master_ID,
		--	   ETM.S_Exam_Type_Name,
		--	   PEM.I_Exam_Component_ID,
		--	   ECM.S_Component_Name,
		--	   CD.S_Competency_Name,
		--	   SCMD.N_Marks_Obtained,
		--	   SCMD.N_Total_Marks,
		--	   SAM.Total_Marks
		--FROM ASSESSMENT.T_Student_Assessment_Map SAM
		--	   INNER JOIN dbo.T_Enquiry_Regn_Detail ERD ON SAM.I_Enquiry_Regn_ID=ERD.I_Enquiry_Regn_ID
		--	   INNER JOIN [dbo].[fnGetCentersForReports](1, 2) FN1
		--	   ON ERD.I_Centre_Id=FN1.CenterID 
		--	   INNER JOIN ASSESSMENT.T_PreAssessment_ExamComponent_Mapping PEM ON SAM.I_PreAssessment_ID=PEM.I_PreAssessment_ID
		--	   AND SAM.I_Exam_Component_ID=PEM.I_Exam_Component_ID
		--	   INNER JOIN dbo.T_Exam_Component_Master ECM ON ECM.I_Exam_Component_ID=PEM.I_Exam_Component_ID
		--	   INNER JOIN dbo.T_Exam_Type_Master ETM ON ECM.I_Exam_Type_Master_ID=ETM.I_Exam_Type_Master_ID
		--	   INNER JOIN ASSESSMENT.T_PreAssessment_Master PM ON PEM.I_PreAssessment_ID=PM.I_PreAssessment_ID
		--	   LEFT JOIN ASSESSMENT.T_Student_Competency_Marks_Details SCMD ON SAM.I_Enquiry_Regn_ID=SCMD.I_Enquiry_Regn_ID
		--	   AND SAM.I_Exam_Component_ID=SCMD.I_Exam_Component_ID
		--	   LEFT JOIN ASSESSMENT.T_Competency_Details CD ON CD.I_Competency_ID=SCMD.I_Competency_ID
