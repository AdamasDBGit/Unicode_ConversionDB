-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetAllDocumentType]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	[I_Document_Type_ID] DocumentTypeID, 
	[S_Document_Type_Name] DocumentTypeName,
	Is_Mandatory IsMandatory
	FROM [T_ERP_Document_Type_Master]
END
