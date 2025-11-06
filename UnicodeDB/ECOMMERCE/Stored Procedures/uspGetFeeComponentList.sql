CREATE PROCEDURE [ECOMMERCE].[uspGetFeeComponentList](@BrandID INT=0)
AS
BEGIN

	IF(@BrandID>0)
	BEGIN

		select * from T_Fee_Component_Master where I_Brand_ID=@BrandID and I_Status=1 order by I_Brand_ID,I_Fee_Component_ID

	END
	ELSE
	BEGIN

		select * from T_Fee_Component_Master where I_Status=1 order by I_Brand_ID,I_Fee_Component_ID

	END

END
