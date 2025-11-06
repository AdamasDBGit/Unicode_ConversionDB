-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- exec usp_ERP_GetAllSubjectComponentsByBrandID 107, null
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetAllSubjectComponentsByBrandID]
(
	@iBrandID int = null,
	@iSubjectID int = null
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	TESC.I_Subject_Component_ID, 
	TESC.S_Subject_Component_Name,
	CASE 
        WHEN TESCM.Is_Active = 1 THEN 1
        ELSE 0
    END AS IsSelected,
	TESCM.I_Subject_Component_Mapping
	FROM
	T_ERP_Subject_Component AS TESC
	LEFT JOIN T_ERP_Subject_Component_Mapping AS TESCM
	ON TESC.I_Subject_Component_ID = TESCM.I_Subject_Component_ID
	AND TESCM.I_Subject_ID = @iSubjectID AND TESCM.Is_Active = 1
	WHERE (TESC.I_Brand_ID = @iBrandID OR @iBrandID IS NULL)
END
