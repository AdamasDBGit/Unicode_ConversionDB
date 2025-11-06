-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2024-Oct-15>
-- Description:	<Nullify Specific Installments>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_Nullify_Installments]
	-- Add the parameters for the stored procedure here
	@UserID INT, 
	@iBrandID INT,
	@InvoiceHeaderID INT,
	@Remarks NVARCHAR(MAX),
	@InvoiceDetails usp_ERP_Invoice_Details readonly

AS
BEGIN
	
	BEGIN TRY
    -- Start a transaction
    BEGIN TRANSACTION

	insert into Nullify_Installments_Details
	select TIP.I_Invoice_Header_ID,TIP.S_Invoice_No,ICD.I_Invoice_Detail_ID,SD.Dt_Crtd_On as FirstAdmissionDate,TIP.Dt_Invoice_Date
		,ICD.I_Fee_Component_ID,SD.I_Student_Detail_ID,SD.S_Student_ID,ICD.Dt_Installment_Date,ICD.N_Amount_Due,0 as currentAmount,TIP.N_Invoice_Amount,NULL
		,GETDATE() as CreatedOn,(select top 1 S_Username from T_ERP_User where I_User_ID=@UserID),NULL as Isdone,ICH.I_Invoice_Child_Header_ID,ISNULL(ICD.N_CGST,0)+ISNULL(ICD.N_IGST,0)+ISNULL(ICD.N_SGST,0)
		,@Remarks
		from T_Student_Detail as SD
		inner join
		T_Invoice_Parent as TIP on SD.I_Student_Detail_ID=TIP.I_Student_Detail_ID
		inner join
		T_Invoice_Child_Header as ICH on TIP.I_Invoice_Header_ID=ICH.I_Invoice_Header_ID
		inner join
		T_Invoice_Child_Detail as ICD on ICH.I_Invoice_Child_Header_ID=ICD.I_Invoice_Child_Header_ID
		inner join
		@InvoiceDetails as ID on ID.InvoiceDetailID=ICD.I_Invoice_Detail_ID


		--Step 2:
			
			--Update in the main table with current amount in the execution table "Nullify_Installments_Details"
			--with excluding the invoices / installment which was paid already
				update ICD set ICD.N_Amount_Due=NID.CurrentAmount
				from T_Invoice_Child_Detail as ICD
				inner join
				Nullify_Installments_Details as NID on ICD.I_Invoice_Detail_ID=NID.Invoice_Detail_ID
				inner join
				@InvoiceDetails as ID on ID.InvoiceDetailID=ICD.I_Invoice_Detail_ID
				left join
				(
				select RCD2.I_Invoice_Detail_ID,RCD2.I_Receipt_Comp_Detail_ID
				from T_Receipt_Header as RH inner join
				T_Receipt_Component_Detail as RCD2 on RH.I_Receipt_Header_ID=RCD2.I_Receipt_Detail_ID
				where RH.I_Status=1
				)RCD on ICD.I_Invoice_Detail_ID=RCD.I_Invoice_Detail_ID

				where RCD.I_Receipt_Comp_Detail_ID IS  NULL and NID.Isdone IS NULL


		--Step 3:

			-- update the execution table "Nullify_Installments_Details" for making the execution not success for excluding the invoices / installment which was paid already
			--with excluding the invoices / installment which was paid already
		
				update NID set NID.Isdone='false'
				from T_Invoice_Child_Detail as ICD
				inner join
				Nullify_Installments_Details as NID on ICD.I_Invoice_Detail_ID=NID.Invoice_Detail_ID
				inner join
				@InvoiceDetails as ID on ID.InvoiceDetailID=ICD.I_Invoice_Detail_ID
				left join
				(
				select RCD2.I_Invoice_Detail_ID,RCD2.I_Receipt_Comp_Detail_ID
				from T_Receipt_Header as RH inner join
				T_Receipt_Component_Detail as RCD2 on RH.I_Receipt_Header_ID=RCD2.I_Receipt_Detail_ID
				where RH.I_Status=1
				)RCD on ICD.I_Invoice_Detail_ID=RCD.I_Invoice_Detail_ID
				where RCD.I_Receipt_Comp_Detail_ID IS NOT  NULL AND NID.Isdone IS NULL



		---------------- Execution Table -------------

		--Step 4:

		-- update the execution table "Nullify_Installments_Details" for making the execution with total amount which will reduced from main amount
		--with excluding the invoices / installment which was paid already

	
			UPDATE NID
			SET NID.TotalReductionAmount = subquery.TotalReduction
			FROM Nullify_Installments_Details AS NID
			JOIN (
				SELECT NID.Invoice_Header_ID, SUM(NID.PreviousAmount) AS TotalReduction
				FROM Nullify_Installments_Details AS NID
				inner join
				@InvoiceDetails as ID on ID.InvoiceDetailID=NID.Invoice_Detail_ID
				LEFT JOIN --T_Receipt_Component_Detail AS RCD ON NID.Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
				(
				select RCD2.I_Invoice_Detail_ID,RCD2.I_Receipt_Comp_Detail_ID
				from T_Receipt_Header as RH inner join
				T_Receipt_Component_Detail as RCD2 on RH.I_Receipt_Header_ID=RCD2.I_Receipt_Detail_ID
				where RH.I_Status=1
				)RCD on NID.Invoice_Detail_ID=RCD.I_Invoice_Detail_ID
				
				WHERE RCD.I_Receipt_Comp_Detail_ID IS NULL 
				  AND  NID.Isdone IS NULL
				GROUP BY NID.Invoice_Header_ID
			) AS subquery ON NID.Invoice_Header_ID = subquery.Invoice_Header_ID



		--Step 5:

		--Update in the main table with current amount with the help of  the execution table "Nullify_Installments_Details" for reducing the ampunt of total
		--with excluding the invoices / installment which was paid already
	
				--update TIP set TIP.N_Invoice_Amount=TIP.N_Invoice_Amount - ISNULL(NID.TotalReductionAmount,0) 
				--from T_Invoice_Parent as TIP
				--inner join
				
				--Nullify_Installments_Details as NID on TIP.I_Invoice_Header_ID=NID.Invoice_Header_ID
				--inner join
				--@InvoiceDetails as ID on ID.InvoiceDetailID=NID.Invoice_Detail_ID
				--left join
				----T_Receipt_Component_Detail as RCD on NID.Invoice_Detail_ID=RCD.I_Invoice_Detail_ID
				--(
				--select RCD2.I_Invoice_Detail_ID,RCD2.I_Receipt_Comp_Detail_ID
				--from T_Receipt_Header as RH inner join
				--T_Receipt_Component_Detail as RCD2 on RH.I_Receipt_Header_ID=RCD2.I_Receipt_Detail_ID
				--where RH.I_Status=1
				--)RCD on NID.Invoice_Detail_ID=RCD.I_Invoice_Detail_ID
				--where RCD.I_Receipt_Comp_Detail_ID IS  NULL and NID.Isdone IS NULL



		--		update TIP set TIP.N_Invoice_Amount=ISNULL(TIP.N_Invoice_Amount,0)-total.TotalReductionAmount
		--from T_Invoice_Parent as TIP 
		--inner join
		--		(SELECT DISTINCT NID.Invoice_Header_ID, NID.TotalReductionAmount
		--		FROM Nullify_Installments_Details AS NID
		--		inner join
		--		@InvoiceDetails as ID on ID.InvoiceDetailID=NID.Invoice_Detail_ID
		--		LEFT JOIN --T_Receipt_Component_Detail AS RCD ON NID.Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
		--		(
		--		select RCD2.I_Invoice_Detail_ID,RCD2.I_Receipt_Comp_Detail_ID
		--		from T_Receipt_Header as RH inner join
		--		T_Receipt_Component_Detail as RCD2 on RH.I_Receipt_Header_ID=RCD2.I_Receipt_Detail_ID
		--		where RH.I_Status=1
		--		)RCD on NID.Invoice_Detail_ID=RCD.I_Invoice_Detail_ID
		--		WHERE RCD.I_Receipt_Comp_Detail_ID IS NULL 
		--		  AND  NID.Isdone IS NULL
		--		) as  total on TIP.I_Invoice_Header_ID=total.Invoice_Header_ID


		--Step 5.1
		update TIP set TIP.N_Tax_Amount=ISNULL(TIP.N_Tax_Amount,0)-totalTax.TaxReduction
		from T_Invoice_Parent as TIP 
		inner join
				(SELECT NID.Invoice_Header_ID, SUM(NID.PreviousAmount) AS TotalReduction,SUM(NID.N_Tax_Amount) as TaxReduction
				FROM Nullify_Installments_Details AS NID
				inner join
				@InvoiceDetails as ID on ID.InvoiceDetailID=NID.Invoice_Detail_ID
				LEFT JOIN --T_Receipt_Component_Detail AS RCD ON NID.Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
				(
				select RCD2.I_Invoice_Detail_ID,RCD2.I_Receipt_Comp_Detail_ID
				from T_Receipt_Header as RH inner join
				T_Receipt_Component_Detail as RCD2 on RH.I_Receipt_Header_ID=RCD2.I_Receipt_Detail_ID
				where RH.I_Status=1
				)RCD on NID.Invoice_Detail_ID=RCD.I_Invoice_Detail_ID
				WHERE RCD.I_Receipt_Comp_Detail_ID IS NULL 
				  AND  NID.Isdone IS NULL
				GROUP BY NID.Invoice_Header_ID
				) as  totalTax on TIP.I_Invoice_Header_ID=totalTax.Invoice_Header_ID
				
		--Step 5.2
		update ICH set ICH.N_Amount=ISNULL(ICH.N_Amount,0)-ChildTax.TotalChildReduction,
		ICH.N_Tax_Amount=ISNULL(ICH.N_Tax_Amount,0)-ChildTax.TaxChildReduction
		from 
		T_Invoice_Child_Header as ICH
		inner join
				(
		SELECT DISTINCT NID.I_Invoice_Child_Header_ID, SUM(NID.PreviousAmount) AS TotalChildReduction,SUM(NID.N_Tax_Amount) as TaxChildReduction
				FROM Nullify_Installments_Details AS NID
				LEFT JOIN --T_Receipt_Component_Detail AS RCD ON NID.Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
				(
				select RCD2.I_Invoice_Detail_ID,RCD2.I_Receipt_Comp_Detail_ID
				from T_Receipt_Header as RH inner join
				T_Receipt_Component_Detail as RCD2 on RH.I_Receipt_Header_ID=RCD2.I_Receipt_Detail_ID
				where RH.I_Status=1
				)RCD on NID.Invoice_Detail_ID=RCD.I_Invoice_Detail_ID
				WHERE RCD.I_Receipt_Comp_Detail_ID IS NULL 
				  AND  NID.Isdone IS NULL
				GROUP BY NID.I_Invoice_Child_Header_ID
				) as ChildTax
				on ICH.I_Invoice_Child_Header_ID=ChildTax.I_Invoice_Child_Header_ID


		-- Step 5.3 -- Make Tax Zero

		update IDT set IDT.N_Tax_Value=0,IDT.N_Tax_Value_Scheduled=0 from
		T_Invoice_Detail_Tax as IDT
		inner join
		Nullify_Installments_Details as NID on IDT.I_Invoice_Detail_ID=NID.Invoice_Detail_ID
		LEFT JOIN --T_Receipt_Component_Detail AS RCD ON NID.Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
		(
				select RCD2.I_Invoice_Detail_ID,RCD2.I_Receipt_Comp_Detail_ID
				from T_Receipt_Header as RH inner join
				T_Receipt_Component_Detail as RCD2 on RH.I_Receipt_Header_ID=RCD2.I_Receipt_Detail_ID
				where RH.I_Status=1
				)RCD on NID.Invoice_Detail_ID=RCD.I_Invoice_Detail_ID
				WHERE RCD.I_Receipt_Comp_Detail_ID IS NULL 
				  AND  NID.Isdone IS NULL


		update IDT set N_CGST=0,N_SGST=0,N_IGST=0 from
		T_Invoice_Child_Detail as IDT
		inner join
		Nullify_Installments_Details as NID on IDT.I_Invoice_Detail_ID=NID.Invoice_Detail_ID
		LEFT JOIN --T_Receipt_Component_Detail AS RCD ON NID.Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
		(
				select RCD2.I_Invoice_Detail_ID,RCD2.I_Receipt_Comp_Detail_ID
				from T_Receipt_Header as RH inner join
				T_Receipt_Component_Detail as RCD2 on RH.I_Receipt_Header_ID=RCD2.I_Receipt_Detail_ID
				where RH.I_Status=1
				)RCD on NID.Invoice_Detail_ID=RCD.I_Invoice_Detail_ID
				WHERE RCD.I_Receipt_Comp_Detail_ID IS NULL 
				  AND  NID.Isdone IS NULL

		--Step 6:

		--Update in the main table with current amount with the help of  the execution table "Nullify_Installments_Details" for reducing the ampunt of total
		--with excluding the invoices / installment which was paid already
	
				update TIP set TIP.N_Invoice_Amount=TIP.N_Invoice_Amount - ISNULL(totalreduction.TotalReductionAmount,0)
				from
				(select top 1 NID.TotalReductionAmount,TIP.I_Invoice_Header_ID
				from T_Invoice_Parent as TIP
				inner join
				T_Invoice_Child_Header as ICH on TIP.I_Invoice_Header_ID=ICH.I_Invoice_Header_ID
				inner join 
				Nullify_Installments_Details as NID on TIP.I_Invoice_Header_ID=NID.Invoice_Header_ID
				inner join
				@InvoiceDetails as ID on ID.InvoiceDetailID=NID.Invoice_Detail_ID
				left join
				--T_Receipt_Component_Detail as RCD on NID.Invoice_Detail_ID=RCD.I_Invoice_Detail_ID
				(
				select RCD2.I_Invoice_Detail_ID,RCD2.I_Receipt_Comp_Detail_ID
				from T_Receipt_Header as RH inner join
				T_Receipt_Component_Detail as RCD2 on RH.I_Receipt_Header_ID=RCD2.I_Receipt_Detail_ID
				where RH.I_Status=1
				)RCD on NID.Invoice_Detail_ID=RCD.I_Invoice_Detail_ID
				where RCD.I_Receipt_Comp_Detail_ID IS  NULL and NID.Isdone IS NULL) as totalreduction
				inner join
				T_Invoice_Parent as TIP on totalreduction.I_Invoice_Header_ID=TIP.I_Invoice_Header_ID


		--Step 7:

			-- update the execution table "Nullify_Installments_Details" for making the execution success
			--with excluding the invoices / installment which was paid already

				update NID set NID.Isdone='true'
				from T_Invoice_Child_Detail as ICD
				inner join
				Nullify_Installments_Details as NID on ICD.I_Invoice_Detail_ID=NID.Invoice_Detail_ID
				inner join
				@InvoiceDetails as ID on ID.InvoiceDetailID=NID.Invoice_Detail_ID
				left join
				--T_Receipt_Component_Detail as RCD on ICD.I_Invoice_Detail_ID=RCD.I_Invoice_Detail_ID
				(
				select RCD2.I_Invoice_Detail_ID,RCD2.I_Receipt_Comp_Detail_ID
				from T_Receipt_Header as RH inner join
				T_Receipt_Component_Detail as RCD2 on RH.I_Receipt_Header_ID=RCD2.I_Receipt_Detail_ID
				where RH.I_Status=1
				)RCD on ICD.I_Invoice_Detail_ID=RCD.I_Invoice_Detail_ID
				where RCD.I_Receipt_Comp_Detail_ID IS  NULL AND NID.Isdone IS NULL


		
 -- Commit the transaction if everything is successful
    COMMIT TRANSACTION;

	select 1 as StatusFlag ,'Revise has been done Sucessfully' Message

END TRY
BEGIN CATCH
    -- Rollback the transaction if there is an error
    ROLLBACK TRANSACTION;

    -- Optionally, you can handle the error further, e.g., log it
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SET @ErrorMessage = ERROR_MESSAGE();
    SET @ErrorSeverity = ERROR_SEVERITY();
    SET @ErrorState = ERROR_STATE();
    
    -- Print or log the error details
    PRINT 'Error occurred: ' + @ErrorMessage;
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
	

END

