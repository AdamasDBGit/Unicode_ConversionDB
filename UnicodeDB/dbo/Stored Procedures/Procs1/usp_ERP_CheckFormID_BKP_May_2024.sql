
-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <30th Jan 2024>
-- Description:	<to check form id>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_CheckFormID_BKP_May_2024]
	@FormID NVARCHAR(MAX) = null
	
AS
BEGIN
	SET NOCOUNT ON;
	 if exists (select 1 from [T_Enquiry_Regn_Detail] where S_Form_No = @FormID)
  BEGIN
	SELECT 0 StatusFlag,'Duplicate form number' Message
	END
	else
	BEGIN
	SELECT 1 StatusFlag,'Correct form number' Message
	END
END

