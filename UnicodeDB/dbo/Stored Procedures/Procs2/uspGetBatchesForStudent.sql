/*****************************************************************************************************************
Created by: Soumyopriyo Saha
Date: 24/08/2010
Description: Select Batch Ids for the student
Parameters: 
Returns:	
Modified By: 
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspGetBatchesForStudent] 
(
	@iStudentDetailId int
)

AS
BEGIN
	
	SELECT 
		tsbm.I_Batch_ID,ISNULL(S_Batch_Name,'')	AS S_Batch_Name
	FROM 
	dbo.T_Student_Batch_Details SCD 
	INNER JOIN t_student_batch_master tsbm ON scd.i_batch_id=tsbm.i_batch_id
	WHERE I_Student_ID = @iStudentDetailId
	AND scd.I_Status in (1,3) ORDER BY scd.I_Student_Batch_ID desc
END
