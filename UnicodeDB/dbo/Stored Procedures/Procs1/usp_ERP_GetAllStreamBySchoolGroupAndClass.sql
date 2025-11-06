--exec [dbo].[usp_ERP_GetAllClassBySchoolGroup] 4
CREATE PROCEDURE [dbo].[usp_ERP_GetAllStreamBySchoolGroupAndClass]
(
@iSchoolGroupID INT = NULL,
@iClassID int = null
)
AS
BEGIN
select 
T2.I_Stream_ID StreamID,
T2.S_Stream Stream
from
 T_ERP_Class_Stream T1
 inner join T_Stream T2 ON T1.I_Stream_ID = T2.I_Stream_ID
where T1.I_School_Group_ID = @iSchoolGroupID and T1.I_Class_ID = @iClassID

--where SD.S_Guardian_Mobile_No =ISNULL(@sMobile,SD.S_Guardian_Mobile_No)  AND [I_Gate_Pass_Request_ID] = ISNULL(@iGatePassRequestID,[I_Gate_Pass_Request_ID])
END
