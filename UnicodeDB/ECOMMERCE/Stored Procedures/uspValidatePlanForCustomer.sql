CREATE PROCEDURE [ECOMMERCE].[uspValidatePlanForCustomer]
(
	@CustomerID VARCHAR(MAX),
	@PlanID INT,
	@CourseIDList VARCHAR(MAX) OUTPUT 
)
AS
BEGIN

	DECLARE @CourseList VARCHAR(MAX)=''
	DECLARE @i INT=1
	DECLARE @c INT=0
	DECLARE @flag BIT=1

	DECLARE @Inv TABLE
	(
		ID INT IDENTITY(1,1),
		InvHeaderID INT
	)

	DECLARE @InvDues TABLE
	(
		TotalDueAmntTillDate DECIMAL(14,2),
		TotalAmntDue DECIMAL(14,2)
	)




	insert into @Inv
	select DISTINCT D.I_Invoice_Header_ID
	from ECOMMERCE.T_Registration A
	inner join ECOMMERCE.T_Registration_Enquiry_Map B on A.RegID=B.RegID
	inner join T_Student_Detail C on B.EnquiryID=C.I_Enquiry_Regn_ID
	inner join T_Invoice_Parent D on C.I_Student_Detail_ID=D.I_Student_Detail_ID
	where
	A.CustomerID COLLATE DATABASE_DEFAULT=@CustomerID COLLATE DATABASE_DEFAULT and A.StatusID=1 and D.I_Status in (1,3)


	select @c=COUNT(*) from @Inv

	WHILE(@i<=@c)
	BEGIN
		
		DECLARE @InvID INT
		DECLARE @CourseID INT
		DECLARE @ProductID INT

		select @InvID=InvHeaderID from @Inv where ID=@i

		insert into @InvDues
		EXEC [dbo].[uspServiceTaxCalculate] @InvID

		IF((select SUM(TotalAmntDue+TotalDueAmntTillDate) from @InvDues)>0)
		BEGIN

			select TOP 1 @CourseID=B.I_Course_ID 
			from 
			T_Invoice_Parent A
			inner join T_Invoice_Child_Header B on A.I_Invoice_Header_ID=B.I_Invoice_Header_ID
			where
			A.I_Invoice_Header_ID=@InvID

			IF EXISTS
			(
				select * from ECOMMERCE.T_Plan_Product_Map A
				inner join T_Product_Master B on A.ProductID=B.ProductID
				where
				A.StatusID=1 and B.CourseID=@CourseID
			)
			BEGIN

				SET @flag=0

				select @ProductID=B.ProductID from ECOMMERCE.T_Plan_Product_Map A
				inner join T_Product_Master B on A.ProductID=B.ProductID
				where
				A.StatusID=1 and B.CourseID=@CourseID


				SET @CourseList=@CourseList+CAST(@ProductID as VARCHAR(MAX))+','

			END

		END

		DELETE FROM @InvDues

		SET @i=@i+1

	END

	if(@flag=0)
		select @CourseIDList=LEFT(@CourseList,Len(@CourseList)-1)
	else
		set @CourseIDList=''



END
