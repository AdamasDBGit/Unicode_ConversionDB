CREATE PROCEDURE [dbo].[usp_ERP_SaveDiscountSchemeBrandFeePlanStructureMap]
(
@DiscountSchemeID INT,
@BrandID int,
--@CenterID INT=null,
--@CourseID INT=null,
@ERPFeeStructureID int,
@CreatedBy int
)
AS
BEGIN

	Declare @DiscountBrandID INT=0

	IF EXISTS(select * from T_Discount_Scheme_Master where I_Discount_Scheme_ID=@DiscountSchemeID and I_Status=1)
	begin

		if not exists (select * from T_Discount_Brand_Map where I_Discount_Scheme_ID=@DiscountSchemeID and I_Brand_ID=@BrandID and I_Status_ID=1)
		begin

			insert into T_Discount_Brand_Map
			select @DiscountSchemeID,@BrandID,1

			set @DiscountBrandID=SCOPE_IDENTITY()

		end
		else
		begin

			select @DiscountBrandID=I_Discount_Brand_ID from T_Discount_Brand_Map where I_Discount_Scheme_ID=@DiscountSchemeID and I_Brand_ID=@BrandID and I_Status_ID=1

		end

		if(@DiscountBrandID>0)
		begin

			if not exists(select * from T_Discount_Fee_Schedule_Detail where I_Discount_Brand_ID=@DiscountBrandID and I_ERP_Fee_Structure_ID=@ERPFeeStructureID and I_Status_ID=1)
			begin

				insert into T_Discount_Fee_Schedule_Detail
				select @ERPFeeStructureID,@DiscountBrandID,1,@CreatedBy,NULL,GETDATE(),NULL

			end

		end

	end

END