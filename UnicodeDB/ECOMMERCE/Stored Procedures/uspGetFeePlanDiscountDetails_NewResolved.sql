
CREATE PROCEDURE [ECOMMERCE].[uspGetFeePlanDiscountDetails_NewResolved]
(
@feeplanid int,
@paymentmode int,
@discountschemeid int,
@batchstartdate datetime=NULL
)
AS
BEGIN

	declare @discountperc decimal(14,2)=0
	declare @discountamount decimal(14,2)=0
	declare @sfromInstalment varchar(2)
	declare @ifromInstalment int=0
	declare @dincrement INT=1
	declare @dcount INT=0
	declare @i int=0
	declare @c int=0
	declare @instalmentstartdate Datetime

	IF(@batchstartdate IS NULL)
		set @batchstartdate=GETDATE()

	if(@batchstartdate>=CONVERT(DATE,GETDATE()))
		set @instalmentstartdate=@batchstartdate
	else
		set @instalmentstartdate=CONVERT(DATE,GETDATE())


	DECLARE @TblFeePlan TABLE
		(
			ID INT IDENTITY(1,1),
			I_Course_Fee_Plan_Detail_ID INT ,
			I_Fee_Component_ID INT,
			I_Course_Fee_Plan_ID INT,
			I_Item_Value Decimal(14,2),
			N_Discount decimal(14,2),
			I_Installment_No INT,
			I_Sequence INT,
			C_Is_LumpSum varchar(1),
			I_Display_Fee_Component_ID INT,
			InstalmentDate Datetime,
			ActualInstalmentNo INT
		)

	DECLARE @TblFeePlanDtl TABLE
	(
	ID INT IDENTITY(1,1),
	DiscountDetailID INT,
	DiscountSchemeID INT,
	DiscountRate Decimal(14,2),
	DiscountAmount decimal(14,2),
	IsApplicableOn INT,
	sFormInstalment Varchar(2),
	sFeeComponent varchar(max)
	)

	DECLARE @TblFeePlanTaxDtl TABLE
	(
	I_Course_Fee_Plan_Detail_ID INT,
	TaxID INT,
	TaxAmount DECIMAL(14,2)
	)


	Insert into @TblFeePlan
	(
		I_Course_Fee_Plan_Detail_ID,
		I_Fee_Component_ID,
		I_Course_Fee_Plan_ID,
		I_Item_Value,
		N_Discount,
		I_Installment_No,
		I_Sequence,
		C_Is_LumpSum,
		I_Display_Fee_Component_ID
	)
	SELECT  I_Course_Fee_Plan_Detail_ID ,
			I_Fee_Component_ID ,
			I_Course_Fee_Plan_ID ,
			I_Item_Value ,
			ISNULL(N_CompanyShare, 0) AS N_CompanyShare ,
			I_Installment_No ,
			I_Sequence ,
			C_Is_LumpSum ,
			I_Display_Fee_Component_ID
	FROM    dbo.T_Course_Fee_Plan_Detail
	WHERE   I_Course_Fee_Plan_ID = @feeplanid
			AND I_Status = 1
	ORDER BY I_Installment_No,I_Sequence

	insert into @TblFeePlanDtl
	select * from T_Discount_Scheme_Details where I_Discount_Scheme_ID=@discountschemeid and I_IsApplicableOn=@paymentmode

	select @dcount=COUNT(*) from @TblFeePlanDtl

	select * from @TblFeePlanDtl

	while(@dincrement<=@dcount)
	begin

		declare @sFeeComponent varchar(max)=''

		declare @tblFeeComponent TABLE
		(
			FeeComponentID INT
		)

		select @discountperc=ISNULL(DiscountRate,0),@discountamount=ISNULL(DiscountAmount,0),@sfromInstalment=ISNULL(sFormInstalment,'F'),
				@sFeeComponent=ISNULL(sFeeComponent,'')
		from 
		@TblFeePlanDtl 
		where 
		DiscountSchemeID=@discountschemeid and IsApplicableOn=@paymentmode

		if(@sFeeComponent='')
		begin

			insert into @tblFeeComponent
			select Distinct I_Fee_Component_ID from @TblFeePlan
	
		end
		else
		begin

			insert into @tblFeeComponent
			select CAST(@sFeeComponent as INT)

		end




		IF(@sfromInstalment='F')
			select @ifromInstalment=MIN(I_Installment_No) from @TblFeePlan where C_Is_LumpSum='N'
		ELSE IF(@sfromInstalment='L')
			select @ifromInstalment=MAX(I_Installment_No) from @TblFeePlan where C_Is_LumpSum='N'
		ELSE
			set @ifromInstalment=cast(ISNULL(@sfromInstalment,'0') as INT)

		if(@sFeeComponent='')
		begin

			if(@paymentmode=1)
			begin

				if(@discountamount=0 and @discountperc>0)
				begin

				SELECT @discountamount= (N_TotalLumpSum*@discountperc)/100
					FROM    dbo.T_Course_Fee_Plan
					WHERE   I_Course_Fee_Plan_ID = @feeplanid
							AND I_Status = 1 

				end

				--select @discountamount

			end
			else if(@paymentmode=2)
			begin

				if(@discountamount=0 and @discountperc>0)
				begin

				SELECT @discountamount= (N_TotalInstallment*@discountperc)/100
					FROM    dbo.T_Course_Fee_Plan
					WHERE   I_Course_Fee_Plan_ID = @feeplanid
							AND I_Status = 1 

				end

				--select @discountamount

			end

		end
		else
		begin

			if(@paymentmode=1)
			begin

				if(@discountamount=0 and @discountperc>0)
				begin

				SELECT @discountamount= (SUM(I_Item_Value)*@discountperc)/100
					FROM    @TblFeePlan
					WHERE   I_Course_Fee_Plan_ID = @feeplanid
							and I_Fee_Component_ID in
								(
									select FeeComponentID from @tblFeeComponent
								)
							and C_Is_LumpSum='Y'

				end

				--select @discountamount

			end
			else if(@paymentmode=2)
			begin

				if(@discountamount=0 and @discountperc>0)
				begin

				SELECT @discountamount= (SUM(I_Item_Value)*@discountperc)/100
					FROM    @TblFeePlan
					WHERE   I_Course_Fee_Plan_ID = @feeplanid
							and I_Fee_Component_ID in
								(
									select FeeComponentID from @tblFeeComponent
								)
							and C_Is_LumpSum='N'

				end

				--select @discountamount

			end

		end

		if(@discountamount>0)
		begin

			declare @tempDiscount decimal(14,2)=@discountamount
	

			IF(@sfromInstalment='L')
			Begin

				select @c=1
				select @i=count(*) from @TblFeePlan

				while(@i>=@c)
				begin

					if(@paymentmode=1)
					begin

						update @TblFeePlan set N_Discount=CASE WHEN I_Item_Value=0 THEN 0
																WHEN I_Item_Value<=@tempDiscount and I_Item_Value>0 THEN I_Item_Value 
																ELSE @tempDiscount END
						where
						ID=@i and C_Is_LumpSum='Y' 
						and I_Fee_Component_ID in
						(
							select FeeComponentID from @tblFeeComponent
						)

						select @tempDiscount=@tempDiscount-ISNULL(CASE WHEN I_Item_Value=0 THEN 0
																WHEN I_Item_Value<=@tempDiscount and I_Item_Value>0 THEN I_Item_Value 
																ELSE @tempDiscount END,0)
						from @TblFeePlan 
						where
						ID=@i and C_Is_LumpSum='Y'
						and I_Fee_Component_ID in
						(
							select FeeComponentID from @tblFeeComponent
						)

					end
					else if(@paymentmode=2)
					begin

						update @TblFeePlan set N_Discount=CASE WHEN I_Item_Value=0 THEN 0
																WHEN I_Item_Value<=@tempDiscount and I_Item_Value>0 THEN I_Item_Value 
																ELSE @tempDiscount END
						where
						ID=@i and C_Is_LumpSum='N'
						and I_Fee_Component_ID in
						(
							select FeeComponentID from @tblFeeComponent
						)

						select @tempDiscount=@tempDiscount-ISNULL(CASE WHEN I_Item_Value=0 THEN 0
																WHEN I_Item_Value<=@tempDiscount and I_Item_Value>0 THEN I_Item_Value 
																ELSE @tempDiscount END,0)
						from @TblFeePlan 
						where
						ID=@i and C_Is_LumpSum='N'
						and I_Fee_Component_ID in
						(
							select FeeComponentID from @tblFeeComponent
						)

					end

					set @i=@i-1

				end

			end
			else
			Begin
		
				set @i=@ifromInstalment
				select @c=count(*) from @TblFeePlan
	
				while(@i<=@c)
				begin

					if(@paymentmode=1)
					begin

						update @TblFeePlan set N_Discount=CASE WHEN I_Item_Value=0 THEN 0
																WHEN I_Item_Value<=@tempDiscount and I_Item_Value>0 THEN I_Item_Value 
																ELSE @tempDiscount END
						where
						ID=@i and C_Is_LumpSum='Y'
						and I_Fee_Component_ID in
						(
							select FeeComponentID from @tblFeeComponent
						)

						select @tempDiscount=@tempDiscount-ISNULL(CASE WHEN I_Item_Value=0 THEN 0
																WHEN I_Item_Value<=@tempDiscount and I_Item_Value>0 THEN I_Item_Value 
																ELSE @tempDiscount END,0)
						from @TblFeePlan 
						where
						ID=@i and C_Is_LumpSum='Y'
						and I_Fee_Component_ID in
						(
							select FeeComponentID from @tblFeeComponent
						)

					end
					else if(@paymentmode=2)
					begin

						update @TblFeePlan set N_Discount=CASE WHEN I_Item_Value=0 THEN 0
																WHEN I_Item_Value<=@tempDiscount and I_Item_Value>0 THEN I_Item_Value 
																ELSE @tempDiscount END
						where
						ID=@i and C_Is_LumpSum='N'
						and I_Fee_Component_ID in
						(
							select FeeComponentID from @tblFeeComponent
						)

						select @tempDiscount=@tempDiscount-ISNULL(CASE WHEN I_Item_Value=0 THEN 0
																WHEN I_Item_Value<=@tempDiscount and I_Item_Value>0 THEN I_Item_Value 
																ELSE @tempDiscount END,0)
						from @TblFeePlan 
						where
						ID=@i and C_Is_LumpSum='N'
						and I_Fee_Component_ID in
						(
							select FeeComponentID from @tblFeeComponent
						)

					end

					set @i=@i+1

				end

			end

		

		end

		--drop table #tblFeeComponent

		set @dincrement=@dincrement+1

	end

	insert into @TblFeePlanTaxDtl
	select A.I_Course_Fee_Plan_Detail_ID,B.I_Tax_ID,((A.I_Item_Value-A.N_Discount)*B.N_Tax_Rate)/100 as TaxAmount 
	from @TblFeePlan A
	inner join T_Tax_Country_Fee_Component B on A.I_Fee_Component_ID=B.I_Fee_Component_ID
	where
	B.Dt_Valid_To>=GETDATE() and B.I_Status=1


	--update @TblFeePlan set InstalmentDate=CONVERT(DATE,GETDATE()) where I_Installment_No=0
	--update @TblFeePlan set InstalmentDate=CONVERT(DATE,@batchstartdate) where I_Installment_No=1
	--update @TblFeePlan set InstalmentDate=DATEADD(m,I_Installment_No-1,DATEADD(m,datediff(m,0,@batchstartdate),0)) where I_Installment_No>1

	--update @TblFeePlan set ActualInstalmentNo=CASE WHEN @instalmentstartdate>=InstalmentDate and I_Installment_No>0 THEN 1 ELSE I_Installment_No END

	--update @TblFeePlan set InstalmentDate=CONVERT(DATE,@instalmentstartdate) where ActualInstalmentNo=1

	DECLARE @dtDate DATETIME=CONVERT(DATE,GETDATE())
	SET @instalmentstartdate=@dtDate


	update @TblFeePlan set InstalmentDate=@dtDate where I_Installment_No=0
	update @TblFeePlan set InstalmentDate=@dtDate where I_Installment_No=1
	--update @TblFeePlan set InstalmentDate=DATEADD(m,I_Installment_No-1,DATEADD(m,datediff(m,0,@batchstartdate),0)) where I_Installment_No>1

	update @TblFeePlan set InstalmentDate=DATEADD(d,30*(I_Installment_No-1),@dtDate) where I_Installment_No>1

	update @TblFeePlan set ActualInstalmentNo=CASE WHEN @instalmentstartdate>=InstalmentDate and I_Installment_No=0 THEN 1 
												   WHEN @instalmentstartdate>=InstalmentDate and I_Installment_No>0 THEN 1 
												   ELSE I_Installment_No END

	update @TblFeePlan set InstalmentDate=CONVERT(DATE,@instalmentstartdate) where ActualInstalmentNo=1



	select * from @TblFeePlan
	--select * from @TblFeePlanTaxDtl where TaxAmount>0 order by I_Course_Fee_Plan_Detail_ID,TaxID

	

	--drop table #TblFeePlan
	--drop table #TblFeePlanDtl

END
