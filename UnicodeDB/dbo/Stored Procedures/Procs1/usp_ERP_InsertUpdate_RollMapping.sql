--exec [dbo].[uspGetStudentResult] '17-0009',null
CREATE PROCEDURE [dbo].[usp_ERP_InsertUpdate_RollMapping]
(
 @UTRoll UT_Roll readonly
)
AS
BEGIN
UPDATE T_Student_Class_Section
set S_Class_Roll_No = RollNo
from @UTRoll where I_Student_Class_Section_ID=StudentClassSectionID
select 1 StatusFlag,'Student Rolls updated succesfully' Message
END
