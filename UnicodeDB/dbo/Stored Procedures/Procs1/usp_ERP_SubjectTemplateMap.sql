-- =============================================  
-- Author:  <Parichoy Nandi>  
-- Create date: <5th OCT 2023>  
-- Description: <to add or update the SubjectTemplateMap>  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_SubjectTemplateMap]   
 -- Add the parameters for the stored procedure here  
 @iSubjectTemplateHeader int,  
 @iSubjectID int,  
 @iCreatedBy int,  
 @iSubjectStructureHeader int = null  
AS  
begin transaction  
BEGIN TRY   
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
 if(@iSubjectStructureHeader>0)  
   
 BEGIN  
 if exists(Select * from [dbo].[T_ERP_Subject_Structure] where [I_Subject_Template_ID]= @iSubjectTemplateHeader)  
 BEGIN  
 SELECT 1 StatusFlag,'Delete denied(Subject Structure exists)' Message  
 END  
 else  
 BEGIN  
 update [dbo].[T_ERP_Subject_Structure_Header]  
 set   
 [I_Subject_Template_Header_ID] = @iSubjectTemplateHeader,  
 [I_CreatedBy]     = @iCreatedBy,  
 [Dt_CreatedAt]     = GETDATE()  
 where I_Subject_Structure_Header_ID = @iSubjectStructureHeader  
  
 SELECT 1 StatusFlag,'Subject-Template Mapping updated' Message  
 END  
 END  
   
 ELSE  
   
 BEGIN  
 IF exists (select * from [dbo].[T_ERP_Subject_Structure_Header] where I_Subject_ID = @iSubjectID)  
 BEGIN  
 SELECT 0 StatusFlag,'Mapping Already Exist' Message  
 END  
 ELSE  
 BEGIN  
 INSERT INTO [dbo].[T_ERP_Subject_Structure_Header]  
(  
[I_Subject_Template_Header_ID]  
      ,[I_Subject_ID]  
      ,[I_CreatedBy]  
   ,[Dt_CreatedAt]  
)  
VALUES  
(  
 @iSubjectTemplateHeader,  
 @iSubjectID,  
 @iCreatedBy,  
 GETDATE()  
)  
  
 SELECT 1 StatusFlag,'Subject-Template Mapped' Message  
 END  
   
END  
   
  
END  
END TRY  
BEGIN CATCH  
 rollback transaction  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
select 0 StatusFlag,@ErrMsg Message  
END CATCH  
commit transaction
