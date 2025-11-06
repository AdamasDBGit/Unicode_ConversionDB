CREATE PROCEDURE [dbo].[usp_ERP_GetComponentDateBreakUP]
(
@sessionID int = null,
@feeComponetID int 
)
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @frequency int
	DECLARE @startDate date
	DECLARE @endDate date
	SELECT @startDate = Dt_Session_Start_Date,@endDate=Dt_Session_End_Date  
	FROM T_School_Academic_Session_Master WHERE I_Current_Session = 1
	and I_School_Session_ID=@sessionID
	SELECT @frequency = t3.I_Pay_InstallmentNo FROM T_ERP_Fee_Component t1 
	inner join 
	T_ERP_Fee_Structure_Installment_Component t2 on t1.I_Fee_Component_ID = t2.R_I_Fee_Component_ID
	inner join 
	T_ERP_Fee_PaymentInstallment_Type t3 on t3.I_Fee_Pay_Installment_ID = t2.R_I_Fee_Pay_Installment_ID
	WHERE I_Fee_Component_ID=@feeComponetID
	SELECT  

	   DATENAME(MONTH, InstallmentDate) + RIGHT(CONVERT(VARCHAR(12), InstallmentDate, 109), 8) InstallmentDate
	FROM dbo.GetInstallmentDatesInFinancialYear(@startDate, @endDate, @startDate, @frequency);
END

