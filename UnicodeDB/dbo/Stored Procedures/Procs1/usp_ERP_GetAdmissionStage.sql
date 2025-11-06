--exec [usp_ERP_GetAdmissionStage] 107,'Enquiry'

CREATE PROCEDURE [dbo].[usp_ERP_GetAdmissionStage]
(
	@iBrandID int = null,
	@Module int=null
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ModuleName nvarchar(50)
	IF(@Module=1)
	BEGIN
	SET @ModuleName ='Enquiry'
	END
	ELSE
	BEGIN
	SET @ModuleName ='Admission'
	END
    -- Insert statements for procedure here
	SELECT 
	I_Admission_Stage_ID,
	S_Admission_Current_Stage_Desc
	FROM [dbo].[T_ERP_Admission_Stage_Master]
	where (I_Brand_ID = @iBrandID OR @iBrandID IS NULL)
	and ModuleName =ISNULL(@ModuleName,ModuleName) and IsColumnVisible=1
END