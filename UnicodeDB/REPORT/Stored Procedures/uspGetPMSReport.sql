/*******************************************************
Author	:     Arindam Roy
Date	:	  08/08/2007
Description : This SP retrieves the PMS Report Details
				
*********************************************************/

CREATE PROCEDURE [REPORT].[uspGetPMSReport] --50,1,4,2007
(
	-- Add the parameters for the stored procedure here
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@iQuarter INT,
	@sQuarterName varchar(50) = null,
	@iYear INT,
	@sYearName varchar(50) = null,
	@iEmployeeID INT=NULL,
	@sEmployeeName varchar(300) = null
)
AS
BEGIN TRY

	DECLARE @AllMonth varchar(100)
	DECLARE @StartMonth int

	IF @iQuarter =1
		BEGIN
			SET @AllMonth='1,2,3'
			SET @StartMonth=1
		END
	ELSE IF @iQuarter =2
		BEGIN
			SET @AllMonth='4,5,6'
			SET @StartMonth=4
		END
	ELSE IF @iQuarter =3
		BEGIN
			SET @AllMonth='7,8,9'
			SET @StartMonth=7
		END
	ELSE IF @iQuarter =4
		BEGIN
			SET @AllMonth='10,11,12'
			SET @StartMonth=10
		END

	 SELECT EKM.I_Employee_KRA_ID,
			EKM.I_Employee_ID,
			ED.S_Emp_ID,
			LTRIM(ISNULL(ED.S_Title,'') + ' ') + ED.S_First_Name + ' ' + LTRIM(ISNULL(ED.S_Middle_Name,'') + ' ' + ED.S_Last_Name) as EmpName,
			EKM.N_Weightage,
			EKD.I_Target_Month,
			EKD.I_Target_Year,
			EKD.N_Target_Set,
			EKD.N_Target_Achieved,
			CONVERT(NUMERIC(18,2),ISNULL(EKD.S_Performance_Evaluation,0.00)) AS Performance,
			EKM.I_KRA_ID,
			EKM.I_SubKRA_ID,
			KM1.I_KRA_Type,
			KM1.S_KRA_Desc AS KRA,
			KM2.S_KRA_Desc AS SubKRA,
			MeasuringIndex=CASE 
					WHEN KM2.I_KRA_Index_ID is NOT NULL THEN KIM2.S_KRA_Index_Desc
					ELSE KIM1.S_KRA_Index_Desc
					END,
			ED.I_Centre_Id,
			FN1.CenterCode,
			FN1.CenterName,
			FN2.InstanceChain
	   INTO #TmpPMSReport
	   FROM EOS.T_Employee_KRA_Map EKM
			INNER JOIN dbo.T_Employee_Dtls ED
				ON EKM.I_Employee_ID=ED.I_Employee_ID
			INNER JOIN EOS.T_Employee_KRA_Details EKD
				ON EKM.I_Employee_ID=EKD.I_Employee_ID
				AND EKM.I_KRA_ID=EKD.I_KRA_ID
				AND ((EKM.I_SubKRA_ID=EKD.I_SubKRA_ID) OR (EKM.I_SubKRA_ID IS NULL AND EKD.I_SubKRA_ID IS NULL))
			INNER JOIN EOS.T_KRA_Master KM1
				ON EKM.I_KRA_ID=KM1.I_KRA_ID
			INNER JOIN EOS.T_KRA_Index_Master KIM1
				ON KM1.I_KRA_Index_ID=KIM1.I_KRA_Index_ID
			LEFT OUTER JOIN EOS.T_KRA_Master KM2
				ON EKM.I_SubKRA_ID=KM2.I_KRA_ID
			LEFT OUTER JOIN EOS.T_KRA_Index_Master KIM2
				ON KM2.I_KRA_Index_ID=KIM2.I_KRA_Index_ID
			INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON ED.I_Centre_Id=FN1.CenterID
			INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
				ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
	  WHERE EKD.I_Target_Month IN(SELECT * FROM dbo.fnString2Rows(@AllMonth,','))
		AND EKD.I_Target_Year=@iYear
		AND EKM.I_Employee_ID=ISNULL(@iEmployeeID,EKM.I_Employee_ID)

	 SELECT DISTINCT
			TMP.I_Employee_ID,
			TMP.S_Emp_ID,
			TMP.EmpName,
			TMP.N_Weightage,
			TMP.I_Target_Year,
			TMP.I_KRA_ID,
			TMP.I_SubKRA_ID,
			TMP.I_KRA_Type,
			TMP.KRA,
			TMP.SubKRA,
			TMP.MeasuringIndex,
			TMP.I_Centre_Id,
			TMP.CenterCode,
			TMP.CenterName,
			TMP.InstanceChain,
			MonthStart=@StartMonth,
			Target1= ISNULL ((SELECT TMP1.N_Target_Set 
					   FROM #TmpPMSReport TMP1 
					  WHERE TMP1.I_Employee_ID=TMP.I_Employee_ID
						AND TMP1.I_KRA_ID=TMP.I_KRA_ID
						AND ((TMP1.I_SubKRA_ID=TMP.I_SubKRA_ID) OR (TMP1.I_SubKRA_ID IS NULL AND TMP.I_SubKRA_ID IS NULL))
						AND TMP1.I_Target_Month=@StartMonth),0.00),
			Target2= ISNULL ((SELECT TMP1.N_Target_Set 
					   FROM #TmpPMSReport TMP1 
					  WHERE TMP1.I_Employee_ID=TMP.I_Employee_ID
						AND TMP1.I_KRA_ID=TMP.I_KRA_ID
						AND ((TMP1.I_SubKRA_ID=TMP.I_SubKRA_ID) OR (TMP1.I_SubKRA_ID IS NULL AND TMP.I_SubKRA_ID IS NULL))
						AND TMP1.I_Target_Month=@StartMonth+1),0.00),
			Target3=ISNULL((SELECT TMP1.N_Target_Set 
					   FROM #TmpPMSReport TMP1 
					  WHERE TMP1.I_Employee_ID=TMP.I_Employee_ID
						AND TMP1.I_KRA_ID=TMP.I_KRA_ID
						AND ((TMP1.I_SubKRA_ID=TMP.I_SubKRA_ID) OR (TMP1.I_SubKRA_ID IS NULL AND TMP.I_SubKRA_ID IS NULL))
						AND TMP1.I_Target_Month=@StartMonth+2),0.00),
			Achive1=ISNULL((SELECT TMP1.N_Target_Achieved 
					   FROM #TmpPMSReport TMP1 
					  WHERE TMP1.I_Employee_ID=TMP.I_Employee_ID
						AND TMP1.I_KRA_ID=TMP.I_KRA_ID
						AND ((TMP1.I_SubKRA_ID=TMP.I_SubKRA_ID) OR (TMP1.I_SubKRA_ID IS NULL AND TMP.I_SubKRA_ID IS NULL))
						AND TMP1.I_Target_Month=@StartMonth),0.00),
			Achive2=ISNULL((SELECT TMP1.N_Target_Achieved 
					   FROM #TmpPMSReport TMP1 
					  WHERE TMP1.I_Employee_ID=TMP.I_Employee_ID
						AND TMP1.I_KRA_ID=TMP.I_KRA_ID
						AND ((TMP1.I_SubKRA_ID=TMP.I_SubKRA_ID) OR (TMP1.I_SubKRA_ID IS NULL AND TMP.I_SubKRA_ID IS NULL))
						AND TMP1.I_Target_Month=@StartMonth+1),0.00),
			Achive3=ISNULL((SELECT TMP1.N_Target_Achieved 
					   FROM #TmpPMSReport TMP1 
					  WHERE TMP1.I_Employee_ID=TMP.I_Employee_ID
						AND TMP1.I_KRA_ID=TMP.I_KRA_ID
						AND ((TMP1.I_SubKRA_ID=TMP.I_SubKRA_ID) OR (TMP1.I_SubKRA_ID IS NULL AND TMP.I_SubKRA_ID IS NULL))
						AND TMP1.I_Target_Month=@StartMonth+2),0.00)
	  FROM #TmpPMSReport TMP

	 DROP TABLE #TmpPMSReport

END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
