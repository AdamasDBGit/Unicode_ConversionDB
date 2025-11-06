-- =============================================
-- Author:		Sudipta Das
-- Create date: 05/04/2006
-- Description:	Student Transfer Details
-- =============================================

CREATE PROCEDURE [dbo].[uspGetStudentTransferDetails]
	
	@iStudentID int
				
AS
BEGIN


SELECT S_First_Name,S_Middle_Name,S_Last_Name from T_Student_Detail where I_Student_Detail_ID=@iStudentID


SELECT I_Centre_Id,S_Center_Name from T_Centre_Master where I_Centre_Id=(select I_Source_Centre_ID from T_Student_Transfer_Request where I_Student_Detail_ID=@iStudentID)



SELECT I_Centre_Id,S_Center_Name from T_Centre_Master where I_Centre_Id=(select I_Destination_Centre_ID from T_Student_Transfer_Request where I_Student_Detail_ID=@iStudentID)

SELECT * from T_Student_Transfer_Request where I_Student_Detail_ID=@iStudentID
END
