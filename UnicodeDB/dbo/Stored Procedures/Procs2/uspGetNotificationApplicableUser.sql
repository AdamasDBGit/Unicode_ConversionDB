--exec uspGetNotificationApplicableUser 107,3  
CREATE PROCEDURE [dbo].[uspGetNotificationApplicableUser]      
(      
@BrandID int,
@NotificationApplicableID int
)      
      
AS       
      
BEGIN TRY      
      
    SET NoCount ON ;      
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED;      
      	     

select StaffId, StaffName, ApplicableForId from
(
select A.I_User_ID StaffId, ISNULL(A.S_First_Name,'')+ISNULL(S_Middle_Name,'')+ISNULL(A.S_Last_Name,'') StaffName
,(case when B.Is_Teaching_Staff=1 then 'Faculty' else 'Staff' end) ApplicableForName
,(case when B.Is_Teaching_Staff=1 then '1' else '2' end) ApplicableForId
from T_ERP_User A left outer join
T_ERP_User_Brand B on A.I_User_ID=B.I_User_ID where b.I_Brand_ID=@BrandID and A.I_Status=1
union all
select TSG.I_School_Group_ID StaffId, TSG.S_School_Group_Name as StaffName
,('School Program') ApplicableForName
,'3' ApplicableForId
 from [dbo].[T_School_Group]as TSG where I_Brand_Id=@BrandID and I_Status=1  
) T where T.ApplicableForId=@NotificationApplicableID

       
END TRY      
      
BEGIN CATCH      
 ROLLBACK TRANSACTION      
    DECLARE @ErrMsg NVARCHAR(4000),@ErrSeverity INT      
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()      
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )      
      
END CATCH      