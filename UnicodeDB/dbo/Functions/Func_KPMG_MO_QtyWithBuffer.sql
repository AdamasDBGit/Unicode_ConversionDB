CREATE FUNCTION [dbo].[Func_KPMG_MO_QtyWithBuffer] 
(
	
	@Quantity INT
	
)
RETURNS INT
AS
BEGIN
	RETURN @Quantity+(@Quantity*10)/100
		 
END