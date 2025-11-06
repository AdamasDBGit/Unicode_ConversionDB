CREATE FUNCTION [dbo].[DoesObjectExist]
/*
AUTHOR: Ramaprosad Ghosh
DATE: 03/28/2007
DESCRIPTION: Returns the table if an object exists
Modified : 

*/
(
@Object VARCHAR(1000),
@Type VARCHAR(50)
)
RETURNS @rtnTable TABLE
(            
id int
)

AS
BEGIN

INSERT INTO @rtnTable
SELECT object_id 
FROM sys.objects 
WHERE object_id = object_id(@Object) 
	AND OBJECTPROPERTY(object_id, @Type) = 1


RETURN
END