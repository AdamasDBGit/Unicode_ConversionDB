-- =================================================================
-- Author:Shankha Roy
-- Create date:12/06/2007 
-- Description:Select list of Complaint Mode records from T_Complaint_Mode_Master Table	
-- =================================================================

CREATE PROCEDURE [CUSTOMERCARE].[uspGetComplaintModeList]
AS
BEGIN
	SELECT 
		ISNULL(I_Status_ID,0) AS I_Status_ID ,
        ISNULL(S_Complaint_Mode_Value,' ') AS S_Complaint_Mode_Value,
		ISNULL(S_Complaint_Mode_Code,' ') AS S_Complaint_Mode_Code,
		I_Complaint_Mode_ID

	FROM [CUSTOMERCARE].[T_Complaint_Mode_Master]
		WHERE I_Status_Id = 1
	ORDER BY S_Complaint_Mode_Value	
END
