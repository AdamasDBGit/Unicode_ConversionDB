-- =============================================
-- Author: Ujjwal Sinha
-- Create date: 14/06/2007
-- Description:	Search a Root Cause from T_Root_Cause_Master
-- =============================================
CREATE PROCEDURE [CUSTOMERCARE].[uspGetRootCauseDetail]
(
	@iRootCauseID INT
)

AS
BEGIN

   SELECT ISNULL(RCM.I_Complaint_Category_ID,0) AS I_Complaint_Category_ID  ,
          ISNULL(RCM.S_Root_Cause_Code,'') AS S_Root_Cause_Code		,
		  ISNULL(RCM.S_Root_Cause_Desc,'') AS S_Root_Cause_Desc	,
		  RCM.I_Root_Cause_ID ,
		  ISNULL(CCM.S_Complaint_Desc, '') AS S_Complaint_Desc			  
     FROM [CUSTOMERCARE].T_Root_Cause_Master RCM
	 INNER JOIN CUSTOMERCARE.T_Complaint_Category_Master CCM
	 ON RCM.I_Complaint_Category_ID = CCM.I_Complaint_Category_ID
     WHERE RCM.I_Root_Cause_ID = @iRootCauseID
     AND RCM.I_Status_ID = 1


END
