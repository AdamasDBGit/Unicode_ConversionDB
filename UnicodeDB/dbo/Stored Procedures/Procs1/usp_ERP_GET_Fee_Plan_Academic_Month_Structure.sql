-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--exec [usp_ERP_GET_Fee_Plan_Academic_Month_Structure] 1164,35
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GET_Fee_Plan_Academic_Month_Structure]
	-- Add the parameters for the stored procedure here
	@iFeeScheduleID INT,
	@iAcademicSession INT
AS
BEGIN
	
DECLARE @AcademicStartDate DATE = NULL;
DECLARE @AcademicEndDate DATE = NULL;

DECLARE @StartPeriodMonth int=NULL
DECLARE @EndPeriodMonth int=NULL
DECLARE @IsBeginningOfInstallmentBucket bit='true'
-- Fetch start and end dates
SELECT 
    @AcademicStartDate = Dt_Session_Start_Date,
    @AcademicEndDate = Dt_Session_End_Date
FROM T_School_Academic_Session_Master 
WHERE I_School_Session_ID = @iAcademicSession;

select @StartPeriodMonth=Start_Period_Month,@EndPeriodMonth=End_Period_Month,
@IsBeginningOfInstallmentBucket=CASE WHEN OPS.Payment_Schedule_Desc IS NULL OR OPS.Payment_Schedule_Desc like '%Beginning%'  THEN 'true' ELSE 'false' END 
from T_ERP_Fee_Structure TEFS 
inner join 
T_ERP_Overall_Payment_Schedule as OPS on TEFS.Payment_Schedule=OPS.I_Overall_Payment_Schedule_ID
and TEFS.I_Fee_Structure_ID=@iFeeScheduleID
--select @IsBeginningOfInstallmentBucket 
-- Calculate the start and end dates for the month range

-- Calculate the start date based on the academic session and start period month
DECLARE @StartDate DATE,@EndDate DATE

IF @StartPeriodMonth < MONTH(@AcademicStartDate)
    SET @StartDate = DATEFROMPARTS(YEAR(@AcademicStartDate) + 1, @StartPeriodMonth, 1);
ELSE
    SET @StartDate = DATEFROMPARTS(YEAR(@AcademicStartDate), @StartPeriodMonth, 1);

-- Calculate the end date based on the academic session and end period month
IF @EndPeriodMonth < MONTH(@AcademicStartDate)
    SET @EndDate = EOMONTH(DATEFROMPARTS(YEAR(@AcademicStartDate) + 1, @EndPeriodMonth, 1));
ELSE
    SET @EndDate = EOMONTH(DATEFROMPARTS(YEAR(@AcademicStartDate), @EndPeriodMonth, 1));
print @StartPeriodMonth
print @EndPeriodMonth
print @StartDate
print @AcademicStartDate
print @EndDate
print @AcademicEndDate

IF @StartDate >= @AcademicStartDate AND @EndDate <= @AcademicEndDate

BEGIN
print 1234

print 'range'
	print @StartDate
	print @EndDate

	select @AcademicStartDate as AcademicStartDate,@AcademicEndDate AcademicEndDate,@StartPeriodMonth as StartPeriodMonth,
	@EndPeriodMonth as EndPeriodMonth,
	@IsBeginningOfInstallmentBucket IsBeginningOfInstallmentBucket ,'true' as ValidAcademicSession

	-- Check if dates are fetched correctly
	IF @StartDate IS NOT NULL AND @EndDate IS NOT NULL
	BEGIN

	--print 'range'
	--print @StartDate
	--print @EndDate

		-- Generate month and year range using recursive CTE
		WITH DateRange AS (
			SELECT 
				MONTH(@StartDate) AS MonthNumber, 
				YEAR(@StartDate) AS YearValue, 
				@StartDate AS CurrentDate
			UNION ALL
			SELECT 
				MONTH(DATEADD(MONTH, 1, CurrentDate)), 
				YEAR(DATEADD(MONTH, 1, CurrentDate)), 
				DATEADD(MONTH, 1, CurrentDate)
			FROM DateRange
			WHERE DATEADD(MONTH, 1, CurrentDate) <= @EndDate
		)
		SELECT MonthNumber, YearValue
		FROM DateRange
		OPTION (MAXRECURSION 0); -- 0 removes the recursion limit



		select TEFSIC.R_I_Fee_Structure_ID as FeeStructureID,
	   TEFSIC.R_I_Fee_Component_ID AS FeeComponentID,
	   TEFSIC.N_Component_Actual_Total_Annual_Amount as TotalAmount,
	   TEFSIC.Installm_Range_PreAdm as PreAdmissionRange,
	   TERC.S_Component_Name AS FeeComponentName,
		TEFSIC.I_Seq_No AS SeqNo,
		TEFSIC.Is_OneTime AS IsOneTime,
		TEFSIC.R_I_Fee_Pay_Installment_ID AS FeePayInstallmentID,
		TEFPT.S_Installment_Frequency AS InstallmentFrequency,
		TEFPT.I_Pay_InstallmentNo AS PayInstallmentNo,
		TEFPT.I_Interval AS PayInterval,
		TEFSIC.Is_During_Admission AS IsDuringAdmission,
		TEFSIC.I_Start_Period_Month as ComponentStartPeriodMonth,
		TEFSIC.I_End_Period_Month as ComponentEndPeriodMonth,
		TEFSIC.I_Fee_Structure_Installment_Component_ID as FeeStructureInstallmentComponentID
	   from T_ERP_Fee_Structure_Installment_Component as TEFSIC
	   inner join
	   T_ERP_Fee_Structure as EFS on TEFSIC.R_I_Fee_Structure_ID=EFS.I_Fee_Structure_ID
	   left join T_Fee_Component_Master as TERC on TERC.I_Fee_Component_ID = TEFSIC.R_I_Fee_Component_ID 
	   left join T_ERP_Fee_PaymentInstallment_Type as TEFPT on TEFSIC.R_I_Fee_Pay_Installment_ID = TEFPT.I_Fee_Pay_Installment_ID and TEFPT.Is_Active = 1
	   where TEFSIC.R_I_Fee_Structure_ID=@iFeeScheduleID








	END
	ELSE
	BEGIN
		PRINT 'Start Date or End Date is NULL. Please check the data.';
	END;

