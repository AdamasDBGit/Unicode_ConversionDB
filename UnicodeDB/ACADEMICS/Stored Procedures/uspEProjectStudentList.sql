/*******************************************************
Description : Gets the list of EProject Student List
Author	:     Soumya Sikder
Date	:	  03/05/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspEProjectStudentList] 
(
	@iCenterID int,
	@iCourseID int,
	@iTermID int,
	@iModuleID int,
	@iEProjectGroupID int = null,
    @iFlag int
)

AS
BEGIN TRY 
	
	-- All Students from eligible for EProjects
	IF(@iFlag = 0)
	BEGIN

	SELECT DISTINCT CEM.I_Center_E_Proj_ID,
		   CEM.I_E_Proj_Manual_Number,
		   CEM.Dt_Cancellation_Date,
		   CEM.S_Cancellation_Reason,
		   CEM.N_Marks,
		   CEM.I_Status,
		   SD.I_Student_Detail_ID,
		   SD.S_Student_ID,
		   SD.S_Title,
		   SD.S_First_Name,
           SD.S_Middle_Name,
		   SD.S_Last_Name,
		   EPE.Dt_New_End_Date,
		   EPE.S_Reason,
		   DPM.I_Delivery_Pattern_ID,
		   DPM.S_Pattern_Name,
		   DPM.I_No_Of_Session,
		   DPM.N_Session_Day_Gap
	FROM ACADEMICS.T_Center_E_Project_Manual CEM 
	INNER JOIN dbo.T_Student_Detail SD	WITH(NOLOCK)
	ON CEM.I_Student_Detail_ID = SD.I_Student_Detail_ID
	INNER JOIN dbo.T_Student_Course_Detail SCD WITH(NOLOCK)
	ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID
	INNER JOIN dbo.T_Course_Center_Delivery_FeePlan CCDF WITH(NOLOCK)
	ON SCD.I_Course_Center_Delivery_ID = CCDF.I_Course_Center_Delivery_ID
	INNER JOIN dbo.T_Course_Delivery_Map CDM WITH(NOLOCK)
	ON CCDF.I_Course_Delivery_ID = CDM.I_Course_Delivery_ID
	INNER JOIN dbo.T_Delivery_Pattern_Master DPM WITH(NOLOCK)
	ON CDM.I_Delivery_Pattern_ID = DPM.I_Delivery_Pattern_ID
	LEFT OUTER JOIN ACADEMICS.T_E_Project_Extension EPE	WITH(NOLOCK)
	ON CEM.I_E_Project_Group_ID = EPE.I_E_Project_Group_ID
	AND EPE.I_Status = 1
	WHERE CEM.I_Center_ID = @iCenterID
	AND CEM.I_Course_ID = @iCourseID
	AND CEM.I_Term_ID = @iTermID
	AND CEM.I_Module_ID = @iModuleID
	AND CEM.I_Status NOT IN (2,3)
	AND SD.I_Status = 1

	END
	-- All students who donot belong to any group
	ELSE IF(@iFlag = 1)
	BEGIN
	
		SELECT DISTINCT CEM.I_Center_E_Proj_ID,
		   CEM.I_E_Proj_Manual_Number,
		   CEM.Dt_Cancellation_Date,
		   CEM.S_Cancellation_Reason,
		   CEM.N_Marks,
		   CEM.I_Status,
		   SD.I_Student_Detail_ID,
		   SD.S_Student_ID,
		   SD.S_Title,
		   SD.S_First_Name,
           SD.S_Middle_Name,
		   SD.S_Last_Name,
		   NULL AS Dt_New_End_Date,
		   NULL AS S_Reason,
		    DPM.I_Delivery_Pattern_ID,
		   DPM.S_Pattern_Name,
 DPM.I_No_Of_Session,
		   DPM.N_Session_Day_Gap
	FROM ACADEMICS.T_Center_E_Project_Manual CEM 
	INNER JOIN dbo.T_Student_Detail SD	WITH(NOLOCK)
	ON CEM.I_Student_Detail_ID = SD.I_Student_Detail_ID
	INNER JOIN dbo.T_Student_Course_Detail SCD WITH(NOLOCK)
	ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID
	INNER JOIN dbo.T_Course_Center_Delivery_FeePlan CCDF WITH(NOLOCK)
	ON SCD.I_Course_Center_Delivery_ID = CCDF.I_Course_Center_Delivery_ID
	INNER JOIN dbo.T_Course_Delivery_Map CDM WITH(NOLOCK)
	ON CCDF.I_Course_Delivery_ID = CDM.I_Course_Delivery_ID
	INNER JOIN dbo.T_Delivery_Pattern_Master DPM WITH(NOLOCK)
	ON CDM.I_Delivery_Pattern_ID = DPM.I_Delivery_Pattern_ID
	WHERE CEM.I_Center_ID = @iCenterID
	AND CEM.I_Course_ID = @iCourseID
	AND CEM.I_Term_ID = @iTermID
	AND CEM.I_Module_ID = @iModuleID
	AND CEM.I_E_Project_Group_ID IS NULL
	AND CEM.I_Status NOT IN (2,3)
	AND SD.I_Status = 1

	END
	--All students belonging to a particular Group
	ELSE IF(@iFlag = 2)
	BEGIN

	SELECT DISTINCT CEM.I_Center_E_Proj_ID,
		   CEM.I_E_Proj_Manual_Number,
		   CEM.Dt_Cancellation_Date,
		   CEM.S_Cancellation_Reason,
		   CEM.N_Marks,
		   CEM.I_Status,
		   SD.I_Student_Detail_ID,
		   SD.S_Student_ID,
		   SD.S_Title,
		   SD.S_First_Name,
           SD.S_Middle_Name,
		   SD.S_Last_Name,
		   EPE.Dt_New_End_Date,
		   EPE.S_Reason,
			 DPM.I_Delivery_Pattern_ID,
		   DPM.S_Pattern_Name,
 DPM.I_No_Of_Session,
		   DPM.N_Session_Day_Gap
	FROM ACADEMICS.T_Center_E_Project_Manual CEM 
	INNER JOIN dbo.T_Student_Detail SD WITH(NOLOCK)
	ON CEM.I_Student_Detail_ID = SD.I_Student_Detail_ID
	INNER JOIN dbo.T_Student_Course_Detail SCD WITH(NOLOCK)
	ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID
	INNER JOIN dbo.T_Course_Center_Delivery_FeePlan CCDF WITH(NOLOCK)
	ON SCD.I_Course_Center_Delivery_ID = CCDF.I_Course_Center_Delivery_ID
	INNER JOIN dbo.T_Course_Delivery_Map CDM WITH(NOLOCK)
	ON CCDF.I_Course_Delivery_ID = CDM.I_Course_Delivery_ID
	INNER JOIN dbo.T_Delivery_Pattern_Master DPM WITH(NOLOCK)
	ON CDM.I_Delivery_Pattern_ID = DPM.I_Delivery_Pattern_ID
	LEFT OUTER JOIN ACADEMICS.T_E_Project_Extension EPE
	ON CEM.I_E_Project_Group_ID = EPE.I_E_Project_Group_ID
	AND EPE.I_Status = 1
	WHERE CEM.I_Center_ID = @iCenterID
	AND CEM.I_E_Project_Group_ID = @iEProjectGroupID 
	AND CEM.I_Course_ID = @iCourseID
	AND CEM.I_Term_ID = @iTermID
	AND CEM.I_Module_ID = @iModuleID
	AND CEM.I_Status <> 3
	AND SD.I_Status = 1

	END
	
	-- All Students who has cancelled E-Project atleast once
	ELSE IF(@iFlag = 3)
	BEGIN

	SELECT DISTINCT CEM.I_Center_E_Proj_ID,
		   CEM.I_E_Proj_Manual_Number,
		   CEM.Dt_Cancellation_Date,
		   CEM.S_Cancellation_Reason,
		   CEM.N_Marks,
		   CEM.I_Status,
		   SD.I_Student_Detail_ID,
		   SD.S_Student_ID,
		   SD.S_Title,
		   SD.S_First_Name,
           SD.S_Middle_Name,
		   SD.S_Last_Name,
		   EPE.Dt_New_End_Date,
		   EPE.S_Reason,
		 DPM.I_Delivery_Pattern_ID,
		   DPM.S_Pattern_Name,
		 DPM.I_No_Of_Session,
		   DPM.N_Session_Day_Gap
	FROM ACADEMICS.T_Center_E_Project_Manual CEM 
	INNER JOIN dbo.T_Student_Detail SD	WITH(NOLOCK)
	ON CEM.I_Student_Detail_ID = SD.I_Student_Detail_ID
	INNER JOIN dbo.T_Student_Course_Detail SCD WITH(NOLOCK)
	ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID
	INNER JOIN dbo.T_Course_Center_Delivery_FeePlan CCDF WITH(NOLOCK)
	ON SCD.I_Course_Center_Delivery_ID = CCDF.I_Course_Center_Delivery_ID
	INNER JOIN dbo.T_Course_Delivery_Map CDM WITH(NOLOCK)
	ON CCDF.I_Course_Delivery_ID = CDM.I_Course_Delivery_ID
	INNER JOIN dbo.T_Delivery_Pattern_Master DPM WITH(NOLOCK)
	ON CDM.I_Delivery_Pattern_ID = DPM.I_Delivery_Pattern_ID
	LEFT OUTER JOIN ACADEMICS.T_E_Project_Extension EPE	WITH(NOLOCK)
	ON CEM.I_E_Project_Group_ID = EPE.I_E_Project_Group_ID
	AND EPE.I_Status = 1
	WHERE CEM.I_Center_ID = @iCenterID
	AND CEM.I_Course_ID = @iCourseID
	AND CEM.I_Term_ID = @iTermID
	AND CEM.I_Module_ID = @iModuleID
	AND CEM.I_Status = 3
	AND CEM.I_Valid_Cancellation_Attempt =1
	AND SD.I_Status = 1

	END

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
