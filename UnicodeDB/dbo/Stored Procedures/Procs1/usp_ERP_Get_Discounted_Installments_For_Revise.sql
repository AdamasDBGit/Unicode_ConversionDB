CREATE PROCEDURE [dbo].[usp_ERP_Get_Discounted_Installments_For_Revise]
	-- Add the parameters for the stored procedure here
	@iDiscountSchemeID int,
	@iBrandID int,
	@iERPFeeStructure int,
	@InstallmentComponentDetails UT_Installments_Component_Details_For_Discount readonly,
	@InstallmentTaxComponentDetails UT_Installments_Tax_Component_Details_For_Discount readonly
	
	--@InstallmentComponentDetails UT_Installments_Component_Details  readonly
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here




	DECLARE @SGST_Tax_ID int,@CGST_Tax_ID int,@IGST_Tax_ID int            
set @SGST_Tax_ID = (select top 1 I_Tax_ID  from T_Tax_Master where S_Tax_Code='SGST')            
set @CGST_Tax_ID = (select top 1 I_Tax_ID  from T_Tax_Master where S_Tax_Code='CGST')            
set @IGST_Tax_ID = (select top 1 I_Tax_ID  from T_Tax_Master where S_Tax_Code='IGST') 
	
	Create table #EligibleComponentDetails
	(
	ID int IDENTITY(1,1),
	FeeComponentID int,
	InstallmentNo int,
	DtInstallmentDate datetime,
	ActualBaseAmount decimal(8,2),
	ActualSGST decimal(8,2),
	ActualCGST decimal(8,2),
	ActualIGST decimal(8,2),
	DiscountedBaseAmount decimal(8,2),
	DiscountedSGST decimal(8,2),
	DiscountedCGST decimal(8,2),
	DiscountedIGST decimal(8,2),
	DiscountedRate int,
	DiscountedAmount int
	)

	Create table #DiscountDetails
	(
	ID INT IDENTITY(1,1),
	FeeComponentID int,
	IsfromStart bit,
	IsfromEnd bit,
	NoInstallment int,
	Rate int,
	Amount int
	)

	Create table #DiscountInstallmentSchedule
	(
	ID INT IDENTITY(1,1),
	FeeComponentID int,
	InstallmentNo int,
	Rate int,
	Amount int	
	)


	INSERT INTO #DiscountDetails
SELECT 
	DSD.I_FeeComponentID AS FeeComponentID,
	CASE WHEN DSD.I_FromInstalment = 0 THEN 1 ELSE 0 END AS IsfromStart,
	CASE WHEN DSD.I_FromInstalment = -1 THEN 1 ELSE 0 END AS IsfromEnd,
	DSD.I_NoofInstallments,
	DSD.N_Discount_Rate,
	DSD.N_Discount_Amount
FROM T_Discount_Scheme_Master AS DSM
--INNER JOIN T_Discount_Brand_Map AS DBM 
--	ON DSM.I_Discount_Scheme_ID = DBM.I_Discount_Scheme_ID
INNER JOIN T_ERP_Discount_Scheme_Details AS DSD 
	ON DSM.I_Discount_Scheme_ID = DSD.I_Discount_Scheme_ID
--CROSS APPLY dbo.fn_Split_comma_String(DSD.S_FeeComponents, ',') AS FeeComp
WHERE 
	DSM.I_Discount_Scheme_ID = @iDiscountSchemeID
	AND DSM.I_Brand_ID = @iBrandID
	AND DSD.I_Status_ID = 1 
	AND DSM.I_Status = 1;



	
