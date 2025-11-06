-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2025-March-17>
-- Description:	<Get Financial Sync Status>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_Get_Financial_Sync] 
	-- Add the parameters for the stored procedure here
	@iBrandID int=null,
	@iAcademicSession int=null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @AcademicSessionStartDate datetime=null,@AcademicSessionEndDate datetime=null

	IF @iAcademicSession IS NOT NULL
		BEGIN

			select 
			@AcademicSessionStartDate=Dt_Session_Start_Date ,@AcademicSessionEndDate=Dt_Session_End_Date	
			from T_School_Academic_Session_Master where I_School_Session_ID= @iAcademicSession

		END


	create table #FinancialStatus
	(
	I_Financial_Status_ID int,
	S_Financial_Status_Desc varchar(max)
	)

	IF @iAcademicSession IS NULL  OR @AcademicSessionStartDate IS NULL OR @AcademicSessionEndDate IS NULL
	 BEGIN
		SET @AcademicSessionStartDate = DATEFROMPARTS(YEAR(GETDATE()), 1, 1);   
		SET @AcademicSessionEndDate = DATEFROMPARTS(YEAR(GETDATE()), 12, 31);  
	 END

-- Create temporary table to store results
IF OBJECT_ID('tempdb..#MonthList') IS NOT NULL
    DROP TABLE #MonthList;

CREATE TABLE #MonthList (
    MonthStartDay DATE,
    MonthLastDay DATE,
	MonthNo int,
	TransactionYear int
);

WITH MonthList AS (
    -- Generate the first day of each month within the range
    SELECT DATEADD(DAY, -DAY(@AcademicSessionStartDate) + 1, @AcademicSessionStartDate) AS first_of_month
    UNION ALL
    SELECT DATEADD(MONTH, 1, first_of_month)
    FROM MonthList
    WHERE first_of_month < DATEADD(DAY, -DAY(@AcademicSessionEndDate) + 1, @AcademicSessionEndDate)
)
-- Insert the computed results into the temporary table
INSERT INTO #MonthList (MonthStartDay, MonthLastDay,MonthNo,TransactionYear)
SELECT 
    first_of_month AS MonthStartDay,
    EOMONTH(first_of_month) AS MonthLastDay,
	MONTH(first_of_month),
	YEAR(first_of_month)
FROM MonthList
OPTION (MAXRECURSION 100);


--select * from #MonthList

SELECT  m.TransactionYear as TransactionYear, 
m.MonthStartDay,m.MonthLastDay,
CASE 
WHEN  ERPTransaction.Transaction_Count <= 0 THEN 'Pending' 
WHEN  (ERPTransaction.Transaction_Count > 0 AND FSL.TransactionMonth IS NULL ) 
OR  (ERPTransaction.Transaction_Count > 0 AND FSL.IsPush = 1 AND FSL.IsGLPushed=0 ) THEN 'Completed' 
WHEN (ERPTransaction.Transaction_Count > 0 AND FSL.IsPush = 1 AND FSL.IsGLPushed=1 ) THEN 'GL Posted'
END FinancialStatus,
CASE 
WHEN ERPTransaction.Transaction_Count <= 0 THEN 1
WHEN(ERPTransaction.Transaction_Count > 0 AND FSL.IsPush = 1 AND FSL.IsGLPushed=0 ) THEN 2 
WHEN (ERPTransaction.Transaction_Count > 0 AND FSL.IsPush = 1 AND FSL.IsGLPushed=1 )  THEN 3
END ActionStatus


FROM #MonthList AS m
LEFT JOIN 
(
    SELECT 
        YEAR(Transaction_Date) AS Transaction_Year,
        MONTH(Transaction_Date) AS Transaction_Month,
        COUNT(*) AS Transaction_Count
    FROM ERP.T_Student_Transaction_Details
    GROUP BY YEAR(Transaction_Date), MONTH(Transaction_Date)
) AS ERPTransaction 
ON ERPTransaction.Transaction_Year = m.TransactionYear 
AND ERPTransaction.Transaction_Month = m.MonthNo

LEFT JOIN FinancialSyncLogs AS FSL 
ON FSL.TransactionMonth = m.MonthNo 
AND FSL.TransactionYear = m.TransactionYear

WHERE CAST(CONCAT(m.TransactionYear, '-', m.MonthNo, '-1') AS DATE) 
      > CAST(CONCAT(YEAR(GETDATE()), '-', MONTH(GETDATE()), '-1') AS DATE);



END
