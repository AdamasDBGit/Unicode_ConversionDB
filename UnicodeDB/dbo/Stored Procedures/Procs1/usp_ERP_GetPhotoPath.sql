-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetPhotoPath]
(
	@iMode int = null,
	@iEnquiryRegnID int = null,
	@iRelationId int = null
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	IF @iMode = 1
	BEGIN
		SELECT S_Student_Photo AS PhotoPath FROM T_Enquiry_Regn_Detail WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID
	END
	ELSE IF @iMode = 2 
	BEGIN
		IF @iRelationId = 1
		BEGIN
			SELECT S_Father_Photo AS PhotoPath FROM T_Enquiry_Regn_Detail WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID
		END
		ELSE IF @iRelationId = 2
		BEGIN
			SELECT S_Mother_Photo AS PhotoPath FROM T_Enquiry_Regn_Detail WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID
		END
	END
END
