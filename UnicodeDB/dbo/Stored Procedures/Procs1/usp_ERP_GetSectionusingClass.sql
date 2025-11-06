-- =============================================  
-- Author:  <Parichoy Nandi>  
-- Create date: <17-11-2023>  
-- Description: <to get the list of session list>  
-- =============================================  
CREATE   PROCEDURE [dbo].[usp_ERP_GetSectionusingClass]  
 -- Add the parameters for the stored procedure here  
 @iClassID int null  
 AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
   
  
   
  select s.S_Section_Name as SectionName,  
  cs.[I_Section_ID] as SectionID from  [dbo].[T_ERP_Class_Section] as CS 
  join [dbo].[T_Section] as s on cs.I_Section_ID=s.I_Section_ID  
  where   
  CS.I_Class_ID= ISNULL(@iClassID,CS.I_Class_ID)
  group by S.S_Section_Name,cs.I_Section_ID,s.I_Section_ID  
  union all
  select S_Section_Name as SectionName,I_Section_ID as SectionID  from t_section where is_Default=1
  
    
END  