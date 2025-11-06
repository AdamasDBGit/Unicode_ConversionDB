CREATE PROCEDURE [dbo].[spsMetaData]
(
    @Name VARCHAR(100) = NULL
)
/*
AUTHOR: Ryan Sockalosky
DATE: 05/05/2004
DESCRIPTION:
    Returns the records from the MetaData table supplying the Keys and Select, Insert,
    Update, and Delete statements to use to build the MetaDataManager content
    for the MetaDataManager class in .NET
MODIFIED:
    1 - 09/15/2004 - Ryan Sockalosky
        - Added optional Parameter to allow the user to get a specific item as opposed
        the entire MetaDataList
    2 - 10/20/2006 - Stephen Cromack
		- ported to Common Schema.
*/

AS
SET NOCOUNT ON

SELECT	Name,
        SelectCommand,
        UpdateCommand,
        InsertCommand,
        DeleteCommand,
        RefreshPerDay
FROM MetaData WITH (NOLOCK)
WHERE IsActive = 1
    AND Name = ISNULL(@Name, Name)

RETURN(0)
