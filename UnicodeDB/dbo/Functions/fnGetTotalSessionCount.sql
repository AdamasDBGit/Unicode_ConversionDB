CREATE FUNCTION [dbo].[fnGetTotalSessionCount]  
(  
 @iBatchID INT,  
 @iCenterID INT,  
 @StartDate DateTime = Null,  
 @EndDate DateTime = Null  
)  
RETURNS INT  
AS  
BEGIN  
 DECLARE @iCount INT  
  
 SELECT @iCount = COUNT(I_Batch_Schedule_ID) FROM [dbo].[T_Student_Batch_Schedule] AS TSBS  
 WHERE [TSBS].[I_Batch_ID] = @iBatchID  
 AND ([TSBS].[I_Centre_ID] = @iCenterID  OR TSBS.I_Centre_ID is NULL)
 AND ((DATEDIFF(DD,ISNULL(@StartDate,[TSBS].[Dt_Schedule_Date]),[TSBS].[Dt_Schedule_Date]) >= 0   
 AND DATEDIFF(DD,ISNULL(@EndDate,[TSBS].[Dt_Schedule_Date]),[TSBS].[Dt_Schedule_Date])<= 0))  
 RETURN @iCount  
END