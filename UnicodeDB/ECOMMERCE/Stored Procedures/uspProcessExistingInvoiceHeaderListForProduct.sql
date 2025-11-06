CREATE PROCEDURE [ECOMMERCE].[uspProcessExistingInvoiceHeaderListForProduct]
(
	@CustomerID VARCHAR(MAX),
	@ProductID INT
)
AS
BEGIN

	DECLARE @CourseID INT
	DECLARE @i INT=1
	DECLARE @c INT=0

	DECLARE @Inv TABLE
	(
		ID INT IDENTITY(1,1),
		InvHeaderID INT
	)

	select @CourseID=CourseID from ECOMMERCE.T_Product_Master where ProductID=@ProductID

	insert into @Inv
	select DISTINCT D.I_Invoice_Header_ID
	from ECOMMERCE.T_Registration A
	inner join ECOMMERCE.T_Registration_Enquiry_Map B on A.RegID=B.RegID
	inner join T_Student_Detail C on B.EnquiryID=C.I_Enquiry_Regn_ID
	inner join T_Invoice_Parent D on C.I_Student_Detail_ID=D.I_Student_Detail_ID
	inner join T_Invoice_Child_Header E on D.I_Invoice_Header_ID=E.I_Invoice_Header_ID
	where
	A.CustomerID COLLATE DATABASE_DEFAULT=@CustomerID COLLATE DATABASE_DEFAULT and A.StatusID=1 and D.I_Status in (1,3)
	and E.I_Course_ID=@CourseID

	select @c=COUNT(*) from @Inv

	WHILE(@i<=@c)
	BEGIN

		DECLARE @InvHeaderID INT

		select @InvHeaderID=InvHeaderID from @Inv where ID=@i

		EXEC [ECOMMERCE].[uspNullifyExistingDues] @InvHeaderID


		SET @i=@i+1

	END


END
