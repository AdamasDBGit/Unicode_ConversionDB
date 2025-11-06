CREATE PROCEDURE [ECOMMERCE].[uspSaveLog]
(
	@InvokedRoute VARCHAR(MAX)=NULL,
	@InvokedMethod VARCHAR(MAX),
	@UniqueAttributeName VARCHAR(MAX)=NULL,
	@UniqueAttributeValue VARCHAR(MAX)=NULL,
	@RequestParameters VARCHAR(MAX)=NULL,
	@RequestResult VARCHAR(MAX)=NULL,
	@ErrorMessage VARCHAR(MAX)=NULL
)
AS
BEGIN


	insert into ECOMMERCE.T_Request_Logs
	select @InvokedRoute,@InvokedMethod,@UniqueAttributeName,@UniqueAttributeValue,@RequestParameters,@RequestResult,@ErrorMessage,GETDATE()


END
