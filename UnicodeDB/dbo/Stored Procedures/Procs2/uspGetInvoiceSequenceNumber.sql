CREATE PROCEDURE [dbo].[uspGetInvoiceSequenceNumber]
(
	@I_Brand_ID INT = NULL,
	@I_State_ID INT = NULL,
	@S_Invoice_Type Nnvarchar(max) = NULL
)
AS
BEGIN
	
	DECLARE @SQN INT

	IF(@I_Brand_ID IS NOT NULL AND @I_State_ID IS NOT NULL AND @S_Invoice_Type IS NOT NULL)
	BEGIN
		SELECT  @SQN = (I_Sequence_Number + 1) 
		FROM T_Invoice_Sequence_Number WHERE I_Brand_ID = @I_Brand_ID AND I_State_ID = @I_State_ID AND S_Invoice_type = @S_Invoice_Type
		
		---PLEASE COMMENT WHILE CHECKING
		UPDATE T_Invoice_Sequence_Number SET I_Sequence_Number = I_Sequence_Number + 1 
		WHERE I_Brand_ID = @I_Brand_ID AND I_State_ID = @I_State_ID AND S_Invoice_type = @S_Invoice_Type
	END
	ELSE
	BEGIN
		SELECT @SQN = (I_Sequence_Number + 1) 
		FROM T_Invoice_Sequence_Number WHERE I_Brand_ID = -1 AND I_State_ID = -1 AND S_Invoice_type = @S_Invoice_Type
		
		---PLEASE COMMENT WHILE CHECKING
		UPDATE T_Invoice_Sequence_Number SET I_Sequence_Number = I_Sequence_Number + 1
		WHERE I_Brand_ID = -1 AND I_State_ID = -1
	END	 

	RETURN @SQN 

END

