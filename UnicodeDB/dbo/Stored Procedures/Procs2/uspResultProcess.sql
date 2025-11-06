
--exec uspResultProcess '4',NULL
CREATE PROCEDURE [dbo].[uspResultProcess]
    (
      @iExamScheduleID int ,
      @iStudentDetailID int = null
    )
AS
    BEGIN

DECLARE @BrandID int = null

SET @BrandID = (select TSSM.I_Brand_ID from dbo.T_Result_Exam_Schedule as TRES
INNER JOIN dbo.T_School_Academic_Session_Master as TSSM ON TSSM.I_School_Session_ID = TRES.I_School_Session_ID
where TRES.I_Result_Exam_Schedule_ID = @iExamScheduleID)

-- print @BrandID

if(@BrandID=107)
begin

	exec dbo.uspResultProcessAIS @iExamScheduleID,@iStudentDetailID

end
else if (@BrandID=110)
begin

	exec dbo.uspResultProcessAWS @iExamScheduleID,@iStudentDetailID

end

select 1 StatusFlag,'Result Process succesfully' Message


    END
