

CREATE PROCEDURE [dbo].[usp_ERP_Save_Request_Log]
(
	@InvokedRoute NVARCHAR(MAX)=NULL,
	@sToken NVARCHAR(MAX),
	@Source NVARCHAR(MAX),
	@InvokedMethod NVARCHAR(MAX),
	@UniqueAttributeName NVARCHAR(MAX)=NULL,
	@UniqueAttributeValue NVARCHAR(MAX)=NULL,
	@RequestParameters NVARCHAR(MAX)=NULL,
	@RequestResult NVARCHAR(MAX)=NULL,
	@ErrorMessage NVARCHAR(MAX)=NULL,
	@MobileNo NVARCHAR(MAX)=NULL
)
AS
BEGIN


	insert into T_ERP_Request_Log
	select @MobileNo,@sToken,@Source,@InvokedRoute,@InvokedMethod,@UniqueAttributeName,@UniqueAttributeValue,@RequestParameters,@RequestResult,@ErrorMessage,GETDATE()

	DECLARE @NewRow INT

	set @NewRow = SCOPE_IDENTITY() 

	IF @UniqueAttributeName like '%transaction%' 
	BEGIN
	update T_ERP_Transaction_Master set RequestLogID=@NewRow where I_ERP_TransactionNo=@UniqueAttributeValue
	
	END

	select @NewRow as NewRow

END

