CREATE PROCEDURE [ECOMMERCE].[uspSaveConfigDetails]
(
	@ConfigCode VARCHAR(MAX),
	@ConfigName VARCHAR(MAX),
	@ConfigDefaultValue VARCHAR(MAX)=''
)
AS
BEGIN

	IF NOT EXISTS(select * from ECOMMERCE.T_Cofiguration_Property_Master where ConfigCode=@ConfigCode and StatusID=1)
	BEGIN

		insert into ECOMMERCE.T_Cofiguration_Property_Master
		select @ConfigCode,@ConfigName,@ConfigDefaultValue,1

	END

END
