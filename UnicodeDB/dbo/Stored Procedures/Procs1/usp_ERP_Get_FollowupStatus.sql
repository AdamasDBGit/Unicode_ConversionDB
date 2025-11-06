--exec [dbo].[uspGetComponentMaster] 110,1
CREATE PROCEDURE [dbo].[usp_ERP_Get_FollowupStatus]

AS
BEGIN
  select I_FollowupStatus_ID ID,S_FollowupStatus_Desc 
  Description from T_ERP_Followup_StatusM 
  where Is_Active=1
  order by I_Seq asc
END
