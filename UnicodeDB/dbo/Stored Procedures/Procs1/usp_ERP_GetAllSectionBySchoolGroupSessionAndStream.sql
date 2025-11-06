--exec [dbo].[usp_ERP_GetAllSectionBySchoolGroupSessionAndStream] 1,5,35,null
CREATE PROCEDURE [dbo].[usp_ERP_GetAllSectionBySchoolGroupSessionAndStream]
(
@iSchoolGroupID INT = NULL,
@iClassID int = null,
@iSchoolSessionID int = null,
@iStreamID int = null
)
AS
BEGIN
select 
T2.I_Section_ID SectionID,
T2.S_Section_Name SectionName
from
 [T_ERP_Class_Section] T1
 inner join T_Section T2 ON T1.I_Section_ID = T2.I_Section_ID
where T1.I_School_Group_ID = @iSchoolGroupID and T1.I_Class_ID = @iClassID 
and I_School_Session_ID = @iSchoolSessionID
and --T1.I_Stream_ID = ISNULL(@iStreamID,T1.I_Stream_ID)
(T1.I_Stream_ID = @iStreamID OR  @iStreamID IS NULL)

--where SD.S_Guardian_Mobile_No =ISNULL(@sMobile,SD.S_Guardian_Mobile_No)  AND [I_Gate_Pass_Request_ID] = ISNULL(@iGatePassRequestID,[I_Gate_Pass_Request_ID])
END
