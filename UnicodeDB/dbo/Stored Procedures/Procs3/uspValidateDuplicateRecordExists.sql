CREATE PROCEDURE [dbo].[uspValidateDuplicateRecordExists]
(
	@sTableName NVARCHAR(MAX),
	@sFieldName NVARCHAR(MAX),
	@sValue NVARCHAR(MAX)
)
As

Begin

	Declare @sQuery nVarchar(MAX)
	SET @sQuery ='SELECT ''TRUE'' FROM '+@sTableName +' Where '+ @sFieldName +'='+''''+@sValue+''''

	Create Table #Result
	(
		ResultValue VARCHAR(10)
	)

	INSERT INTO #Result
	EXECUTE (@sQuery)

	SELECT Count(*) FROm #Result

End

