-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <30th Jan 2024>
-- Description:	<to check form id>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_CheckFormID]
	@FormID varchar(20) = null,
	@iBrandID INT=NULL
	
AS
BEGIN
	SET NOCOUNT ON;
	 if exists (select 1 from [T_Enquiry_Regn_Detail] ERD 
	 inner join T_Brand_Center_Details as BCD on ERD.I_Centre_Id=BCD.I_Centre_Id
	 where ERD.S_Form_No = @FormID and BCD.I_Brand_ID=ISNULL(@iBrandID,BCD.I_Brand_ID) and BCD.I_Status=1)
  BEGIN
	SELECT 0 StatusFlag,'Duplicate form number' Message
	END
	else
	BEGIN
	SELECT 1 StatusFlag,'Correct form number' Message
	END
END
