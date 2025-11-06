CREATE PROCEDURE [ECOMMERCE].[uspGetExistingEnrollmentsForCustomerID]
(
	@CustomerID VARCHAR(MAX)
)
AS
BEGIN

	DECLARE @CourseList VARCHAR(MAX)=''
	DECLARE @i INT=1
	DECLARE @c INT=0

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

	DECLARE @CourseEnrolment TABLE
	(
		CustomerID VARCHAR(MAX),
		CourseID INT,
		CanBePurchased INT
	)


	--select @CourseList as CourseList

	insert into @Inv
	select DISTINCT D.I_Invoice_Header_ID
	from ECOMMERCE.T_Registration A
	inner join ECOMMERCE.T_Registration_Enquiry_Map B on A.RegID=B.RegID
	inner join T_Student_Detail C on B.EnquiryID=C.I_Enquiry_Regn_ID
	inner join T_Invoice_Parent D on C.I_Student_Detail_ID=D.I_Student_Detail_ID
	where
	A.CustomerID COLLATE DATABASE_DEFAULT=@CustomerID COLLATE DATABASE_DEFAULT and A.StatusID=1 and D.I_Status in (1,3)


	select @c=COUNT(*) from @Inv
	

	PRINT 'START'

	--select * from @Inv

	WHILE(@i<=@c)
	BEGIN
		
		DECLARE @InvID INT
		DECLARE @CourseID INT
		DECLARE @DueAmt DECIMAL(14,2)=0

		select @InvID=InvHeaderID from @Inv where ID=@i

		--insert into @InvDues
		--EXEC [dbo].[uspServiceTaxCalculate] @InvID



		select @DueAmt= ISNULL(A.N_Invoice_Amount,0)+ISNULL(A.N_Tax_Amount,0)-RH.RAmt 
		from T_Invoice_Parent A
		left join
		(
			select I_Invoice_Header_ID,SUM(ISNULL(N_Receipt_Amount,0)+ISNULL(N_Tax_Amount,0)) as RAmt
			from T_Receipt_Header 
			where I_Invoice_Header_ID=@InvID and I_Status=1
			group by I_Invoice_Header_ID
		) RH on A.I_Invoice_Header_ID=RH.I_Invoice_Header_ID
		where
		A.I_Invoice_Header_ID=@InvID

		--select * from @InvDues

		--IF((select SUM(TotalAmntDue+TotalDueAmntTillDate) from @InvDues)>0)
		IF(@DueAmt>0)
		BEGIN

			select TOP 1 @CourseID=B.I_Course_ID 
			from 
			T_Invoice_Parent A
			inner join T_Invoice_Child_Header B on A.I_Invoice_Header_ID=B.I_Invoice_Header_ID
			where
			A.I_Invoice_Header_ID=@InvID

			insert into @CourseEnrolment
			(
				CustomerID,
				CourseID,
				CanBePurchased
			)
			values
			(
				@CustomerID,
				@CourseID,
				0
			)

			--SET @CourseList=@CourseList+CAST(@CourseID AS VARCHAR(MAX))+','

		END
		ELSE
		BEGIN

			select TOP 1 @CourseID=B.I_Course_ID 
			from 
			T_Invoice_Parent A
			inner join T_Invoice_Child_Header B on A.I_Invoice_Header_ID=B.I_Invoice_Header_ID
			where
			A.I_Invoice_Header_ID=@InvID

			insert into @CourseEnrolment
			(
				CustomerID,
				CourseID,
				CanBePurchased
			)
			values
			(
				@CustomerID,
				@CourseID,
				1
			)

		END

		DELETE FROM @InvDues

		SET @i=@i+1

	END

	--select @CourseList

	--IF(@CourseList IS NOT NULL and @CourseList!='')
	--BEGIN

	--	select DISTINCT A.RegID,A.CustomerID,LEFT(@CourseList,LEN(@CourseList)-1) as CourseList 
	--	from ECOMMERCE.T_Registration A
	--	where
	--	A.CustomerID=@CustomerID and A.StatusID=1

	--END
	--ELSE
	--BEGIN

	--	select DISTINCT A.RegID,A.CustomerID,'' as CourseList 
	--	from ECOMMERCE.T_Registration A
	--	where
	--	A.CustomerID=@CustomerID and A.StatusID=1

	--END
	PRINT 'END'

	select DISTINCT A.RegID,A.CustomerID,B.CourseID,B.CanBePurchased
	from ECOMMERCE.T_Registration A
	left join @CourseEnrolment B on A.CustomerID=B.CustomerID
	where
	A.CustomerID=@CustomerID and A.StatusID=1



END
