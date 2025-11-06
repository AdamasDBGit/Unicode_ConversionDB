-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_UpdateBulkUploadEvents]
	-- Add the parameters for the stored procedure here
	(
		@Is_Through_Bulk_upload INT,
		@I_Brand_ID INT,
		@UpdateBulkData UT_UpdateBulkUploadEvents readonly
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE T_Event
    SET I_Status = u.I_Status
    FROM T_Event
    INNER JOIN @UpdateBulkData AS u ON T_Event.I_Event_ID = u.I_Event_ID
    WHERE T_Event.Is_Through_Bulk_upload = @Is_Through_Bulk_upload
        AND T_Event.I_Brand_ID = @I_Brand_ID;

	IF @@ROWCOUNT > 0
	BEGIN 
		SELECT 1 AS StatusFlag, 'Events Successfully Updated' AS Message
	END
	ELSE
	BEGIN
		SELECT 0 AS StatusFlag, 'Failed to Update Events !' AS Message
	END
END
