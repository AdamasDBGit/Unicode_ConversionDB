CREATE PROCEDURE [ECOMMERCE].[uspResetDataForCustomerForTesting](@CustomerID VARCHAR(MAX))
AS
BEGIN

	DECLARE @RegID INT=0

	select @RegID=RegID from ECOMMERCE.T_Registration where CustomerID COLLATE DATABASE_DEFAULT=@CustomerID COLLATE DATABASE_DEFAULT and StatusID=1


	update T_Enquiry_Regn_Detail set S_Mobile_No='1234567890' where I_Enquiry_Regn_ID in
	(
		select EnquiryID from ECOMMERCE.T_Registration_Enquiry_Map where RegID=@RegID
	)

	delete from ECOMMERCE.T_Registration_Courses where RegID=@RegID
	delete from ECOMMERCE.T_Registration_Enquiry_Map where RegID=@RegID
	update ECOMMERCE.T_Transaction_Master set StatusID=0 where CustomerID=@CustomerID
	delete from ECOMMERCE.T_Coupon_Master where CustomerID=@CustomerID
	delete from ECOMMERCE.T_Registration where RegID=@RegID



END
