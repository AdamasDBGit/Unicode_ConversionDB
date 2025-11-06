CREATE PROCEDURE [dbo].[uspGetMetaDataList] 
(
    @Name VARCHAR(100) = NULL
)	

AS
BEGIN

	SET NOCOUNT ON

SELECT	Name,
        SelectCommand,
        UpdateCommand,
        InsertCommand,
        DeleteCommand,
        RefreshPerDay,
		IsActive -- cacheable flag
FROM MetaData WITH (NOLOCK)
WHERE Name = ISNULL(@Name, Name)

RETURN(0)


END
