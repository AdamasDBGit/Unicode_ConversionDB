CREATE PROCEDURE [dbo].[usp_ERP_GetTeacherByToken]  
(  
 @sToken nvarchar(max)  
)  
AS  
BEGIN  
DECLARE @userid int  
---------------------
DECLARE @CurrentDate DATE = GETDATE();

DECLARE @FinancialYearStart DATE;
DECLARE @FinancialYearEnd DATE;

-- Determine the financial year start date
IF MONTH(@CurrentDate) >= 4
    SET @FinancialYearStart = DATEFROMPARTS(YEAR(@CurrentDate), 4, 1); -- Financial year starts from April
ELSE
    SET @FinancialYearStart = DATEFROMPARTS(YEAR(@CurrentDate) - 1, 4, 1);

-- Determine the financial year end date
SET @FinancialYearEnd = DATEFROMPARTS(YEAR(@FinancialYearStart) + 1, 3, 31); -- Financial year ends in March

--SELECT @FinancialYearStart AS FinancialYearStartDate, @FinancialYearEnd AS FinancialYearEndDate;

Declare @currentSessionid int
SET @currentSessionid =(select I_School_Session_ID FROM T_School_Academic_Session_Master WHERE I_Current_Session = 1 and Dt_Session_Start_Date=@FinancialYearStart
AND Dt_Session_End_Date=@FinancialYearEnd AND I_Status=1)
--------------------
set @userid=(select I_User_ID from T_ERP_User where S_Token =@sToken)  
print @currentSessionid
select   
 t1.I_Faculty_Master_ID FacultyMasterID  
,t1.S_Mobile_No MobileNo  
,t1.S_Faculty_Code EmployeeID  
,t1.S_Faculty_Name Name  
,TU.S_Photo ProfileImage  
,convert(nvarchar(MAX), t1.Dt_DOJ, 23) DOJ  
,convert(nvarchar(MAX), t1.Dt_DOB, 23) DOB  
,t1.S_Gender Gender  
,t1.S_Mobile_No ContactNo  
,t1.S_Email EmailID  
,t1.S_Present_Address Address  
,t1.I_Brand_ID BrandID  
,t2.S_Brand_Name BrandName  
,t3.S_Label
from T_Faculty_Master t1   
inner join T_Brand_Master t2 on t2.I_Brand_ID = t1.I_Brand_ID  
inner join T_School_Academic_Session_Master t3 on t3.I_School_Session_ID =@currentSessionid
left join T_User_Profile TU ON TU.I_User_ID=t1.I_User_ID
where t1.I_User_ID = @userid  
  
  
END
