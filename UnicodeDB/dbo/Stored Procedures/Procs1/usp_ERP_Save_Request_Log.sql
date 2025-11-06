

CREATE PROCEDURE [dbo].[usp_ERP_Save_Request_Log]
(
	@InvokedRoute NVARCHAR(max)=NULL,
	@sToken NVARCHAR(max),
	@Source NVARCHAR(max),
	@InvokedMethod NVARCHAR(max),
	@UniqueAttributeName NVARCHAR(max)=NULL,
	@UniqueAttributeValue NVARCHAR(max)=NULL,
	@RequestParameters NVARCHAR(max)=NULL,
	@RequestResult NVARCHAR(max)=NULL,
	@ErrorMessage NVARCHAR(max)=NULL,
	@MobileNo NVARCHAR(max)=NULL
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


