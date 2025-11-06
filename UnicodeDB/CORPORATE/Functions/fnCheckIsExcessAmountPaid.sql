CREATE FUNCTION [CORPORATE].[fnCheckIsExcessAmountPaid]
(
	@I_Corporate_Invoice_Id int
)
RETURNS  VARCHAR(2)

AS 
BEGIN

DECLARE @checkID VARCHAR(2);
IF((SELECT COUNT(*) FROM CORPORATE.T_Corporate_Invoice_Receipt_Map AS tcirm
INNER JOIN dbo.T_Receipt_Header AS trh
ON tcirm.I_Receipt_Header_ID = trh.I_Receipt_Header_ID
WHERE I_Corporate_Invoice_Id = @I_Corporate_Invoice_Id
AND I_Receipt_Type = 26) > 0)
BEGIN
	SET @checkID = 'Y'
END
ELSE
BEGIN
	SET @checkID = 'N'
END
	

    -- Return the information to the caller
    RETURN @checkID
END;