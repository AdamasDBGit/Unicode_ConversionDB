CREATE PROCEDURE [dbo].[uspValidateDuplicateRecordExists]
(
	@sTableName NVARCHAR(max),
	@sFieldName NVARCHAR(max),
	@sValue NVARCHAR(max)
)
As

Begin

	Declare @sQuery NVARCHAR(max)
	SET @sQuery ='SELECT ''TRUE'' FROM '+@sTableName +' Where '+ @sFieldName +'='+''''+@sValue+''''

	Create Table #Result
	(
		ResultValue nvarchar(max)
	)

	INSERT INTO #Result
	EXECUTE (@sQuery)

	SELECT Count(*) FROm #Result

End


