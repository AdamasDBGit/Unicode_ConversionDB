-- =================================================================
-- Author:Shankha Roy
-- Create date:12/06/2007 
-- Description:Select list of Complaint Catagory records from T_Complaint_Category_Master table	
-- =================================================================

CREATE PROCEDURE [CUSTOMERCARE].[uspGetComplaintCatagoryList]
AS
BEGIN
	SELECT 
		ISNULL(I_Status_ID,0) AS I_Status_ID ,
        ISNULL(S_Complaint_Desc,' ') AS S_Complaint_Desc,
		ISNULL(S_Complaint_Code,' ') AS S_Complaint_Code,
		I_Complaint_Category_ID
	FROM [CUSTOMERCARE].[T_Complaint_Category_Master]
		WHERE I_Status_Id = 1
	ORDER BY S_Complaint_Desc	
END
