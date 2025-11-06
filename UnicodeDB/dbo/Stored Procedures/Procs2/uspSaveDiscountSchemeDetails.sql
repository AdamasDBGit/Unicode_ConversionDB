CREATE PROCEDURE [dbo].[uspSaveDiscountSchemeDetails]
(
	@DiscountSchemeID NVARCHAR(max),
	@DiscountRate DECIMAL(14,2)=NULL,
	@DiscountAmount DECIMAL(14,2)=NULL,
	@IsApplicableOn INT,
	@FromInstalment NVARCHAR(max)=NULL,
	@FeeComponentID NVARCHAR(max)=NULL,
	@CreatedBy NVARCHAR(max)='rice-group-admin'
)
AS
BEGIN

	DECLARE @DiscountSchemeDetailID INT=0

	if not exists(select * from T_Discount_Scheme_Details where I_Discount_Scheme_ID=@DiscountSchemeID and N_Discount_Amount=@DiscountAmount and 
									N_Discount_Rate=@DiscountRate and I_IsApplicableOn=@IsApplicableOn and S_FromInstalment=@FromInstalment and 
									S_FeeComponents=@FeeComponentID)
	begin

		insert into T_Discount_Scheme_Details
		select @DiscountSchemeID,@DiscountRate,@DiscountAmount,@IsApplicableOn,@FromInstalment,@FeeComponentID

		set @DiscountSchemeDetailID=SCOPE_IDENTITY()

	end


	select @DiscountSchemeDetailID

END


