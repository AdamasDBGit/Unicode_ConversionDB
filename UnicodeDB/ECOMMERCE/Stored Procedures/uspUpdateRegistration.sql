CREATE PROCEDURE [ECOMMERCE].[uspUpdateRegistration]
(
	@CustomerID VARCHAR(MAX),
	@GuardianName VARCHAR(MAX)=NULL,
	@GuardianMobileNo VARCHAR(MAX)=NULL,
	@SecondaryLanguage VARCHAR(MAX)=NULL,
	@SocialCategory VARCHAR(MAX)=NULL,
	@UpdatedBy VARCHAR(MAX)='rice-group-admin'
)
AS
BEGIN

	DECLARE @RegID INT=0


	IF EXISTS(select * from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)
	BEGIN

		IF(@GuardianName IS NOT NULL)
		BEGIN

			UPDATE ECOMMERCE.T_Registration
			SET
			GuardianName=@GuardianName,
			UpdatedBy=@UpdatedBy,
			UpdatedOn=GETDATE()
			WHERE
			CustomerID=@CustomerID


			update T_Enquiry_Regn_Detail set S_Guardian_Name=@GuardianName where I_Enquiry_Regn_ID in
			(
				select A.EnquiryID from ECOMMERCE.T_Registration_Enquiry_Map A
				inner join ECOMMERCE.T_Registration B on A.RegID=B.RegID
				where
				B.CustomerID=@CustomerID
			)

		END
		IF(@GuardianMobileNo IS NOT NULL)
		BEGIN

			UPDATE ECOMMERCE.T_Registration
			SET
			GuardianMobileNo=@GuardianMobileNo,
			UpdatedBy=@UpdatedBy,
			UpdatedOn=GETDATE()
			WHERE
			CustomerID=@CustomerID

			update T_Enquiry_Regn_Detail set S_Guardian_Mobile_No=@GuardianMobileNo where I_Enquiry_Regn_ID in
			(
				select A.EnquiryID from ECOMMERCE.T_Registration_Enquiry_Map A
				inner join ECOMMERCE.T_Registration B on A.RegID=B.RegID
				where
				B.CustomerID=@CustomerID
			)

		END
		IF(@SecondaryLanguage IS NOT NULL)
		BEGIN

			UPDATE ECOMMERCE.T_Registration
			SET
			SecondLanguage=@SecondaryLanguage,
			UpdatedBy=@UpdatedBy,
			UpdatedOn=GETDATE()
			WHERE
			CustomerID=@CustomerID

			update T_Enquiry_Regn_Detail set S_Second_Language_Opted=@SecondaryLanguage where I_Enquiry_Regn_ID in
			(
				select A.EnquiryID from ECOMMERCE.T_Registration_Enquiry_Map A
				inner join ECOMMERCE.T_Registration B on A.RegID=B.RegID
				where
				B.CustomerID=@CustomerID
			)

		END
		IF(@SocialCategory IS NOT NULL)
		BEGIN

			DECLARE @CasteID INT

			UPDATE ECOMMERCE.T_Registration
			SET
			SocialCategory=@SocialCategory,
			UpdatedBy=@UpdatedBy,
			UpdatedOn=GETDATE()
			WHERE
			CustomerID=@CustomerID

			select @CasteID=ISNULL(I_Caste_ID,0) from T_Caste_Master where UPPER(S_Caste_Name)=UPPER(@SocialCategory) and I_Status=1

			if(@CasteID<=0)
			begin

				insert into T_Caste_Master
				select @SocialCategory,1,'rice-group-admin',NULL,GETDATE(),NULL

				set @CasteID=SCOPE_IDENTITY()

			end

			if(@CasteID>0)
			BEGIN

				update T_Enquiry_Regn_Detail set I_Caste_ID=@CasteID where I_Enquiry_Regn_ID in
				(
					select A.EnquiryID from ECOMMERCE.T_Registration_Enquiry_Map A
					inner join ECOMMERCE.T_Registration B on A.RegID=B.RegID
					where
					B.CustomerID=@CustomerID
				)

			END

		END

		

	END

	select ISNULL(RegID,0) as RegID from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1


END
