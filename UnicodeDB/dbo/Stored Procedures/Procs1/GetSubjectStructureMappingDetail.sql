CREATE PROCEDURE [dbo].[GetSubjectStructureMappingDetail]
-- =============================================
     -- Author:	Tridip Chatterjee
-- Create date: 03-10-2023
-- Description:	To Get thelist of subject mapped with structured template
-- =============================================
-- Add the parameters for the stored procedure here
@BrandID int =null,
@SubjectStructureHeaderID int =null,
@SubjectTemplateHeaderID int =null,
@SubjectID int =null,
@Title nvarchar(400)=null,
@SubjectName nvarchar(400)=null,
@SubjectStatus int =null,
@ClassID int =null,
@SchoolGroupID int =null,
@SubjectTemplateID int =null,
@SubjectStructureName nvarchar(400)=null


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

select
TESTH.I_Brand_ID,
TESSH.I_Subject_Structure_Header_ID,
TESSH.I_Subject_Template_Header_ID,
TESTH.S_Title,
TESSH.I_Subject_ID,
TSM.S_Subject_Name,
TSM.S_Subject_Code,
isnull (TSM.I_Status,0) as Subject_Staus,
TSM.I_Class_ID,
TSM.I_School_Group_ID,
TESTH.I_IsDefault,
TEST.I_Subject_Template_ID,
TEST.S_Structure_Name,
TEST.I_Sequence_Number,
isnull(TEST.I_IsLeaf_Node,0) as Leaf_Node_Status

from T_ERP_Subject_Structure_Header TESSH
left Join T_ERP_Subject_Template_Header TESTH on 
TESTH.I_Subject_Template_Header_ID=TESSH.I_Subject_Template_Header_ID
left join T_Subject_master TSM on TSM.I_Subject_ID=TESSH.I_Subject_ID
left join T_ERP_Subject_Template TEST on TEST.I_Subject_Template_Header_ID
=TESTH.I_Subject_Template_Header_ID
where
(TESTH.I_Brand_ID=@BrandID or @BrandID is null)
and 
(TESSH.I_Subject_Structure_Header_ID=@SubjectStructureHeaderID OR @SubjectStructureHeaderID is null)
and
(TESSH.I_Subject_Template_Header_ID=@SubjectTemplateHeaderID or @SubjectTemplateHeaderID is null)
and 
(TESSH.I_Subject_ID=@SubjectID or @SubjectID is null)
and
(TESTH.S_Title=@Title or @Title is null)
and
(TSM.S_Subject_Name=@SubjectName or @SubjectName is null)
and
(TSM.I_Status=@SubjectStatus or @SubjectStatus is null)
and 
(TSM.I_Class_ID=@ClassID or @ClassID is null)
and
(TSM.I_School_Group_ID=@SchoolGroupID or @SchoolGroupID is null)
and
(TEST.I_Subject_Template_ID=@SubjectTemplateID or @SubjectTemplateID is null)
and
(TEST.S_Structure_Name=@SubjectStructureName or @SubjectStructureName is null)



END
