CREATE PROCEDURE [dbo].[spGetCacheObjects]
/*
AUTHOR: Rachel Noiseux
DATE: 09/19/2005
DESCRIPTION: Reads all the rows from the CacheObject table.
MODIFIED:
10/20/2006 Stephen Cromack
	- Ported into Common Schema
*/
 
AS

SET NOCOUNT ON

SELECT [Name],
    [Description],
    ClassName,
    ExpiresIn,
    UtilizeCache,
    CacheKey
FROM dbo.CacheObject WITH (NOLOCK)
