CREATE PROCEDURE [dbo].[usp_ERP_FacultySubjectUpdate] 
-- =============================================
     -- Author:	Arijit Manna
-- Create date: 21-09-2023
-- Description:	Faculty subject map
-- =============================================
-- Add the parameters for the stored procedure here
	
@FacultyID int =null,
@UTSubject UT_FacultySubject readonly,
@CreatedBy int=null

AS
BEGIN
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
       SET NOCOUNT ON;
	   delete from T_ERP_Faculty_Subject where I_Faculty_Master_ID = @FacultyID
	   INSERT INTO T_ERP_Faculty_Subject
	   (
	   I_Faculty_Master_ID
	   ,I_Subject_ID
	   ,I_Is_Primary
	   ,I_Status
	   ,I_CreatedBy
	   ,Dt_CreatedAt
	   )
	   select @FacultyID,SubjectID,IsPrimary,1,@CreatedBy,GETDATE() from  @UTSubject
	   select 1 as statusFlag, 'Subject updated successfully' as Message

END TRY
BEGIN CATCH  
    
 select 0 as statusFlag, ERROR_MESSAGE() as Message
          
END CATCH; 

END
