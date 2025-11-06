-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- exec [usp_ERP_GetAllClassWokByStudentID] 6101,3,'2024-04-16'
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetSourceNameBySourceID] 
(
	-- Add the parameters for the stored procedure here
	@EnqTypeSourceMappingID INT 
)
AS
BEGIN
	BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select 
	I_Source_DetailsID
	,S_Name
	from T_ERP_CRMSource_Details
	where I_EnqType_Source_Mapping_ID = @EnqTypeSourceMappingID and Is_Active = 1

	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

		SELECT	@ErrMsg = ERROR_MESSAGE(),
				@ErrSeverity = ERROR_SEVERITY()
		select 0 StatusFlag,@ErrMsg Message
	END CATCH
END
