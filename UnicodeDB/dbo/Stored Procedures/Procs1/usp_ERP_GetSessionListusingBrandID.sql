-- =============================================  
-- Author:  <Parichoy Nandi>  
-- Create date: <17-01-2024>  
-- Description: <to get the list of session list using brand>  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_GetSessionListusingBrandID]  
 -- Add the parameters for the stored procedure here  
 @iBrandID int = null  
 AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 Select SASM.I_School_Session_ID as SchoolSessionID,
 SASM.S_Label as SessionLabel, 
SASM.I_Brand_ID as BrandID,  
BM.S_Brand_Name as BrandName,  
 
SASM.Dt_Session_Start_Date as StartDate,  
SASM.Dt_Session_End_Date as EndDate,  
SASM.I_Status as SessionStatus,  
SASM.I_Current_Session CurrentSession  
from [T_School_Academic_Session_Master] as SASM left join [T_Brand_Master] as BM on  
SASM.I_Brand_ID = BM.I_Brand_ID   
where SASM.I_Brand_ID=@iBrandID order by SASM.I_School_Session_ID desc  
END  