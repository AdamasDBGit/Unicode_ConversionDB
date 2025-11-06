CREATE PROCEDURE [CUSTOMERCARE].[uspGetPOIDComplaintDetails]
(
	@I_Complaint_Req_ID INT
)

AS
BEGIN

SELECT I_Complaint_Req_ID,I_Center_ID,I_User_ID,I_Course_ID FROM	CUSTOMERCARE.T_Complaint_Request_Detail WHERE I_Complaint_Req_ID= @I_Complaint_Req_ID
end
