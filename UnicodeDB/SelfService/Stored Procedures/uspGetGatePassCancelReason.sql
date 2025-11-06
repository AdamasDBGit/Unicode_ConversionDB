-- exec [SelfService].[uspUpdatePaymentStatus] 1,'TEMP/0556815'
CREATE PROCEDURE [SelfService].[uspGetGatePassCancelReason](@iBrand int=null)
AS
BEGIN


select
I_GatePass_Cancel_Reason_ID ID,
S_Reason Reason
from T_GatePass_Cancel_Reason where I_Brand_ID = ISNULL(@iBrand,I_Brand_ID)


END
