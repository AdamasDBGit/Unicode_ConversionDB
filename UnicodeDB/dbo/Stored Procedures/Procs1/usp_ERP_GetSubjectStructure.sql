-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetSubjectStructure]
-- Add the parameters for the stored procedure here
	@TemplateHeaderID int,
	@SubjectID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	  select SSH.I_Subject_Structure_Header_ID from 
	  [dbo].[T_ERP_Subject_Structure_Header] as SSH
	  where SSH.I_Subject_Template_Header_ID = @TemplateHeaderID and SSH.I_Subject_ID=@SubjectID
END
