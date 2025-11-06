  CREATE PROCEDURE [ECOMMERCE].[uspSaveProductConfigMap]
  (
	  @ProductID INT,
	  @ConfigID INT,
	  @ConfigValue VARCHAR(MAX),
	  @ConfigDisplayName VARCHAR(MAX)='',
	  @SubHeaderID INT=NULL,
	  @SubHeaderDisplayName VARCHAR(MAX)=NULL,
	  @HeaderID INT=NULL,
	  @HeaderDisplayName VARCHAR(MAX)=NULL
  )
  AS
  BEGIN

	DECLARE @ProductConfigID INT=0

	IF NOT EXISTS(select * from ECOMMERCE.T_Product_Config where ProductID=@ProductID and ConfigID=@ConfigID and StatusID=1)
	BEGIN

		insert into ECOMMERCE.T_Product_Config
		select @ProductID,@ConfigID,@ConfigValue,@ConfigDisplayName,1,@SubHeaderID,@SubHeaderDisplayName,@HeaderID,@HeaderDisplayName

		SET @ProductConfigID=SCOPE_IDENTITY()

	END


	SELECT @ProductConfigID as ProductConfigID

  END
