CREATE PROCEDURE [dbo].[uspGetReceiptTypeforSMS]
(
@ReceiptTypeID INT
)

AS
BEGIN
	SELECT TSM.S_Status_Desc_SMS FROM dbo.T_Status_Master TSM WHERE I_Status_Value=@ReceiptTypeID AND S_Status_Type='ReceiptType'
END
