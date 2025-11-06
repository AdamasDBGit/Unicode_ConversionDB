-- =============================================  
-- Author:  <Parichoy Nandi>  
-- Create date: <29th aug 2023>  
-- Description: <to get the events>  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_GetWeekDayMaster]  
 -- Add the parameters for the stored procedure here  
 @sDayName nvarchar(50) = null  
   
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
   
    SELECT   [I_Day_ID] DayID  
      ,[S_Day_Name] DayName  
      ,[S_CreatedBy]  
      ,[Dt_CreatedOn]  
      ,[S_UpdatedBy]  
      ,[Dt_UpdatedOn]  
  FROM [dbo].[T_Week_Day_Master]  
  where [S_Day_Name] = ISNULL(@sDayName,[S_Day_Name])  
   
  
END
