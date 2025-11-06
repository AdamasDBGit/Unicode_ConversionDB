CREATE   PROCEDURE [dbo].[uspSaveDiscountScheme]
(
	@DiscountSchemeName Nnvarchar(max),
	@ValidFrom DATETIME,
	@ValidTo DATETIME,
	@CreatedBy Nnvarchar(max)='rice-group-admin',
	@sBrands Nnvarchar(max)
)
AS
BEGIN

	DECLARE @DiscountSchemeID INT=0

	if not exists(select * from T_Discount_Scheme_Master where S_Discount_Scheme_Name=@DiscountSchemeName and I_Status=1)
	begin

		insert into T_Discount_Scheme_Master
		select @DiscountSchemeName,@ValidFrom,@ValidTo,1,@CreatedBy,NULL,GETDATE(),NULL

		set @DiscountSchemeID=SCOPE_IDENTITY()

		insert into T_Discount_Brand_Map
		select @DiscountSchemeID,CAST(Val as INT),1 from fnString2Rows(@sBrands,',')

	end


	select @DiscountSchemeID

END

