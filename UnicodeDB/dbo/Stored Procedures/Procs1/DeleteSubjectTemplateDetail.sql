-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <29th February, 2024>
-- Description:	<to delete the template >
-- =============================================
CREATE PROCEDURE [dbo].[DeleteSubjectTemplateDetail]
	-- Add the parameters for the stored procedure here
	@structureid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @ParentID INT = @structureid;

WITH AllChild_Subject AS (
    SELECT I_Subject_Structure_ID, I_Parent_Subject_Structure_ID
    FROM T_ERP_Subject_Structure
    WHERE I_Subject_Structure_ID = @ParentID
 
    UNION ALL
 
    SELECT t.I_Subject_Structure_ID, t.I_Parent_Subject_Structure_ID
    FROM T_ERP_Subject_Structure t
    INNER JOIN AllChild_Subject r ON t.I_Parent_Subject_Structure_ID = r.I_Subject_Structure_ID
)
UPDATE [T_ERP_Subject_Structure]
SET  I_Status= 0 
FROM T_ERP_Subject_Structure
JOIN AllChild_Subject ON T_ERP_Subject_Structure.I_Subject_Structure_ID = AllChild_Subject.I_Subject_Structure_ID;


SELECT 1 StatusFlag,'Structure Deleted' Message
END
