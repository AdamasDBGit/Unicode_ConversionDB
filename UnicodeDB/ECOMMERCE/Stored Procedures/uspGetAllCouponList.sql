CREATE PROCEDURE [ECOMMERCE].[uspGetAllCouponList]
(
	@CustomerID VARCHAR(MAX),
	@CouponType VARCHAR(MAX)='CAMPAIGN',
	@CampaignName VARCHAR(MAX)=NULL
)
AS
BEGIN


	BEGIN TRY


		IF(@CouponType='CAMPAIGN')
		BEGIN

			select A.CouponCode,C.CampaignName,D.LumpsumDiscountPerc,E.InstalmentDiscountPerc,ISNULL(G.MessageDesc,'') as MessageDesc
			from 
			ECOMMERCE.T_Coupon_Master A
			inner join ECOMMERCE.T_Campaign_Discount_Map B on A.CampaignDiscountMapID=B.ID and B.StatusID=1
			inner join ECOMMERCE.T_Campaign_Master C on B.CampaignID=C.CampaignID and C.StatusID=1
			inner join ECOMMERCE.T_Campaign_Coupon_Details G on A.CouponID=G.CouponID and G.CampaignDiscountMapID=B.ID and G.CamapaignID=C.CampaignID
			left join
			(
				select I_Discount_Scheme_ID,SUM(ISNULL(N_Discount_Rate,0)) as LumpsumDiscountPerc 
				from T_Discount_Scheme_Details 
				where I_IsApplicableOn=1
				group by I_Discount_Scheme_ID
			) D on A.DiscountSchemeID=D.I_Discount_Scheme_ID 
			left join
			(
				select I_Discount_Scheme_ID,SUM(ISNULL(N_Discount_Rate,0)) as InstalmentDiscountPerc 
				from T_Discount_Scheme_Details 
				where I_IsApplicableOn=2
				group by I_Discount_Scheme_ID
			) E on A.DiscountSchemeID=E.I_Discount_Scheme_ID
			inner join T_Discount_Scheme_Master F on A.DiscountSchemeID=F.I_Discount_Scheme_ID and F.I_Status=1
			where 
			C.CampaignName=@CampaignName and A.CustomerID=@CustomerID
			and
			CONVERT(DATE,F.Dt_Valid_From)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(F.Dt_Valid_To,GETDATE()))>=CONVERT(DATE,GETDATE())
			and
			CONVERT(DATE,A.ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(A.ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())


		END


		IF(@CouponType='CUSTOMER')
		BEGIN

			select A.CouponCode,ISNULL(C.CampaignName,'') as CampaignName,ISNULL(D.LumpsumDiscountPerc,0) as LumpsumDiscountPerc,ISNULL(E.InstalmentDiscountPerc,0) as InstalmentDiscountPerc,
			ISNULL(G.MessageDesc,'') as MessageDesc
			from 
			ECOMMERCE.T_Coupon_Master A
			left join ECOMMERCE.T_Campaign_Discount_Map B on A.CampaignDiscountMapID=B.ID and B.StatusID=1
			left join ECOMMERCE.T_Campaign_Master C on B.CampaignID=C.CampaignID and C.StatusID=1 and C.CampaignName=@CampaignName
			left join ECOMMERCE.T_Campaign_Coupon_Details G on A.CouponID=G.CouponID --and G.CampaignDiscountMapID=B.ID and G.CamapaignID=C.CampaignID
			left join
			(
				select I_Discount_Scheme_ID,SUM(ISNULL(N_Discount_Rate,0)) as LumpsumDiscountPerc 
				from T_Discount_Scheme_Details 
				where I_IsApplicableOn=1
				group by I_Discount_Scheme_ID
			) D on A.DiscountSchemeID=D.I_Discount_Scheme_ID 
			left join
			(
				select I_Discount_Scheme_ID,SUM(ISNULL(N_Discount_Rate,0)) as InstalmentDiscountPerc 
				from T_Discount_Scheme_Details 
				where I_IsApplicableOn=2
				group by I_Discount_Scheme_ID
			) E on A.DiscountSchemeID=E.I_Discount_Scheme_ID
			inner join T_Discount_Scheme_Master F on A.DiscountSchemeID=F.I_Discount_Scheme_ID and F.I_Status=1
			where 
			A.CustomerID=@CustomerID
			and
			CONVERT(DATE,F.Dt_Valid_From)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(F.Dt_Valid_To,GETDATE()))>=CONVERT(DATE,GETDATE())
			and
			CONVERT(DATE,A.ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(A.ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())


		END



	END TRY
	BEGIN CATCH
	--Error occurred:  
		ROLLBACK TRANSACTION
		DECLARE @ErrMsg NVARCHAR(4000) ,
			@ErrSeverity INT
		SELECT  @ErrMsg = ERROR_MESSAGE() ,
				@ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH

END
