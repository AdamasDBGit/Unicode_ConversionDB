CREATE PROCEDURE [dbo].[uspGetHostelVacancy] 
( 
   @iRoomId INT = NULL
   )
   AS
   BEGIN
   SELECT COUNT(*) FROM t_student_detail WHERE I_room_ID=@iRoomId
   END
