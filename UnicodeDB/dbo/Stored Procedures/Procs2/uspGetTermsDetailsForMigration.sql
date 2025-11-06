/*****************************************************************************************************************
Created by: Debman Mukherjee
Date: 19/04/2007
Description:Select Course and Term details for a course id
Parameters: 
Returns:	
Modified By: 
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspGetTermsDetailsForMigration]
(
	@iCourseId int
)
AS
BEGIN
	
		SELECT * FROM T_Course_Master
		WHERE I_Course_ID = @iCourseId
		AND I_Status<>0
		
		SELECT 
			TCP.I_Term_ID,
			TCP.I_Sequence
		FROM T_Term_Course_Map TCP
		WHERE TCP.I_Course_ID = @iCourseId
		AND TCP.I_Status<>0
		
END
