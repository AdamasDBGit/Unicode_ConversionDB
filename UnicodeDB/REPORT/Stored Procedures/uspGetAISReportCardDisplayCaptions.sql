
--EXEC REPORT.uspGetAISReportCardDisplayCaptions @iBatchId = 8400
--EXEC REPORT.uspGetAISReportCardDisplayCaptions @iBatchId = 8058
--EXEC REPORT.uspGetAISReportCardDisplayCaptions @iBatchId = 8059
--EXEC REPORT.uspGetAISReportCardDisplayCaptions @iBatchId = 8060
--EXEC REPORT.uspGetAISReportCardDisplayCaptions @iBatchId = 8419

CREATE PROCEDURE [REPORT].[uspGetAISReportCardDisplayCaptions] 
	@iBatchID INT
AS
BEGIN	
	

	DECLARE @Modules AS TABLE(I_Term_Id INT
							,S_Term_Name VARCHAR(255)
							,I_Term_Sequence INT
							,I_Module_Id INT
							,S_Module_Name VARCHAR(255)
							,I_Module_Sequence INT
							,N_Weightage INT)

	INSERT INTO @Modules(I_Term_Id
						,S_Term_Name
						,I_Term_Sequence
						,I_Module_Id
						,S_Module_Name
						,I_Module_Sequence
						,N_Weightage)

	SELECT
		MTM.I_Term_Id
		,ISNULL(TM.S_Display_Name, TM.S_Term_Name) AS S_Term_Name --Weightage to display/and calculation to be Picked from T_Term_Course_Map in future
		,TCM.I_Sequence AS I_Term_Sequence
		,MTM.I_Module_Id
		,ISNULL(MM.S_Display_Name, MM.S_Module_Name) 
		,MTM.I_Sequence AS I_Module_Sequence
		,N_Weightage
	FROM T_Student_Batch_Master SBM  WITH (NOLOCK) 
	INNER JOIN T_Term_Course_Map TCM WITH (NOLOCK) ON TCM.I_Course_ID = SBM.I_Course_ID
	INNER JOIN T_Module_Term_Map MTM WITH (NOLOCK) ON MTM.I_Term_ID = TCM.I_Term_ID
	INNER JOIN T_Module_Master MM WITH (NOLOCK) ON MM.I_Module_ID = MTM.I_Module_Id
	INNER JOIN T_Term_Master TM WITH (NOLOCK) ON TM.I_Term_ID = TCM.I_Term_ID
	WHERE SBM.I_Batch_ID = @iBatchID
		AND TCM.I_Status = 1
		AND MTM.I_Status = 1
		AND MM.S_Module_Name NOT LIKE '%ADCHK%'

	--SELECT * FROM @Modules

	SELECT 
			(SELECT 
				CONVERT(VARCHAR(4),YEAR(SBM.Dt_BatchStartDate)) +'-'+ RIGHT(CONVERT(VARCHAR(4),YEAR(SBM.Dt_BatchStartDate)+1),2)  FROM T_Student_Batch_Master SBM WITH (NOLOCK) WHERE I_Batch_ID = @iBatchID
			 ) AS AcademicSession
		   ,T1M1.TermIModule1DisplayCaption
		   ,T1M2.TermIModule2DisplayCaption
		   ,T1M3.TermIModule3DisplayCaption
		   ,T1M1.TermIModule1Weightage
		   ,T1M2.TermIModule2Weightage
		   ,T1M3.TermIModule3Weightage

		   ,T2M1.TermIIModule1DisplayCaption
		   ,T2M2.TermIIModule2DisplayCaption
		   ,T2M3.TermIIModule3DisplayCaption
		   ,T2M1.TermIIModule1Weightage
		   ,T2M2.TermIIModule2Weightage
		   ,T2M3.TermIIModule3Weightage

		   ,T3M1.TermIIIModule1DisplayCaption
		   ,T3M2.TermIIIModule2DisplayCaption
		   ,T3M3.TermIIIModule3DisplayCaption
		   ,T3M1.TermIIIModule1Weightage
		   ,T3M2.TermIIIModule2Weightage
		   ,T3M3.TermIIIModule3Weightage

		   ,T1M1.S_Term_Name AS TermICaption
		   ,T2M1.S_Term_Name AS TermIICaption
		   ,T3M1.S_Term_Name AS TermIIICaption

		   ,'TBD' AS TermITotalCaption
		   ,'TBD' AS TermIITotalCaption
		   ,'TBD' AS TermIIITotalCaption
		   ,'TBD' AS TermIHighestCaption
		   ,'TBD' AS TermIIHighestCaption
		   ,'TBD' AS TermIIIHighestCaption

		FROM (SELECT I_Term_Sequence, S_Term_Name, S_Module_Name AS TermIModule1DisplayCaption,N_Weightage AS TermIModule1Weightage FROM @Modules WHERE I_Term_Sequence = 1 AND I_Module_Sequence = 1) AS T1M1
			OUTER APPLY (SELECT S_Module_Name AS TermIModule2DisplayCaption,N_Weightage AS TermIModule2Weightage FROM @Modules WHERE I_Term_Sequence = T1M1.I_Term_Sequence AND I_Module_Sequence = 2) AS T1M2
			OUTER APPLY (SELECT S_Module_Name AS TermIModule3DisplayCaption,N_Weightage AS TermIModule3Weightage FROM @Modules WHERE I_Term_Sequence = T1M1.I_Term_Sequence AND I_Module_Sequence = 3) AS T1M3

			OUTER APPLY (SELECT S_Term_Name, S_Module_Name AS TermIIModule1DisplayCaption,N_Weightage AS TermIIModule1Weightage FROM @Modules WHERE I_Term_Sequence = T1M1.I_Term_Sequence+1 AND I_Module_Sequence = 1) AS T2M1
			OUTER APPLY (SELECT S_Module_Name AS TermIIModule2DisplayCaption,N_Weightage AS TermIIModule2Weightage FROM @Modules WHERE I_Term_Sequence = T1M1.I_Term_Sequence+1 AND I_Module_Sequence = 2) AS T2M2
			OUTER APPLY (SELECT S_Module_Name AS TermIIModule3DisplayCaption,N_Weightage AS TermIIModule3Weightage FROM @Modules WHERE I_Term_Sequence = T1M1.I_Term_Sequence+1 AND I_Module_Sequence = 3) AS T2M3
			
	        OUTER APPLY (SELECT S_Term_Name, S_Module_Name AS TermIIIModule1DisplayCaption,N_Weightage AS TermIIIModule1Weightage FROM @Modules WHERE I_Term_Sequence = T1M1.I_Term_Sequence+2 AND I_Module_Sequence = 1) AS T3M1
			OUTER APPLY (SELECT S_Module_Name AS TermIIIModule2DisplayCaption,N_Weightage AS TermIIIModule2Weightage FROM @Modules WHERE I_Term_Sequence = T1M1.I_Term_Sequence+2 AND I_Module_Sequence = 2) AS T3M2
			OUTER APPLY (SELECT S_Module_Name AS TermIIIModule3DisplayCaption,N_Weightage AS TermIIIModule3Weightage FROM @Modules WHERE I_Term_Sequence = T1M1.I_Term_Sequence+2 AND I_Module_Sequence = 3) AS T3M3
 
 END
