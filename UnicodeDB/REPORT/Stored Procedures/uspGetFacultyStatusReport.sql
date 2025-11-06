CREATE PROCEDURE [REPORT].[uspGetFacultyStatusReport]
(
	-- Add the parameters for the stored procedure here
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@dtStartDate datetime,
	@dtEndDate datetime,
	@iSkillId int=NULL,
	@sSkillName varchar(200) =NULL,
	@iEmployeeId int =NULL,
	@sEmployeeName varchar(200) =NULL,
	@sApprovalStatus varchar(1)=NULL
)
AS
BEGIN TRY
	
	SET NOCOUNT ON

	DECLARE @ICENTERID INT
	SELECT @ICENTERID=I_CENTER_ID FROM DBO.T_CENTER_HIERARCHY_DETAILS WHERE I_HIERARCHY_DETAIL_ID=@SHIERARCHYLIST
--print @sHierarchyList
--print @ICENTERID
--SELECT * FROM DBO.T_CENTER_HIERARCHY_DETAILS
	DECLARE @FacultyStatus TABLE
	(
		I_Centre_Id INT,
		I_Skill_ID INT,
		I_Exam_Component_ID INT
	)

	DECLARE @CenterID INT
	DECLARE @SkillID INT
	DECLARE @ExamComponentID INT
	DECLARE @COUNTER INT

	SET @COUNTER=1

	DECLARE FacultyStatus_cursor CURSOR FOR 
	SELECT DISTINCT 
	MM.I_Skill_ID
	FROM dbo.T_Student_Attendance_Details SAD 
	INNER JOIN dbo.T_Module_Master MM  ON SAD.I_Module_ID=MM.I_Module_ID
	INNER JOIN dbo.T_User_Master AS tum ON sad.S_Crtd_By = tum.S_Login_ID AND tum.S_User_Type <> 'ST'
	WHERE SAD.Dt_Attendance_Date BETWEEN @dtStartDate AND @dtEndDate
	AND tum.I_Reference_ID = ISNULL(@iEmployeeId,tum.I_Reference_ID)
	AND MM.I_Skill_ID= ISNULL(@iSkillId,MM.I_Skill_ID)
	AND SAD.Dt_Attendance_Date BETWEEN @dtStartDate AND @dtEndDate
	AND SAD.I_Centre_Id =@iCenterID

	OPEN FacultyStatus_cursor
	FETCH NEXT FROM FacultyStatus_cursor INTO @SkillID

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS ( SELECT I_Exam_Component_ID
					  FROM EOS.T_Skill_Exam_Map 
					 WHERE I_Centre_ID=@iCenterID
					   AND I_Skill_ID=@SkillID
				  )
		BEGIN
			SELECT @ExamComponentID=I_Exam_Component_ID
			  FROM EOS.T_Skill_Exam_Map 
			 WHERE I_Centre_ID=@iCenterID
			   AND I_Skill_ID=@SkillID

		END
		ELSE
		BEGIN
			SELECT @ExamComponentID=I_Exam_Component_ID
			  FROM EOS.T_Skill_Exam_Map 
			 WHERE I_Centre_ID IS NULL
			   AND I_Skill_ID=@SkillID

		END
		--print cast(@COUNTER as varchar(200))+ ' CENTER '+cast(@iCenterID as varchar(200))+'SKILL '+cast(@SkillID as varchar(200))

		INSERT INTO @FacultyStatus
		SELECT	@iCenterID,@SkillID,@ExamComponentID

		FETCH NEXT FROM FacultyStatus_cursor INTO @SkillID

		--SET @COUNTER=@COUNTER+1
	END

	CLOSE FacultyStatus_cursor
	DEALLOCATE FacultyStatus_cursor


	DECLARE @INSTANCECHAIN AS VARCHAR(5000)
	SELECT @INSTANCECHAIN=INSTANCECHAIN FROM [DBO].[FNGETINSTANCENAMECHAINFORREPORTS](@SHIERARCHYLIST, @IBRANDID)  

	SELECT 
	ted.I_Employee_ID,
	SAD.I_Centre_Id,
	ted.S_Emp_ID,
	LTRIM(ISNULL(ted.S_Title,'') + ' ') + ted.S_First_Name + ' ' + LTRIM(ISNULL(ted.S_Middle_Name,'') + ' ' + ted.S_Last_Name) as FacultyName,
	ted.S_Title,
	ted.S_First_Name,
	ted.S_Middle_Name,
	ted.S_Last_Name,
	ted.Dt_Joining_Date,
	ted.Dt_Resignation_Date,
	ted.Dt_Registration_Date,
	CM.S_Center_Code,
	CM.S_Center_Name,
	@InstanceChain as InstanceChain,
	ApprovalStatus= CASE 
			WHEN URD.I_User_Role_Detail_ID IS NOT NULL THEN 'Y'
			ELSE 'N'
			END,
	[REPORT].[fnGetEmployeeQualificationForReports](ted.I_Employee_ID) AS Qualification,
	SM.I_Skill_ID,
	SM.S_Skill_No,
	SM.S_Skill_Desc,
	ESM.I_Status AS SkillStatus,
	MM.S_Module_Name,
	TEMP.I_Exam_Component_ID,
	MAX(EER.N_Marks) AS N_Marks
	   INTO #TempFacultyStatus
	   FROM dbo.T_Student_Attendance_Details SAD 
			INNER JOIN dbo.T_User_Master AS tum ON sad.S_Crtd_By = tum.S_Login_ID AND tum.S_User_Type <> 'ST'
			INNER JOIN dbo.t_centre_master CM ON SAD.I_Centre_Id=CM.I_Centre_Id
			INNER JOIN dbo.T_Employee_Dtls AS ted ON TED.I_Employee_ID = TUM.I_Reference_ID AND tum.S_User_Type <> 'ST'
			LEFT OUTER JOIN EOS.T_Employee_Role_Map ERM
				ON tum.I_Reference_ID=ERM.I_Employee_ID
			LEFT OUTER JOIN dbo.T_User_Role_Details URD 
				ON ted.I_Employee_ID=URD.I_User_ID
			    AND ERM.I_Role_ID=URD.I_Role_ID
			INNER JOIN dbo.T_Module_Master MM 
				ON SAD.I_Module_ID=MM.I_Module_ID
			INNER JOIN dbo.T_EOS_Skill_Master SM 
				ON MM.I_Skill_ID=SM.I_Skill_ID
			LEFT OUTER JOIN EOS.T_Employee_Skill_Map ESM 
				ON ERM.I_Employee_ID=ESM.I_Employee_ID
				AND SM.I_Skill_ID=ESM.I_Skill_ID
			LEFT OUTER JOIN @FacultyStatus TEMP
				ON SM.I_Skill_ID=TEMP.I_Skill_ID
				AND SAD.I_Centre_Id=TEMP.I_Centre_Id
			LEFT OUTER JOIN EOS.T_Employee_Exam_Result EER 
				ON TEMP.I_Exam_Component_ID=EER.I_Exam_Component_ID
				AND ted.I_Employee_ID=EER.I_Employee_ID
		WHERE SM.I_Skill_ID= ISNULL(@iSkillId,SM.I_Skill_ID)
		AND ted.I_Employee_ID=ISNULL(@iEmployeeId,ted.I_Employee_ID)
		AND SAD.I_Centre_Id =@iCenterID
		AND SAD.Dt_Attendance_Date BETWEEN @dtStartDate AND @dtEndDate
		GROUP BY 
		ted.I_Employee_ID,
		SAD.I_Centre_Id,
		ted.S_Emp_ID,
		ted.S_Title,
		ted.S_First_Name,
		ted.S_Middle_Name,
		ted.S_Last_Name,
		ted.Dt_Joining_Date,
		ted.Dt_Resignation_Date,
		ted.Dt_Registration_Date,
		CM.S_Center_Code,
		CM.S_Center_Name,
		--@InstanceChain,
		URD.I_User_Role_Detail_ID,
		SM.I_Skill_ID,
		SM.S_Skill_No,
		SM.S_Skill_Desc,
		ESM.I_Status,
		-- MM.I_Module_ID,
		MM.S_Module_Name,
		TEMP.I_Exam_Component_ID


--select * from #TempFacultyStatus

	 SELECT TMP.* ,
			EER.Dt_Crtd_On,
			[REPORT].[fnGetFacultyGPAForReports](TMP.S_Module_Name,TMP.I_Employee_ID,@dtStartDate,@dtEndDate) AS FacultyGPA
	   FROM #TempFacultyStatus TMP
			LEFT OUTER JOIN EOS.T_Employee_Exam_Result EER 
				ON TMP.I_Exam_Component_ID=EER.I_Exam_Component_ID
				AND TMP.I_Employee_ID=EER.I_Employee_ID
				AND TMP.N_Marks = EER.N_Marks
	  WHERE ApprovalStatus =ISNULL(@sApprovalStatus,ApprovalStatus)


	 DROP TABLE #TempFacultyStatus
	 
END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
