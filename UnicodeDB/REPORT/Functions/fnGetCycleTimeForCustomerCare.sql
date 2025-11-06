/*******************************************************************************************************
* Author		:	SHANKHA ROY
* Create date	:	24/01/2008
* Description	:	This Function checks calculate the Cycle time for Customer Care report
* Return		:	Integer
*******************************************************************************************************/
CREATE FUNCTION [REPORT].[fnGetCycleTimeForCustomerCare]
(
 @iUserAssignStatus INT,
 @CloseStatus INT,
 @ComplaintID INT
)
RETURNS INT

AS
BEGIN

DECLARE @dtFromDATE DATETIME
DECLARE @dtTODATE DATETIME
DECLARE @iCycleTime INT

SET @iCycleTime = 0

IF(@CloseStatus >= @iUserAssignStatus)
BEGIN	

	IF EXISTS(SELECT Dt_Upd_On FROM CUSTOMERCARE.T_Complaint_Request_Detail
	WHERE I_Status_ID = @CloseStatus
	AND I_Complaint_Req_ID = @ComplaintID
	AND I_Status_ID != 6
	AND I_Status_ID != 7)
	BEGIN
--		SET @dtTODATE = (SELECT MAX(Dt_Upd_On) FROM CUSTOMERCARE.T_Complaint_Request_Detail
--		WHERE I_Status_ID = @CloseStatus
--		AND I_Complaint_Req_ID = @ComplaintID)
	SET @dtTODATE =GETDATE()
	END
	ELSE
		BEGIN
			IF(@CloseStatus != 6 AND @CloseStatus != 7)
				BEGIN

					SET @dtTODATE = (SELECT MIN(Dt_Upd_On) FROM CUSTOMERCARE.T_Complaint_Audit_Trail
					WHERE I_Status_ID !=1 AND I_Complaint_Audit_ID = (SELECT TOP 1 B.I_Complaint_Audit_ID FROM CUSTOMERCARE.T_Complaint_Audit_Trail B
					WHERE  B.I_Complaint_Req_ID = @ComplaintID  AND B.I_Complaint_Audit_ID > (SELECT MIN(I_Complaint_Audit_ID) FROM CUSTOMERCARE.T_Complaint_Audit_Trail 
					WHERE  I_Complaint_Req_ID = @ComplaintID AND I_Status_ID = @CloseStatus) ORDER BY B.I_Complaint_Audit_ID ASC
					))
				END
			ELSE
				BEGIN
					SET @dtTODATE = (SELECT MAX(Dt_Upd_On) FROM CUSTOMERCARE.T_Complaint_Request_Detail
						WHERE I_Status_ID = 6 -- Closed by Customercare @CloseStatus
						AND I_Complaint_Req_ID = @ComplaintID)
				END	
		END

	-- This for get the date for Cycle Time Start
    SET @dtFromDATE =[REPORT].fnGetComplaintLoggedDate(@ComplaintID)

--Logic : Cycle Time = (Current Date - Assigne Date ) IF Complaint is not Close
-- If Close  Cycle Time =(Close Date - Assign Date)
  

	SET @iCycleTime =(SELECT CONVERT(INT,(DATEDIFF(DD,@dtFromDATE,@dtTODATE))))


END
ELSE
BEGIN
	SET @iCycleTime = 0
END


RETURN @iCycleTime;
END