END
ELSE
BEGIN
	select @AcademicStartDate as AcademicStartDate,@AcademicEndDate AcademicEndDate,@StartPeriodMonth as StartPeriodMonth,
	@EndPeriodMonth as EndPeriodMonth,
	@IsBeginningOfInstallmentBucket IsBeginningOfInstallmentBucket ,'true' as ValidAcademicSession

	-- Check if dates are fetched correctly
	IF @StartDate IS NOT NULL AND @EndDate IS NOT NULL
	BEGIN
		-- Generate month and year range using recursive CTE
		WITH DateRange AS (
    SELECT 
        MONTH(@StartDate) AS MonthNumber, 
        YEAR(@StartDate) AS YearValue, 
        @StartDate AS CurrentDate
    UNION ALL
    SELECT 
        MONTH(DATEADD(MONTH, 1, CurrentDate)), 
        YEAR(DATEADD(MONTH, 1, CurrentDate)), 
        DATEADD(MONTH, 1, CurrentDate)
    FROM DateRange
    WHERE DATEADD(MONTH, 1, CurrentDate) <= @EndDate
)
SELECT MonthNumber, YearValue
FROM DateRange
OPTION (MAXRECURSION 0); -- 0 removes the recursion limit




		select TEFSIC.R_I_Fee_Structure_ID as FeeStructureID,
	   TEFSIC.R_I_Fee_Component_ID AS FeeComponentID,
	   TEFSIC.N_Component_Actual_Total_Annual_Amount as TotalAmount,
	   TEFSIC.Installm_Range_PreAdm as PreAdmissionRange,
	   TERC.S_Component_Name AS FeeComponentName,
		TEFSIC.I_Seq_No AS SeqNo,
		TEFSIC.Is_OneTime AS IsOneTime,
		TEFSIC.R_I_Fee_Pay_Installment_ID AS FeePayInstallmentID,
		TEFPT.S_Installment_Frequency AS InstallmentFrequency,
		TEFPT.I_Pay_InstallmentNo AS PayInstallmentNo,
		TEFPT.I_Interval AS PayInterval,
		TEFSIC.Is_During_Admission AS IsDuringAdmission,
		TEFSIC.I_Start_Period_Month as ComponentStartPeriodMonth,
		TEFSIC.I_End_Period_Month as ComponentEndPeriodMonth,
		TEFSIC.I_Fee_Structure_Installment_Component_ID as FeeStructureInstallmentComponentID
	   from T_ERP_Fee_Structure_Installment_Component as TEFSIC
	   inner join
	   T_ERP_Fee_Structure as EFS on TEFSIC.R_I_Fee_Structure_ID=EFS.I_Fee_Structure_ID
	   left join T_Fee_Component_Master as TERC on TERC.I_Fee_Component_ID = TEFSIC.R_I_Fee_Component_ID 
	   left join T_ERP_Fee_PaymentInstallment_Type as TEFPT on TEFSIC.R_I_Fee_Pay_Installment_ID = TEFPT.I_Fee_Pay_Installment_ID and TEFPT.Is_Active = 1
	   where TEFSIC.R_I_Fee_Structure_ID=@iFeeScheduleID








	END
	ELSE
	BEGIN
		PRINT 'Start Date or End Date is NULL. Please check the data.';
	END;
END


END
