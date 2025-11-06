CREATE PROCEDURE [dbo].[uspSaveDiscountSchemeCenterCourseMap]
(
@DiscountSchemeID INT,
@CenterID INT,
@CourseID INT,
@CreatedBy Nnvarchar(max)='rice-group-admin'
)
AS
BEGIN

	Declare @DiscountCenterID INT=0

	IF EXISTS(select * from T_Discount_Scheme_Master where I_Discount_Scheme_ID=@DiscountSchemeID and I_Status=1)
	begin

		if not exists (select * from T_Discount_Center_Detail where I_Discount_Scheme_ID=@DiscountSchemeID and I_Centre_ID=@CenterID and I_Status=1)
		begin

			insert into T_Discount_Center_Detail
			select @DiscountSchemeID,@CenterID,1,@CreatedBy,NULL,GETDATE(),NULL

			set @DiscountCenterID=SCOPE_IDENTITY()

		end
		else
		begin

			select @DiscountCenterID=I_Discount_Center_Detail_ID from T_Discount_Center_Detail where I_Discount_Scheme_ID=@DiscountSchemeID and I_Centre_ID=@CenterID and I_Status=1

		end

		if(@DiscountCenterID>0)
		begin

			if not exists(select * from T_Discount_Course_Detail where I_Discount_Centre_Detail_ID=@DiscountCenterID and I_Course_ID=@CourseID and I_Status=1)
			begin

				insert into T_Discount_Course_Detail
				select @CourseID,1,@DiscountCenterID,@CreatedBy,NULL,GETDATE(),NULL

			end

		end

	end

END

