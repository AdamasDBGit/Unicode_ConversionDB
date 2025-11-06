-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <28th sept 2023,>
-- Description:	<to get subject by brand>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetSubjectByBrandID]
	-- Add the parameters for the stored procedure here
	@ibrandid int,
	@iSubjectid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 select distinct SM.I_Subject_ID as SubjectID,
  SM.S_Subject_Name as SubjectName,
  SM.S_Subject_Code as SubjectCode,
  ST.S_Subject_Type as SubjectType,
  SG.S_School_Group_Name as SchoolGroup,
  SM.I_Status as SubjectStatus,
  C.S_Class_Name as ClassName,
  STH.S_Title as TemplateTitle,
  SSH.I_Subject_Template_Header_ID as TemplateHeaderID,
  SSH.I_Subject_Structure_Header_ID as StructureHeaderID
  FROM [dbo].[T_Subject_Master] as SM 
  left join [dbo].[T_Subject_Type] as ST on SM.I_Subject_Type=ST.I_Subject_Type_ID
  left join [dbo].[T_School_Group] as SG on SM.I_School_Group_ID=SG.I_School_Group_ID
  left join  [dbo].[T_Class] as C on SM.I_Class_ID=C.I_Class_ID
  left join [dbo].[T_ERP_Subject_Structure_Header]as SSH on SM.I_Subject_ID = SSH.I_Subject_ID
  left join [dbo].[T_ERP_Subject_Template_Header] as STH on SSH.I_Subject_Template_Header_ID =STH.I_Subject_Template_Header_ID
  left join [dbo].[T_ERP_Subject_Template] as EST on EST.I_Subject_Template_Header_ID=SSH.I_Subject_Template_Header_ID
  where SM.I_Brand_ID= @ibrandid and
   SM.I_Subject_ID= ISNULL(@iSubjectid,SM.I_Subject_ID) and SM.I_Status=1
END
