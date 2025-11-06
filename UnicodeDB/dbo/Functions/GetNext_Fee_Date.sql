CREATE FUNCTION dbo.GetNext_Fee_Date  
(  
    @InputDate DATE,  
    @IntervalMonths INT ,
	@AcademicSessionID int
)  
RETURNS DATE  
AS  
BEGIN  
    DECLARE @FinancialYearStart DATE;  
    DECLARE @FinancialYearEnd DATE;  
  

    SET @FinancialYearStart =(Select top 1 Convert(date,Dt_Session_Start_Date)  from T_School_Academic_Session_Master
	where I_School_Session_ID=@AcademicSessionID)
    SET @FinancialYearEnd =(Select top 1 Convert(Date,Dt_Session_End_Date) from T_School_Academic_Session_Master
	where I_School_Session_ID=@AcademicSessionID)
  
    DECLARE @NextDate DATE;  
  
    IF @InputDate >= @FinancialYearStart AND @InputDate <= @FinancialYearEnd  
    BEGIN  
        SET @NextDate = DATEADD(MONTH, @IntervalMonths, @InputDate);  
  
        IF @NextDate > @FinancialYearEnd  
            SET @NextDate = @FinancialYearEnd;  
    END  
    ELSE  
    BEGIN  
        SET @NextDate = Null;  
    END  
  
    RETURN @NextDate;  
END;