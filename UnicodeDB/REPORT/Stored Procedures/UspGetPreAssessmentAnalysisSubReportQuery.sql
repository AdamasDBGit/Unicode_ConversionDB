CREATE PROCEDURE [REPORT].[UspGetPreAssessmentAnalysisSubReportQuery]
(
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@dtStartDate datetime,
	@dtEndDate datetime,
	@CourseID int,
	@CenrerID int
)
AS
	Begin
		DECLARE @ENQUIREDCOURSELIST VARCHAR(250)
		DECLARE @SUGGESTEDCOURSELIST VARCHAR(250)
		DECLARE @ADMITTEDCOURSELIST VARCHAR(250)
		DECLARE @TOTCOUNT INT
		DECLARE @CTR INT=1
		DECLARE @ENQ_ID INT
		
		DECLARE @ENQUIRYDETAILS TABLE
		(
			ID INT IDENTITY(1,1),
			I_Centre_Id INT,
			I_Course_ID INT,
			I_Enquiry_Regn_ID INT,
			S_Enquiry_No VARCHAR(20),
			DT_ENQ_DATE DATETIME,
			STUDENTNAME VARCHAR(750),
			ENQUIREDCOURSE VARCHAR(800),
			SUGGESTEDCOURSE VARCHAR(800),
			ADMITTEDCOURSE VARCHAR(800)
		)
	
		INSERT INTO @ENQUIRYDETAILS
		(
			[I_Centre_Id],
			[I_Course_ID],
			[I_Enquiry_Regn_ID],
			[S_Enquiry_No],
			[DT_ENQ_DATE],
			[STUDENTNAME]
		)		
		SELECT DISTINCT
			   ERD.I_Centre_Id,
			   tacm.I_Course_ID,	
			   ERD.I_Enquiry_Regn_ID,
			   ERD.S_Enquiry_No,
			   ERD.Dt_Crtd_On,
			   ISNULL(ERD.S_First_Name,'')+' '+ISNULL(ERD.S_Middle_Name,'') AS STUDENTNAME
		FROM ASSESSMENT.T_Student_Assessment_Map TSAM
			  INNER JOIN ASSESSMENT.T_Assessment_Course_Map AS tacm ON tsam.I_PreAssessment_ID = tacm.I_PreAssessment_ID
			  INNER JOIN dbo.T_Enquiry_Regn_Detail ERD ON TSAM.I_Enquiry_Regn_ID=ERD.I_Enquiry_Regn_ID
			  INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
			  ON ERD.I_Centre_Id=FN1.CenterID 
			  INNER JOIN dbo.T_Enquiry_Course EC ON ERD.I_Enquiry_Regn_ID=EC.I_Enquiry_Regn_ID
			  AND EC.I_Course_ID=tacm.I_Course_ID
		WHERE TSAM.B_Is_Complete=1
		AND ERD.I_Centre_Id=@CenrerID and tacm.I_Course_ID=@CourseID
		AND ERD.Dt_Crtd_On BETWEEN @dtStartDate AND @dtEndDate
		
				
		SELECT @TOTCOUNT=COUNT(*) FROM @ENQUIRYDETAILS
		
		WHILE @CTR <= @TOTCOUNT
			BEGIN
				SELECT @ENQ_ID=E.I_Enquiry_Regn_ID FROM @ENQUIRYDETAILS E WHERE E.ID=@CTR
				
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

				
				UPDATE @ENQUIRYDETAILS SET 
				ENQUIREDCOURSE=@ENQUIREDCOURSELIST,
				SUGGESTEDCOURSE=@SUGGESTEDCOURSELIST,
				ADMITTEDCOURSE=@ADMITTEDCOURSELIST
				WHERE ID=@CTR
			SET @CTR=@CTR+1
			END
		
		SELECT * from @ENQUIRYDETAILS
				  
		End
		
		
--EXEC [REPORT].[UspGetPreAssessmentAnalysisSubReportQuery] 1,2,'2011-06-01','2011-07-31',2480,743
