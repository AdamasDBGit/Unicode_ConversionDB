-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- exec usp_ERP_GetAllAdmissionStageByBrandID null
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetAllAdmissionStageByBrandID]
(
	@iBrandID int = null
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	I_Admission_Stage_ID,
	S_Admission_Current_Stage,
	S_Admission_Current_Stage_Desc,
	S_Admission_Next_Stage,
	S_Admission_Next_Stage_Desc
	FROM [dbo].[T_ERP_Admission_Stage_Master]
	where (I_Brand_ID = @iBrandID OR @iBrandID IS NULL);
END