--	select * from #DiscountDetails
	
	insert into #EligibleComponentDetails
	SELECT Distinct
    ICD.I_Component_ID,
    ICD.I_InstallmentNo,
    ICD.Dt_Installment_Date,
    ICD.BaseAmount,

    -- CGST
    ISNULL((
        SELECT TaxAmount 
        FROM @InstallmentTaxComponentDetails AS T 
        WHERE 
            T.I_Component_ID = ICD.I_Component_ID AND
            T.I_InstallmentNo = ICD.I_InstallmentNo AND
            T.Dt_Installment_Date = ICD.Dt_Installment_Date AND
            T.TaxID = @CGST_Tax_ID
    ), 0) AS CGST_Amount,

    -- SGST
    ISNULL((
        SELECT TaxAmount 
        FROM @InstallmentTaxComponentDetails AS T 
        WHERE 
            T.I_Component_ID = ICD.I_Component_ID AND
            T.I_InstallmentNo = ICD.I_InstallmentNo AND
            T.Dt_Installment_Date = ICD.Dt_Installment_Date AND
            T.TaxID = @SGST_Tax_ID
    ), 0) AS SGST_Amount,

    -- IGST
    ISNULL((
        SELECT TaxAmount 
        FROM @InstallmentTaxComponentDetails AS T 
        WHERE 
            T.I_Component_ID = ICD.I_Component_ID AND
            T.I_InstallmentNo = ICD.I_InstallmentNo AND
            T.Dt_Installment_Date = ICD.Dt_Installment_Date AND
            T.TaxID = @IGST_Tax_ID
    ), 0) AS IGST_Amount,

    NULL AS Col1,
    NULL AS Col2,
    NULL AS Col3,
    NULL AS Col4,
    NULL AS Col5,
    NULL AS Col6

