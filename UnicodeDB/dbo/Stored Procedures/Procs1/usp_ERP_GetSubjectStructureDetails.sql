-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <16th OCT,2023>
-- Description:	<to get the subject structure>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetSubjectStructureDetails]
	-- Add the parameters for the stored procedure here
	@SubjectStructureHeaderID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	  select SS.I_Subject_Structure_ID as SubjectStructureID,
  SS.I_Parent_Subject_Structure_ID as ParentID,
  SS.S_Name as StructureName,
  SS.I_Subject_Template_ID as TemplateID,
  ST.S_Structure_Name as StructureHeaderName,
  SS.Methodology as Methodology,
  SS.Objective as Objective
  from [dbo].[T_ERP_Subject_Structure] as SS
  join [dbo].[T_ERP_Subject_Template] as ST 
  on SS.I_Subject_Template_ID=ST.I_Subject_Template_ID
  where SS.I_Subject_Structure_Header_ID=@SubjectStructureHeaderID
END
