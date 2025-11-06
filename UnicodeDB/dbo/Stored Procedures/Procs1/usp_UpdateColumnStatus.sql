CREATE PROCEDURE [dbo].[usp_UpdateColumnStatus]  
    @id INT  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    UPDATE T_ERP_Exam_SchedulesDetails   SET inStatus = CASE        WHEN inStatus = 0 THEN 1        ELSE 0         END  WHERE inExamScheduleDetailId = @id;  
  
  SELECT 1 AS StatusFlag, 'Status update successfully!' AS Message;  
END