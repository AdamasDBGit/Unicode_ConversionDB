CREATE FUNCTION [dbo].[GetInstallmentDatesInFinancialYear]
(
    @FinancialYearStart DATE,
    @FinancialYearEnd DATE,
    @InstallmentStartDate DATE,
    @InstallmentFrequencyMonths INT
	--@AcademicSessionID Int
)

RETURNS TABLE
AS

RETURN
(

    WITH DateCTE AS
    (

        SELECT 
            @InstallmentStartDate AS InstallmentDate
        UNION ALL
        SELECT 
            DATEADD(MONTH, @InstallmentFrequencyMonths, InstallmentDate)
        FROM 
            DateCTE
        WHERE 
            DATEADD(MONTH, @InstallmentFrequencyMonths, InstallmentDate) <= @FinancialYearEnd
    )
    SELECT
	 InstallmentDate
        
    FROM 
        DateCTE
    WHERE 
        InstallmentDate >= @FinancialYearStart
)
;