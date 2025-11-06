CREATE FUNCTION BrandValurTC
-- =============================================
     -- Author: Tridip Chatterjee
-- Create date: 28-09-2023
-- Description:	To fetch_Brand_ID
-- =============================================



(
	-- Add the parameters for the function here
@BrandName nvarchar(400)
)
RETURNS nvarchar(400)
AS
BEGIn
    declare @V nvarchar(400)

	Set @V=(select distinct I_Brand_ID from T_Center_Hierarchy_Name_Details where 
	S_Brand_Name like ('%'+@BrandName+'%'))

	-- Return the result of the function
	RETURN @V

END