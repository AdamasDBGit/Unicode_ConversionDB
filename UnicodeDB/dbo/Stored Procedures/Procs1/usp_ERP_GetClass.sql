
-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <14th September 2023>
-- Description:	<to get the class>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetClass]
	@iClassID int = null,
	@iBrandID int
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select TC.I_Class_ID as ClassID,
		TC.S_Class_Code as ClassCode,
		TC.S_Class_Name as ClassName,
		TC.I_Status as ClassStatus
		from [dbo].[T_Class] as TC
		where TC.I_Class_ID= ISNULL(@iClassID,TC.I_Class_ID)
		and I_Brand_ID = @iBrandID
		ORDER BY 
    TC.I_Class_ID ASC;
	END
