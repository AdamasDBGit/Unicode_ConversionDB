/*******************************************************
Author	:     Arindam Roy
Date	:	  08/08/2007
Description : This SP retrieves the PMS Summary Report Details
				
*********************************************************/


CREATE PROCEDURE [REPORT].[uspGetPMSSummaryReport] --50,1,1,12,1990,2015,53
(
	-- Add the parameters for the stored procedure here
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@iStartMonth INT,
	@sStartMonthName varchar(50) = null,
	@iEndMonth INT,
	@sEndMonthName varchar(50) = null,
	@iStartYear INT,
	@sStartYearName varchar(50) = null,
	@iEndYear INT,
	@sEndYearName varchar(50) = null,
	@iEmployeeID INT=NULL,
	@sEmployeeName varchar(300) = null
)
AS
BEGIN TRY

	DECLARE @PMSSummary TABLE
	(
		I_Employee_ID INT,
		S_Emp_ID VARCHAR(20),
		EmpName VARCHAR(200),
		I_Target_Month INT,
		I_Target_Year INT,
		I_Centre_Id INT,
		CenterCode VARCHAR(20),
		CenterName VARCHAR(200),
		InstanceChain VARCHAR(200),
		Performance NUMERIC(18,2)
	)

	WHILE (@iEndYear>@iStartYear) OR (@iEndYear=@iStartYear AND @iEndMonth>=@iStartMonth)
	BEGIN
	
		INSERT INTO @PMSSummary 
		 SELECT	EKM.I_Employee_ID,
				ED.S_Emp_ID,
				LTRIM(ISNULL(ED.S_Title,'') + ' ') + ED.S_First_Name + ' ' + LTRIM(ISNULL(ED.S_Middle_Name,'') + ' ' + ED.S_Last_Name) as EmpName,
				EKD.I_Target_Month,
				EKD.I_Target_Year,
				ED.I_Centre_Id,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain,
				SUM(CONVERT(NUMERIC(18,2),ISNULL(EKD.S_Performance_Evaluation,0.00))) AS Performance
		   FROM EOS.T_Employee_KRA_Map EKM
				INNER JOIN EOS.T_Employee_KRA_Details EKD
					ON EKM.I_Employee_ID=EKD.I_Employee_ID
					AND EKM.I_KRA_ID=EKD.I_KRA_ID
					AND ((EKM.I_SubKRA_ID=EKD.I_SubKRA_ID) OR (EKM.I_SubKRA_ID IS NULL AND EKD.I_SubKRA_ID IS NULL))
				INNER JOIN dbo.T_Employee_Dtls ED
					ON EKM.I_Employee_ID=ED.I_Employee_ID
				INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
					ON ED.I_Centre_Id=FN1.CenterID
				INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
					ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
		  WHERE EKD.I_Target_Month=@iStartMonth
			AND	EKD.I_Target_Year=@iStartYear
			AND EKM.I_Employee_ID=ISNULL(@iEmployeeID,EKM.I_Employee_ID)
	   GROUP BY EKM.I_Employee_ID,
				ED.S_Emp_ID,
				ED.S_Title,
				ED.S_First_Name,
				ED.S_Middle_Name,
				ED.S_Last_Name,
				EKD.I_Target_Month,
				EKD.I_Target_Year,
				ED.I_Centre_Id,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain

		IF @iStartMonth =12
			BEGIN
				SELECT @iStartMonth = 1
				SELECT @iStartYear=@iStartYear+1
			END
		ELSE
			BEGIN
				SELECT @iStartMonth = @iStartMonth +1
			END	
	END

	SELECT * FROM @PMSSummary 
	ORDER BY InstanceChain,CenterName,EmpName,I_Target_Year,I_Target_Month

END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
