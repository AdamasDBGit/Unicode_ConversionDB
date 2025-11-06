-- =============================================  
-- Author:  <Parichoy Nandi>  
-- Create date: <20th sept 2023>  
-- Description: <to map the students>  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_StudentMapping]   
 -- Add the parameters for the stored procedure here  
 @iClassSectionID int =null,  
 @iStudentID int,  
 @iSessionID int,  
 @iSchoolGroupID int,  
 @iClassID int,  
 @iSectionID int,  
 @iStreamID int,  
 @iStudentStatus int  
  
AS  
begin transaction  
BEGIN TRY  
BEGIN  
SET NOCOUNT ON;  
 DECLARE @iClassGroupID int  
 set @iClassGroupID = (select SGC.I_School_Group_Class_ID as GroupClass from  [dbo].[T_School_Group_Class] SGC where SGC.I_School_Group_ID = @iSchoolGroupID and SGC.I_Class_ID =@iClassID)  
 if exists (select * from [T_Student_Class_Section] where [I_Student_Detail_ID] = @iStudentID and [I_School_Session_ID] = @iSessionID and [I_School_Group_Class_ID]=@iClassGroupID and [I_Section_ID]= @iSectionID and [I_Stream_ID] = @iStreamID)  
 BEGIN  
 SELECT 0 StatusFlag,'Duplicate Mapping' Message  
 END  
 else  
 BEGIN  
 if(@iClassSectionID>0)  
 BEGIN  
 update [dbo].[T_Student_Class_Section]  
 set   
 [I_Student_Detail_ID]   = @iStudentID,  
 [I_School_Session_ID]   = @iSessionID,  
 [I_School_Group_Class_ID]  = @iClassGroupID,  
 [I_Status]      = @iStudentStatus,  
 [I_Stream_ID]     = @iStreamID,  
 [I_Section_ID]     = @iSectionID  
 where I_Student_Class_Section_ID = @iClassSectionID  
 SELECT 1 StatusFlag,'Student Mapping updated' Message  
END  
 else  
 BEGIN  
 Insert into [dbo].[T_Student_Class_Section] (I_Student_Detail_ID,I_School_Session_ID,I_School_Group_Class_ID,I_Section_ID,I_Stream_ID,I_Status)  
 Values(@iStudentID,@iSessionID,@iClassGroupID,@iSectionID,@iStreamID,@iStudentStatus)  
 SELECT 1 StatusFlag,'Student Mapping added' Message  
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
