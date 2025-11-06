CREATE PROCEDURE [dbo].[uspValidateDuplicateRecordExists]
(
	@sTableName Nnvarchar(max),
	@sFieldName Nnvarchar(max),
	@sValue Nnvarchar(max)
)
As

Begin

	Declare @sQuery nnvarchar(max)
	SET @sQuery ='SELECT ''TRUE'' FROM '+@sTableName +' Where '+ @sFieldName +'='+''''+@sValue+''''

	Create Table #Result
	(
		ResultValue nvarchar(max)
	)

	INSERT INTO #Result
	EXECUTE (@sQuery)

	SELECT Count(*) FROm #Result

End

