-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <01-11-2023>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetSubjectStructureData]
	-- Add the parameters for the stored procedure here
	@SubjectTemplateHeaderID int,
	@SubjectID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		ST.[I_Subject_Template_ID] as SubjectTemplateID
      ,ST.[I_Subject_Template_Header_ID] as SubjectTemplateHeaderID
      ,ST.[S_Structure_Name] as StructureName
      ,ST.[I_Sequence_Number] as SequenceNumber
      ,ST.[I_IsLeaf_Node] as LeafNode
  FROM [dbo].[T_ERP_Subject_Template] as ST
  where I_Subject_Template_Header_ID=@SubjectTemplateHeaderID

  DECLARE @output_I_Subject_Structure_Header_ID INT;
SELECT @output_I_Subject_Structure_Header_ID = I_Subject_Structure_Header_ID
FROM T_ERP_Subject_Structure_Header
WHERE I_Subject_Template_Header_ID = @SubjectTemplateHeaderID
AND I_Subject_ID = @SubjectID;

  SELECT 
		SS.[I_Subject_Structure_ID] as SubjectStructureID
      ,SS.[I_Subject_Structure_Header_ID] as SubjectStructureHeaderID
      ,SS.[I_Subject_Template_ID] as SubjectTemplateID
      ,SS.[I_Parent_Subject_Structure_ID] as ParentID
      ,SS.[S_Name] as StructureName
      ,SS.[I_Status] as StrucutureStatus
      ,SS.[Methodology] as Methodology
      ,SS.[Objective] as Objective
  FROM [dbo].[T_ERP_Subject_Structure] as SS
  where SS.[I_Subject_Structure_Header_ID]=@output_I_Subject_Structure_Header_ID and SS.I_Status=1
  ORDER BY 
    SubjectStructureID ASC;

END
