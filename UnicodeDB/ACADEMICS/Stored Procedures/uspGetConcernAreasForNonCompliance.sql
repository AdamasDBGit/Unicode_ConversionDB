CREATE PROCEDURE [ACADEMICS].[uspGetConcernAreasForNonCompliance] 
(
	-- Add the parameters for the stored procedure here
	@iCenterID int = null,
	@dtInputDate datetime
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @iCenterID IS NULL 
	BEGIN
	
	 SELECT DISTINCT C.I_Center_Id,
			CM.S_Center_Name,
			CM.S_Center_Code,
			CHD.I_Hierarchy_Detail_ID
		FROM ACADEMICS.T_Concern_Areas A WITH(NOLOCK)
		INNER JOIN dbo.T_Employee_Dtls B WITH(NOLOCK)
		ON A.I_Assigned_EmpID = B.I_Employee_ID
		AND A.I_Is_Notified <> 1
		AND A.Dt_Target_Date < @dtInputDate
		--AND A.Dt_Actual_Date IS NULL 
		AND (A.Dt_Actual_Date IS NULL
		OR ISNULL(A.Dt_Actual_Date,null) > A.Dt_Target_Date)
		INNER JOIN ACADEMICS.T_Academics_Visit C
		ON A.I_Academics_Visit_ID = C.I_Academics_Visit_ID
		AND C.I_Status = 2
		INNER JOIN dbo.T_Centre_Master CM
		ON C.I_Center_ID = CM.I_Centre_ID
		AND CM.I_Status = 1
		INNER JOIN dbo.T_Center_Hierarchy_Details CHD
		ON C.I_Center_Id = CHD.I_Center_Id
		AND CHD.I_Status = 1
		AND @dtInputDate >= ISNULL(CHD.Dt_Valid_From, @dtInputDate)
		AND @dtInputDate <= ISNULL(CHD.Dt_Valid_To, @dtInputDate)
	 
	 SELECT A.I_Concern_Areas_ID,
			A.Dt_Target_Date,
			A.S_Description,
			A.I_Academics_Visit_ID,
			A.I_Assigned_EmpID,
			B.S_Emp_ID,
			B.S_Title,
			B.S_First_Name,
			B.S_Middle_Name,
			B.S_Last_Name,
			UM.S_Email_ID,
			C.I_Center_Id
		FROM ACADEMICS.T_Concern_Areas A WITH(NOLOCK)
		INNER JOIN dbo.T_Employee_Dtls B WITH(NOLOCK)
		ON A.I_Assigned_EmpID = B.I_Employee_ID
		AND A.I_Is_Notified <> 1
		AND A.Dt_Target_Date < @dtInputDate
		--AND A.Dt_Actual_Date IS NULL 
		AND (A.Dt_Actual_Date IS NULL
		OR ISNULL(A.Dt_Actual_Date,null) > A.Dt_Target_Date)
		INNER JOIN ACADEMICS.T_Academics_Visit C
		ON A.I_Academics_Visit_ID = C.I_Academics_Visit_ID
		AND C.I_Status = 2
		INNER JOIN dbo.T_User_Master UM
		ON A.I_Assigned_EmpID = UM.I_Reference_ID
		AND UM.I_Status = 1
		
	END
	ELSE
	BEGIN
	
		SELECT C.I_Center_Id,
			CM.S_Center_Name,
			CM.S_Center_Code,
			CHD.I_Hierarchy_Detail_ID
		FROM ACADEMICS.T_Concern_Areas A WITH(NOLOCK)
		INNER JOIN dbo.T_Employee_Dtls B WITH(NOLOCK)
		ON A.I_Assigned_EmpID = B.I_Employee_ID
		AND A.I_Is_Notified <> 1
		AND A.Dt_Target_Date < @dtInputDate
		--AND A.Dt_Actual_Date IS NULL 
		AND (A.Dt_Actual_Date IS NULL
		OR ISNULL(A.Dt_Actual_Date,null) > A.Dt_Target_Date)
		INNER JOIN ACADEMICS.T_Academics_Visit C
		ON A.I_Academics_Visit_ID = C.I_Academics_Visit_ID
		AND C.I_Status = 2
		INNER JOIN dbo.T_Centre_Master CM
		ON C.I_Center_ID = CM.I_Centre_ID
		AND CM.I_Status = 1
		INNER JOIN dbo.T_Center_Hierarchy_Details CHD
		ON C.I_Center_Id = CHD.I_Center_Id
		AND CHD.I_Status = 1
		AND @dtInputDate >= ISNULL(CHD.Dt_Valid_From, @dtInputDate)
		AND @dtInputDate <= ISNULL(CHD.Dt_Valid_To, @dtInputDate)
		WHERE C.I_Center_Id = @iCenterID
		
		SELECT A.I_Concern_Areas_ID,
			A.Dt_Target_Date,
			A.S_Description,
			A.I_Academics_Visit_ID,
			A.I_Assigned_EmpID,
			B.S_Emp_ID,
			B.S_Title,
			B.S_First_Name ,
			B.S_Middle_Name,
			B.S_Last_Name,
			UM.S_Email_ID,
			C.I_Center_Id
		FROM ACADEMICS.T_Concern_Areas A WITH(NOLOCK)
		INNER JOIN dbo.T_Employee_Dtls B WITH(NOLOCK)
		ON A.I_Assigned_EmpID = B.I_Employee_ID
		AND A.I_Is_Notified <> 1
		AND A.Dt_Target_Date < @dtInputDate
		--AND A.Dt_Actual_Date IS NULL 
		AND (A.Dt_Actual_Date IS NULL
		OR ISNULL(A.Dt_Actual_Date,null) > A.Dt_Target_Date)
		INNER JOIN ACADEMICS.T_Academics_Visit C
		ON A.I_Academics_Visit_ID = C.I_Academics_Visit_ID
		AND C.I_Status = 2
		INNER JOIN dbo.T_User_Master UM
		ON A.I_Assigned_EmpID = UM.I_Reference_ID
		AND UM.I_Status = 1
		WHERE C.I_Center_Id = @iCenterID
	
	END	
		
END
