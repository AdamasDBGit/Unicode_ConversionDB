CREATE PROCEDURE [REPORT].[uspGetTrainingStatusReport] 
(
	-- Add the parameters for the stored procedure here
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@dtStartDate datetime,
	@dtEndDate datetime,
	@iTrainingProgramme int=NULL,
	@sTrainingProgrammeName varchar(200)=NULL
)
AS
BEGIN TRY

	 SELECT LTRIM(ISNULL(UM.S_Title,'') + ' ') + UM.S_First_Name + ' ' + LTRIM(ISNULL(UM.S_Middle_Name,'') + ' ') + ISNULL(UM.S_Last_Name,'') as Trainer_Name,
			TC.I_User_ID,
			TC.I_Training_ID,
			TC.S_Training_Name,
			TC.Dt_Training_Date,
			TC.Dt_Training_End_Date,
			FN.I_Employee_ID,
			ED.S_Emp_ID,
			LTRIM(ISNULL(ED.S_Title,'') + ' ') + ED.S_First_Name + ' ' + LTRIM(ISNULL(Ed.S_Middle_Name,'') + ' ' + Ed.S_Last_Name) as Participants,
			FN1.CenterCode,
			FN1.CenterName,
			FN2.InstanceChain,
			UM1.I_User_ID AS ParticipantsUserID,
			[REPORT].[fnGetTrainerFeedbackReports](TC.I_Training_ID,UM1.I_User_ID,2) AS AvgFeedbackTrainer,
			[REPORT].[fnGetTrainerFeedbackReports](TC.I_Training_ID,UM1.I_User_ID,3) AS AvgFeedbackCourseware,
			[REPORT].[fnGetTrainerFeedbackReports](TC.I_Training_ID,UM1.I_User_ID,4) AS AvgFeedbackInfrastructure,
			[REPORT].[fnGetTrainerFeedbackReports](TC.I_Training_ID,UM1.I_User_ID,5) AS AvgFeedbackDelivery,
			[REPORT].[fnGetTrainerFeedbackReports](TC.I_Training_ID,UM1.I_User_ID,6) AS AvgFeedbackDissemination
	   INTO #TmpTrainingStatus1	
	   FROM ACADEMICS.T_Training_Calendar TC
			INNER JOIN ACADEMICS.T_Faculty_Nomination FN
				ON TC.I_Training_ID = FN.I_Training_ID 
	        INNER JOIN dbo.T_Employee_Dtls ED
				ON FN.I_Employee_ID = ED.I_Employee_ID
			INNER JOIN dbo.T_User_Master UM
				ON TC.I_User_ID = UM.I_User_ID 
			INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON FN.I_Centre_Id=FN1.CenterID
			INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
				ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
			INNER JOIN dbo.T_User_Master UM1
				ON FN.I_Employee_ID=UM1.I_Reference_ID
				AND UM1.I_Status<>0
				AND UM1.S_User_Type='CE'
	  WHERE TC.Dt_Training_Date BETWEEN @dtStartDate AND @dtEndDate
		AND FN.C_Approved='Y'
		AND FN.C_Attended='Y'
		AND TC.I_Training_ID=ISNULL(@iTrainingProgramme,TC.I_Training_ID)


	 SELECT *, (AvgFeedbackTrainer + AvgFeedbackCourseware + AvgFeedbackInfrastructure + AvgFeedbackDelivery + AvgFeedbackDissemination)/5 AS OverallGPA 
	   INTO #TmpTrainingStatus2
	   FROM #TmpTrainingStatus1

	 SELECT TMP1.*,
		    TT.AvgOverallGPA 
       FROM #TmpTrainingStatus2 TMP1,
			(SELECT I_Training_ID,Avg(OverallGPA) AS AvgOverallGPA FROM #TmpTrainingStatus2 GROUP BY I_Training_ID) TT
	  WHERE TMP1.I_Training_ID=TT.I_Training_ID

	 DROP TABLE #TmpTrainingStatus1
	 DROP TABLE #TmpTrainingStatus2

	 
END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
