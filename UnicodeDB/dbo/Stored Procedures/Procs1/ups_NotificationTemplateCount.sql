-- Author: Qutub Haider
-- Create date: 2024-08-16

--EXEC ups_ERP_Exam_getExamScheduleStatusCount 52

CREATE PROCEDURE [dbo].[ups_NotificationTemplateCount]	
(
	@inUserId INT = NULL
)
AS
BEGIN

    SELECT 
		COUNT(DISTINCT NT.inNotificationTemplateID),
		ND.S_NotificationDelivery_Name,
		ND.stCssClass
    FROM T_NotificationTemplate NT
		LEFT JOIN T_ERP_NotificationDelivery ND ON ND.I_NotificationDelivery_ID = NT.inNotificationTypeID	
	GROUP BY ND.S_NotificationDelivery_Name, ND.stCssClass
		

END

