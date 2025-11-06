-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [EXAMINATION].[uspEditHomework]
(
@iHomeworkId INT,
@sHomeworkName varchar(200),
@sHomeworkDesc varchar(2000),
@dSubmissionDate datetime = NULL ,
@sUpdatedBy VARCHAR(50)= NULL,
@dUpdatedOn datetime = NULL
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   Update  EXAMINATION.T_Homework_Master set  S_Homework_Name= @sHomeworkName,  S_Homework_Desc=@sHomeworkDesc,Dt_Submission_Date=@dSubmissionDate,
   S_Updt_By=@sUpdatedBy,Dt_Updt_On=@dUpdatedOn  where  I_Homework_ID= @iHomeworkId
  
		
END
