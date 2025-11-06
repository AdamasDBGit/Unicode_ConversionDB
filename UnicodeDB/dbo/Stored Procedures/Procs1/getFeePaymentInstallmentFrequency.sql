-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- exec getFeePaymentInstallmentFrequency null null
-- =============================================
CREATE PROCEDURE [dbo].[getFeePaymentInstallmentFrequency]
	-- Add the parameters for the stored procedure here
	(
		@iBrandID INT NULL,
		@FeePayInstallmentID INT NULL
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select I_Fee_Pay_Installment_ID as FeePayInstallmentID,
	I_Pay_InstallmentNo as PayInstallmentNo,
	S_Installment_Frequency as InstallmentFrequency,
	I_Interval as Interval

	from T_ERP_Fee_PaymentInstallment_Type

	where I_Brand_ID = ISNULL(@iBrandID, I_Brand_ID) 
	and I_Fee_Pay_Installment_ID = ISNULL(@FeePayInstallmentID, I_Fee_Pay_Installment_ID)
	and Is_Active = 1
END
