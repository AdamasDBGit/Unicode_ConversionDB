CREATE PROCEDURE [STUDENTFEATURES].[usp_GetAppropriateFaculty]
(
 @studentDetaildId int
,@courseId int
,@centerid int
,@termid int
,@moduleid int
)
as
begin

select ED.I_Employee_ID,ED.S_First_Name+ISNULL(ED.S_Middle_Name,'')+' '+ED.S_Last_Name AS S_Faculty_Name
from T_Employee_Dtls ED
INNER JOIN T_User_Master UM ON ED.I_Employee_ID = UM.I_Reference_ID
WHERE UM.S_Login_ID IN
(
select distinct Isnull(SAD.S_Crtd_By,'0')
from T_STUDENT_ATTENDANCE_DETAILS SAD WITH(NOLOCK)  
INNER JOIN T_Student_Attendance SA ON SAD.I_Student_Detail_ID= SA.I_Student_Detail_ID  
WHERE SAD.I_Student_Detail_ID = @studentDetaildId
and SAD.I_Centre_ID = @courseId
and SAD.I_Course_ID =  @centerid
and SAD.I_Term_ID = @termid
and SAD.I_Module_ID = @moduleid
)

end
