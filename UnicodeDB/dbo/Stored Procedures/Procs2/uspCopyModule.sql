CREATE PROCEDURE [dbo].[uspCopyModule]  
(  
 @iSourceModuleID INT,  
 @sDestinationModuleCode NVARCHAR(max),  
 @sDestinationModuleName NVARCHAR(max),  
 @sUpdatedBy NVARCHAR(max),  
 @dUpdatedOn DATETIME,  
 @iDestinationBrandID INT,  
 @sSkillID NVARCHAR(max) = NULL        
)  
  
AS   
  
BEGIN TRY  
  
    SET NoCount ON ;  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  
  
 DECLARE @I_Module_Id_New INT  
   
 BEGIN TRANSACTION  
 INSERT INTO [dbo].[T_Module_Master]  
 (  
   [I_Skill_ID]  
  ,[I_Brand_ID]  
  ,[S_Module_Code]  
  ,[S_Module_Name]  
  ,[I_No_Of_Session]  
  ,[S_Crtd_By]  
  ,[S_Upd_By]  
  ,[Dt_Crtd_On]  
  ,[Dt_Upd_On]  
  ,[I_Is_Editable]  
  ,[I_Status]  
 )  
        
 SELECT    
 Cast(@sSkillID As Int),  
 @iDestinationBrandID,  
 @sDestinationModuleCode,  
 @sDestinationModuleName,  
 [I_No_Of_Session],  
 @sUpdatedBy,  
 NULL,  
 @dUpdatedOn,  
 NULL,  
 [I_Is_Editable],  
 [I_Status]  
 FROM [dbo].[T_Module_Master]  
 WHERE I_Module_id=@iSourceModuleID  
  
 SET @I_Module_Id_New=SCOPE_IDENTITY()  
  
 INSERT INTO[dbo].[T_Session_Module_Map]  
 (  
  [I_Module_ID]  
  ,[I_Session_ID]  
  ,[I_Sequence]  
  ,[S_Crtd_By]  
  ,[S_Upd_By]  
  ,[Dt_Valid_From]  
  ,[Dt_Crtd_On]  
  ,[Dt_Valid_To]  
  ,[Dt_Upd_On]  
  ,[I_Status]  
 )  
 SELECT   
 @I_Module_Id_New  
 ,[I_Session_ID]  
 ,[I_Sequence]  
 ,@sUpdatedBy  
 ,NULL  
 ,@dUpdatedOn  
 ,@dUpdatedOn  
 ,NULL  
 ,NULL  
 ,[I_Status]  
 FROM [dbo].[T_Session_Module_Map]  
 WHERE I_Module_id=@iSourceModuleID  
 COMMIT TRANSACTION   
END TRY  
  
BEGIN CATCH  
 ROLLBACK TRANSACTION  
    DECLARE @ErrMsg NVARCHAR(max),@ErrSeverity INT  
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()  
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )  
  
END CATCH


