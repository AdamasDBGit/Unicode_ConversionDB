/*****************************************************************************************************************
Created by: Debman Mukherjee
Date: 23/04/2007
Description: Get Invoice Detail by student id
Parameters: 
Returns:	
Modified By: 
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspGetInvoiceByStudentId]
(
	@iStudentDetailID int,
	@iCenterID int = null
)

AS
BEGIN

SELECT * FROM T_Invoice_Parent
WHERE I_Student_Detail_ID= @iStudentDetailID
AND I_Centre_Id = ISNULL(@iCenterID,I_Centre_Id)
AND I_Status <> 0
END
