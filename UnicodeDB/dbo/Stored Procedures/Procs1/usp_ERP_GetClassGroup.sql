-- =============================================  
-- Author:  <Parichoy Nandi>  
-- Create date: <18th September,2023>  
-- Description: <to get the details of class group>  
--exec [dbo].[usp_ERP_GetClassGroup] 107,1  
-- =============================================  
CREATE   PROCEDURE [dbo].[usp_ERP_GetClassGroup]  
 -- Add the parameters for the stored procedure here  
 @iBrandid int,  
 @iGroupID int = null  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 if(@iGroupID is null)  
 BEGIN  
 Select TSG.I_School_Group_ID as GroupID,  
 TSG.I_Brand_Id as BrandID,  
 TSG.S_School_Group_Code as GroupCode,  
 TSG.S_School_Group_Name as GroupName,  
 TSG.I_Status as GroupStatus  
 FROM [dbo].[T_School_Group] as TSG where I_Brand_Id=@iBrandid  
 and TSG.I_Status=1  
 Order by TSG.I_School_Group_ID   
 END  
 else  
 BEGIN  
 DECLARE @classid int  
 Select TSG.I_School_Group_ID as GroupID,  
 TSG.I_Brand_Id as BrandID,  
 TSG.S_School_Group_Code as GroupCode,  
 TSG.S_School_Group_Name as GroupName,  
 TSG.I_Status as GroupStatus  
 FROM [dbo].[T_School_Group] as TSG   
 where TSG.I_School_Group_ID=@iGroupID and TSG.I_Status=1  
 order by TSG.I_School_Group_ID  
  
 select I_Class_ID ClassID from T_School_Group_Class where I_School_Group_ID = @iGroupID  
 set @classid = (select top 1 I_Class_ID ClassID from T_School_Group_Class where I_School_Group_ID = @iGroupID)  
 select top 1 Start_Time StartTime,End_Time EndTime from T_School_Group_Class_Timing where I_School_Group_ID = @iGroupID and I_Class_ID =@classid  
   
 END  
END  