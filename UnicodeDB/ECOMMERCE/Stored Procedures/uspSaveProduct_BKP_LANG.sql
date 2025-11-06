CREATE PROCEDURE [ECOMMERCE].[uspSaveProduct_BKP_LANG]
(
	@ProductCode VARCHAR(MAX),
	@ProductName VARCHAR(MAX),
	@ProductShortDesc VARCHAR(MAX)=NULL,
	@ProductLongDesc VARCHAR(MAX)=NULL,
	@CourseID INT,
	@BrandID INT,
	@CategoryID INT,
	@IsPublished BIT=0,
	@ValidFrom DATETIME,
	@ValidTo DATETIME,
	@CreatedBy VARCHAR(MAX)='rice-group-admin',
	@ProductImage VARCHAR(MAX)
)
AS
BEGIN

	BEGIN TRY

		BEGIN TRANSACTION


		if exists(select * from ECOMMERCE.T_Product_Master where StatusID=1 and ProductName=@ProductName and BrandID=@BrandID)
		BEGIN

			RAISERROR('Product with same name already exists for this brand', 11, 1)

		END

		insert into ECOMMERCE.T_Product_Master
		(
			ProductCode,
			ProductName,
			ProductShortDesc,
			ProductLongDesc,
			CourseID,
			CategoryID,
			BrandID,
			StatusID,
			IsPublished,
			ValidFrom,
			ValidTo,
			CreatedBy,
			CreatedOn,
			ProductImage
		)
		select @ProductCode,
			   @ProductName,
			   @ProductShortDesc,
			   @ProductLongDesc,
			   @CourseID,
			   @CategoryID,
			   @BrandID,
			   1,
			   @IsPublished,
			   @ValidFrom,
			   @ValidTo,
			   @CreatedBy,
			   GETDATE(),
			   @ProductImage


		select SCOPE_IDENTITY() as ProductID



		COMMIT TRANSACTION

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
