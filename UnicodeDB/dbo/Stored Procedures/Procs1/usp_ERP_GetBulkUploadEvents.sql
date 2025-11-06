-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
  
--exec usp_ERP_GetBulkUploadEvents 107
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_GetBulkUploadEvents]  
 -- Add the parameters for the stored procedure here  
 (  
  @iBrandid INT NULL  
 )  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 Select Te.I_Event_ID,Te.S_Event_Name, Te.S_Event_Desc,TEC.S_Event_Category,c.S_Class_Name,  
 sg.S_School_Group_Name,Te.I_EventFor, Te.Dt_StartDate,Te.Dt_EndDate, Te.I_Status  
 from T_Event TE  
 Left JOIN T_Event_Category TEC ON   
 TE.I_Event_Category_ID = TEC.I_Event_Category_ID  
 Left Join T_Event_Class EC on EC.I_Event_ID=TE.I_Event_ID  
 Left Join T_Class C on c.I_Class_ID=ec.I_Class_ID  and c.I_Brand_ID=@iBrandid
 Left Join T_School_Group SG on SG.I_School_Group_ID=ec.I_School_Group_ID   and SG.I_Brand_Id=@iBrandid
 where Is_Through_Bulk_upload =1 AND Te.I_Brand_ID = @iBrandid  
 order by Te.Dt_StartDate desc
END
