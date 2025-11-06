-- exec [SelfService].[uspUpdatePaymentStatus] 1,''
CREATE PROCEDURE [SelfService].[uspUpdatePaymentStatus](@sStatus int,@sInvoice NVARCHAR(MAX))
AS
BEGIN


UPDATE T_Invoice_Child_Detail SET I_Payment_Status = @sStatus where S_Invoice_Number = @sInvoice
--while len(@sInvoice) > 0
--begin
--  --print left(@S, charindex(',', @S+',')-1)
--  select left(@sInvoice, charindex(',', @sInvoice+',')-1)
--  UPDATE T_Invoice_Child_Detail SET I_Payment_Status =  @sStatus where S_Invoice_Number = (left(@sInvoice, charindex(',', @sInvoice+',')-1))
--  set @sInvoice = stuff(@sInvoice, 1, charindex(',', @sInvoice+','), '')
--end


	  

END
