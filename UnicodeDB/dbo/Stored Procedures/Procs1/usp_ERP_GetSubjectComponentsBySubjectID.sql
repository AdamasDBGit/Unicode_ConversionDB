-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- exec usp_ERP_GetSubjectComponentsBySubjectID 2
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetSubjectComponentsBySubjectID]
(
	@SubjectID int = null
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	TESCM.I_Subject_Component_ID,
	TESC.S_Subject_Component_Name
	FROM T_ERP_Subject_Component_Mapping TESCM 
	INNER JOIN T_ERP_Subject_Component TESC 
	ON TESCM.I_Subject_Component_ID = TESC.I_Subject_Component_ID and TESCM.Is_Active = 1
	WHERE TESCM.I_Subject_ID = @SubjectID
END
