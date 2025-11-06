CREATE PROCEDURE [dbo].[usp_ERP_SaveDiscountSchemeDetails]
(
	@DiscountSchemeID NVARCHAR(max),
	@DiscountRate DECIMAL(14,2)=NULL,
	@DiscountAmount DECIMAL(14,2)=NULL,
	@IsApplicableOn INT,
	@FromInstalment NVARCHAR(max)=NULL,
	@FeeComponentID NVARCHAR(max)=NULL,
	@NoOfInstallment int=null,
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
		select @DiscountSchemeID,@DiscountRate,@DiscountAmount,@IsApplicableOn,@FromInstalment,@FeeComponentID,@NoOfInstallment,1

		set @DiscountSchemeDetailID=SCOPE_IDENTITY()

	end

		DECLARE @iDBrandID int = NULL

	select @iDBrandID=I_Discount_Brand_ID from T_Discount_Brand_Map where I_Discount_Scheme_ID=@DiscountSchemeID

	insert into T_Discount_Fee_Schedule_Detail
	select I_Fee_Structure_ID,@iDBrandID,1,1,NULL,GETDATE(),NULL
	from T_ERP_Fee_Structure

	select @DiscountSchemeDetailID

END

