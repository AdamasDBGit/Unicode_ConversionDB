/*****************************************************************************************************************
Created by: Debman Mukherjee
Date: 07/05/2007
Description:Gets the list of dropout status
Parameters: 
******************************************************************************************************************/
CREATE PROCEDURE [dbo].[uspGetDropoutType]

AS

BEGIN
	SET NOCOUNT ON;

	SELECT * FROM [ACADEMICS].T_Dropout_Type_Master 

END
