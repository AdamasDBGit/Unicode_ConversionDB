-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2024Jan02>
-- Description:	<Get Payment Installment Type Master>
-- =============================================
CREATE PROCEDURE  [dbo].[usp_ERP_GetPaymentInstallmentFrequencyTypeDetails]
	-- Add the parameters for the stored procedure here
	@iBrandID INT,
	@isActive BIT,
	@feePayInstallmentID int=null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select I_Fee_Pay_Installment_ID as FeePayInstallmentID,
	I_Pay_InstallmentNo as NumberofInstallments,
	S_Installment_Frequency as InstallmentFrequencyDesc,
	Is_Active as IsActive,
	I_Interval as IntervalofMonth,
	I_Brand_ID as BrandID
	from 
	T_ERP_Fee_PaymentInstallment_Type
	where Is_Active=@isActive --and I_Brand_ID=@iBrandID
	and I_Fee_Pay_Installment_ID=ISNULL(@feePayInstallmentID,I_Fee_Pay_Installment_ID)



END
