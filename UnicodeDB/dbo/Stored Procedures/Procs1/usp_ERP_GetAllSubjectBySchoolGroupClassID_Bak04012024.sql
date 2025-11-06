-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
  
-- exec [dbo].[usp_ERP_GetAllSubjectBySchoolGroupClassID] 1, 13  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_GetAllSubjectBySchoolGroupClassID_Bak04012024]   
 -- Add the parameters for the stored procedure here  
 (  
  @SchoolGroupID INT = NULL,  
  @ClassID int = null  
 )  
AS  
BEGIN  
select   
I_Subject_ID AS SubjectID,  
S_Subject_Name AS SubjectName  
from [T_Subject_Master] TSM  
where TSM.I_School_Group_ID = @SchoolGroupID and TSM.I_Class_ID = @ClassID  
END
