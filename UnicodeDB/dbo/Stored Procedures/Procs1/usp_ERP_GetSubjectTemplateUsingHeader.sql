-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <26th Sept 2023>
-- Description:	<to get Subject Template using headedID>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetSubjectTemplateUsingHeader]
	-- Add the parameters for the stored procedure here
	@iSubjectTemplateID int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
  SELECT 
  ST.I_Subject_Template_ID as TemplateID,
    ST.I_Subject_Template_Header_ID as SubjectTemplateHeaderID,
    ST.S_Structure_Name as StructureName,
    ST.I_Sequence_Number as SequenceNumber
FROM 
    [dbo].[T_ERP_Subject_Template] as ST where ST.I_Subject_Template_Header_ID=@iSubjectTemplateID
ORDER BY 
    ST.I_Sequence_Number ASC; 
END
