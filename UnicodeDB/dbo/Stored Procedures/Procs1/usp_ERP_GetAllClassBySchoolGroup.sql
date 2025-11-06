--exec [dbo].[usp_ERP_GetAllClassBySchoolGroup] 1
CREATE PROCEDURE [dbo].[usp_ERP_GetAllClassBySchoolGroup]
(
@iSchoolGroupID INT = NULL
)
AS
BEGIN
select
 T1.I_Class_ID ClassID
,T2.S_Class_Name ClassName
from T_School_Group_Class T1 
inner join T_Class T2 ON T2.I_Class_ID = T1.I_Class_ID
where T1.I_School_Group_ID = @iSchoolGroupID and T2.I_Status=1

--where SD.S_Guardian_Mobile_No =ISNULL(@sMobile,SD.S_Guardian_Mobile_No)  AND [I_Gate_Pass_Request_ID] = ISNULL(@iGatePassRequestID,[I_Gate_Pass_Request_ID])
END
