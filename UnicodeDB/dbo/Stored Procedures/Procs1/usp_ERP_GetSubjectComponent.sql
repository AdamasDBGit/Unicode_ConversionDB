-- =============================================  
-- Author:  <Parichoy Nandi>  
-- Create date: <4th june 2024>  
-- Description: <to get the stream>  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_GetSubjectComponent]  
 @iSubjectComponentID int = null,  
 @iBrandID int  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
select SC.I_Subject_Component_ID as SubjectComponentID,  
SC.S_Subject_Component_Name as SubjectComponentName,  
SC.Is_Active as SubjectComponentActive from T_ERP_Subject_Component SC  
where I_Brand_ID = @iBrandID and  SC.I_Subject_Component_ID= ISNULL(@iSubjectComponentID,SC.I_Subject_Component_ID)  
 ORDER BY SC.I_Subject_Component_ID ASC;  
   
 END
