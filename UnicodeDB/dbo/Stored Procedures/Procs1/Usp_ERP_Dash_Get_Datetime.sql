CREATE Proc [dbo].[Usp_ERP_Dash_Get_Datetime]  
as  
Begin  
DECLARE @currentDateTime DATETIME = GETDATE();  
DECLARE @currentDate DATE = CAST(@currentDateTime AS DATE);  
DECLARE @currentTime TIME(0) = CAST(@currentDateTime AS TIME);  
  
SELECT @currentDate AS CurrentDate, @currentTime AS CurrentTime;  
End
