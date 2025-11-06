

CREATE PROCEDURE [dbo].[usp_ERP_Save_Request_Log]
(
	@InvokedRoute Nnvarchar(max)=NULL,
	@sToken Nnvarchar(max),
	@Source Nnvarchar(max),
	@InvokedMethod Nnvarchar(max),
	@UniqueAttributeName Nnvarchar(max)=NULL,
	@UniqueAttributeValue Nnvarchar(max)=NULL,
	@RequestParameters Nnvarchar(max)=NULL,
	@RequestResult Nnvarchar(max)=NULL,
	@ErrorMessage Nnvarchar(max)=NULL,
	@MobileNo Nnvarchar(max)=NULL
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