FROM @InstallmentComponentDetails AS ICD
INNER JOIN #DiscountDetails AS DD 
    ON ICD.I_Component_ID = DD.FeeComponentID
	--select distinct ICD.I_Component_ID,ICD.I_InstallmentNo,ICD.Dt_Installment_Date,ICD.BaseAmount,
	--CASE when ISNULL(ICDtax.TaxID,0)=@CGST_Tax_ID then ICDtax.TaxAmount else 0 end,
	--CASE when ISNULL(ICDtax.TaxID,0)=@SGST_Tax_ID then ICDtax.TaxAmount else 0 end,
	--CASE when ISNULL(ICDtax.TaxID,0)=@IGST_Tax_ID then ICDtax.TaxAmount else 0 end,
	--NULL,NULL,NULL,NULL,NULL,NULL
	--from
	--@InstallmentComponentDetails as ICD
	--inner join
	--#DiscountDetails as DD on ICD.I_Component_ID=DD.FeeComponentID
	--left join
	--@InstallmentTaxComponentDetails as ICDtax on ICDtax.I_Component_ID=DD.FeeComponentID
	--and ICD.I_InstallmentNo=ICDTax.I_InstallmentNo and ICD.Dt_Installment_Date=ICDTax.Dt_Installment_Date

	--select * from #EligibleComponentDetails


	declare @maxID int =0,@ID int =1;

	set @maxID = (select max(ID) from #DiscountDetails)

	declare @ComponentID int=0;
	declare @noOfInstallment int=0;
	declare @DiscountRate int=null;
	declare @DiscountAmount int=null;
	DECLARE @EligibleCount int=0;
	

	while(@ID <= @maxID )
	begin

		set @ComponentID = (select FeeComponentID from #DiscountDetails where ID=@ID)
		set @noOfInstallment = (select NoInstallment from #DiscountDetails where ID=@ID)
		set @DiscountRate= (select Rate from #DiscountDetails where ID=@ID)
		set @DiscountAmount= (select Amount from #DiscountDetails where ID=@ID)
	   

		--select *  from #DiscountDetails where ID=@ID

	  -- select @DiscountRate

		if ((select ISNULL(IsfromEnd,0) from #DiscountDetails where ID=@ID) = 0)
		AND ((select ISNULL(IsfromStart,0) from #DiscountDetails where ID=@ID) = 0)
		BEGIN

			if exists (
			select * from #EligibleComponentDetails where FeeComponentID=@ComponentID and InstallmentNo=@noOfInstallment)
			BEGIN

				if exists (
					select * from #EligibleComponentDetails where FeeComponentID=@ComponentID and InstallmentNo=@noOfInstallment and DiscountedBaseAmount IS NULL)
						BEGIN

						insert into #DiscountInstallmentSchedule
						select 
						FeeComponentID,
						InstallmentNo,
						@DiscountRate,
						@DiscountAmount
						from #EligibleComponentDetails where FeeComponentID=@ComponentID and InstallmentNo=@noOfInstallment and DiscountedBaseAmount IS NULL 
						

						IF ISNULL(@DiscountRate,0) > 0
						begin
							update  #EligibleComponentDetails set DiscountedBaseAmount = (-1)*(ActualBaseAmount * (@DiscountRate / 100.0))
							,DiscountedCGST = (-1)*(ActualCGST * (@DiscountRate / 100.0))
							,DiscountedSGST = (-1)*(ActualSGST * (@DiscountRate / 100.0))
							,DiscountedIGST = (-1)*(ActualIGST * (@DiscountRate / 100.0))
							,DiscountedRate=@DiscountRate
							,DiscountedAmount=@DiscountAmount
							where FeeComponentID=@ComponentID and InstallmentNo=@noOfInstallment and DiscountedBaseAmount IS NULL 
						end 


					END

						ELSE

						BEGIN
							RAISERROR('Invalid Discount For this Fee Structure:Double Discount For Single Component Not Valid', 16, 1)
							RETURN

							--select 0 as flag , 'Discount already provided' as msg

						END
			END
			else 
			BEGIN
					
					RAISERROR('Invalid Discount For this Fee Structure :%d Installment not exists for %d Component ', 16, 1,@noOfInstallment,@ComponentID)
					RETURN

			END


		END

		if ((select ISNULL(IsfromStart,0) from #DiscountDetails where ID=@ID) = 1)
		BEGIN
					;WITH OrderedInstallments AS (
					SELECT TOP (@noOfInstallment) *
					FROM #EligibleComponentDetails
					WHERE FeeComponentID = @ComponentID
					ORDER BY InstallmentNo
				)

				
				-- Step 2: Count eligible installments
				SELECT @EligibleCount = COUNT(*) FROM OrderedInstallments

				-- Step 3: Error if not enough installments exist
				IF (@EligibleCount < @noOfInstallment)
				BEGIN
					RAISERROR('Only %d eligible installments found for component %d. Required: %d.', 16, 1, @EligibleCount, @ComponentID, @noOfInstallment)
					RETURN
				END
				
				

				-- Step 4: Check if any in the range already have a discount applied
				IF EXISTS (
					SELECT 1 
					FROM (
						SELECT TOP (@noOfInstallment) *
						FROM #EligibleComponentDetails
						WHERE FeeComponentID = @ComponentID
						ORDER BY InstallmentNo
					) AS CheckRange
					WHERE DiscountedBaseAmount IS NOT NULL
				)
				BEGIN
					RAISERROR('Discount already applied in eligible range for component %d.', 16, 1, @ComponentID)
					RETURN
				END
				-- Step 5: Insert the eligible installments into DiscountInstallmentSchedule
					INSERT INTO #DiscountInstallmentSchedule (FeeComponentID, InstallmentNo, Rate, Amount)
					SELECT 
						FeeComponentID,
						InstallmentNo,
						@DiscountRate,
						@DiscountAmount
					FROM (
						SELECT TOP (@noOfInstallment) *
						FROM #EligibleComponentDetails
						WHERE FeeComponentID = @ComponentID
						ORDER BY InstallmentNo
					) AS FinalRange

					IF ISNULL(@DiscountRate, 0) > 0
						BEGIN
							UPDATE E
							SET E.DiscountedBaseAmount =(-1)*(E.ActualBaseAmount * (@DiscountRate / 100.0))
							,E.DiscountedCGST = (-1)*(E.ActualCGST * (@DiscountRate / 100.0))
							,E.DiscountedSGST = (-1)*(E.ActualSGST * (@DiscountRate / 100.0))
							,E.DiscountedIGST = (-1)*(E.ActualIGST * (@DiscountRate / 100.0))
							,E.DiscountedRate=@DiscountRate
							,E.DiscountedAmount=@DiscountAmount
							FROM #EligibleComponentDetails E
							INNER JOIN #DiscountInstallmentSchedule DIS
								ON E.FeeComponentID = DIS.FeeComponentID
								AND E.InstallmentNo = DIS.InstallmentNo
							WHERE E.DiscountedBaseAmount IS NULL
						END



		END


		if ((select ISNULL(IsfromEnd,0) from #DiscountDetails where ID=@ID) = 1)
		BEGIN
					;WITH OrderedInstallments AS (
					SELECT TOP (@noOfInstallment) *
					FROM #EligibleComponentDetails
					WHERE FeeComponentID = @ComponentID
					ORDER BY InstallmentNo desc
				)

				
				-- Step 2: Count eligible installments
				SELECT @EligibleCount = COUNT(*) FROM OrderedInstallments

				-- Step 3: Error if not enough installments exist
				IF (@EligibleCount < @noOfInstallment)
				BEGIN
					RAISERROR('Only %d eligible installments found for component %d. Required: %d.', 16, 1, @EligibleCount, @ComponentID, @noOfInstallment)
					RETURN
				END
				
				

				-- Step 4: Check if any in the range already have a discount applied
				IF EXISTS (
					SELECT 1 
					FROM (
						SELECT TOP (@noOfInstallment) *
						FROM #EligibleComponentDetails
						WHERE FeeComponentID = @ComponentID
						ORDER BY InstallmentNo desc
					) AS CheckRange
					WHERE DiscountedBaseAmount IS NOT NULL
				)
				BEGIN
					RAISERROR('Discount already applied in eligible range for component %d.', 16, 1, @ComponentID)
					RETURN
				END
				-- Step 5: Insert the eligible installments into DiscountInstallmentSchedule
					INSERT INTO #DiscountInstallmentSchedule (FeeComponentID, InstallmentNo, Rate, Amount)
					SELECT 
						FeeComponentID,
						InstallmentNo,
						@DiscountRate,
						@DiscountAmount
					FROM (
						SELECT TOP (@noOfInstallment) *
						FROM #EligibleComponentDetails
						WHERE FeeComponentID = @ComponentID
						ORDER BY InstallmentNo desc
					) AS FinalRange

					IF ISNULL(@DiscountRate, 0) > 0
						BEGIN
							UPDATE E
							SET E.DiscountedBaseAmount = (-1)* (E.ActualBaseAmount * (@DiscountRate / 100.0))
							,E.DiscountedCGST = (-1)*(E.ActualCGST * (@DiscountRate / 100.0))
							,E.DiscountedSGST = (-1)*(E.ActualSGST * (@DiscountRate / 100.0))
							,E.DiscountedIGST = (-1)* (E.ActualIGST * (@DiscountRate / 100.0))
							,E.DiscountedRate=@DiscountRate
							,E.DiscountedAmount=@DiscountAmount
							FROM #EligibleComponentDetails E
							INNER JOIN #DiscountInstallmentSchedule DIS
								ON E.FeeComponentID = DIS.FeeComponentID
								AND E.InstallmentNo = DIS.InstallmentNo
							WHERE E.DiscountedBaseAmount IS NULL
						END



		END














		--select * from #EligibleComponentDetails

		set @ID=@ID+1


	end





	--select * from #DiscountInstallmentSchedule

	select distinct *,@SGST_Tax_ID as SGSTTaxID,@CGST_Tax_ID as CGSTTaxID,@IGST_Tax_ID as IGSTTaxID,CM.S_Component_Name
	from #EligibleComponentDetails as ECD
	inner join
	T_Fee_Component_Master as CM on ECD.FeeComponentID=CM.I_Fee_Component_ID


	select distinct CM.I_Fee_Component_ID,S_Component_Name from 
	@InstallmentComponentDetails as ECD
	inner join
	T_Fee_Component_Master as CM on ECD.I_Component_ID=CM.I_Fee_Component_ID
	--select * from #DiscountDetails

	drop table #DiscountDetails
	drop table #EligibleComponentDetails




END