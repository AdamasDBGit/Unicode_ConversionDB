-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023June10>
-- Description:	<This function will be use to validate the student's brand id to validate for buzz app>
-- =============================================
CREATE FUNCTION [dbo].[fnValidateBrandofStudentForBuzzAppParentLogin] 
(
	@StudentDetailID INT,
	@EnquiryID INT
)
RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @BrandID INT=0

	if (@EnquiryID = (select I_Enquiry_Regn_ID from T_Student_Detail where I_Student_Detail_ID in (@StudentDetailID) and I_Status=1))
	BEGIN

		select @BrandID=ISNULL(BM.I_Brand_ID,0) from T_Student_Detail as SD
		inner join
		T_Enquiry_Regn_Detail as ERD on SD.I_Enquiry_Regn_ID=SD.I_Enquiry_Regn_ID and ERD.I_Enquiry_Status_Code=3
		inner join
		T_Student_Center_Detail as SC on SD.I_Student_Detail_ID=SC.I_Student_Detail_ID and SC.I_Status=1
		inner join
		T_Brand_Center_Details as BCD on BCD.I_Centre_Id=SC.I_Centre_Id
		inner join
		T_Brand_Master as BM on BM.I_Brand_ID=BCD.I_Brand_ID
		where 
		ERD.I_Enquiry_Regn_ID = @EnquiryID and SD.I_Student_Detail_ID=@StudentDetailID
		and BM.I_Brand_ID in (107)

	
	END
	return @BrandID

END