/*****************************************************************************************************************
Created by: Debman Mukherjee
Date: 19/04/2007
Description: Select List of courses for the student
Parameters: 
Returns:	
Modified By: 
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspGetCoursesForStudent]
(
	@iStudentDetailId int
)

AS
BEGIN
	
	SELECT 
		CM.I_Course_ID,
		CM.S_Course_Name	
	FROM 
	T_Student_Course_Detail SCD
	INNER JOIN T_Course_Master CM
	ON SCD.I_Course_ID = CM.I_Course_ID
	WHERE SCD.I_Student_Detail_Id = @iStudentDetailId
	AND SCD.I_Status <> 0 AND CM.I_Status <> 0
	AND GETDATE() >= ISNULL(SCD.Dt_Valid_From,GETDATE())
	AND GETDATE() <= ISNULL(SCD.Dt_Valid_To,GETDATE())
	
END
