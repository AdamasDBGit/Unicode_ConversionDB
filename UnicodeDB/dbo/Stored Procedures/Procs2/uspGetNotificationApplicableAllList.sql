CREATE   PROCEDURE [dbo].[uspGetNotificationApplicableAllList]    
(    
@NotificationApplicableForID int    
,@NotificationBrandId int  
)    
    
AS     
    
BEGIN TRY    
    
    SET NoCount ON ;    
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED;    
  
select * from  
(  
select A.I_User_ID ApplicableId, ISNULL(A.S_First_Name,'')+ISNULL(S_Middle_Name,'')+ISNULL(A.S_Last_Name,'') ApplicableName  
,(case when B.Is_Teaching_Staff=1 then 'Academic (Teaching Faculty)' else 'Non-Academic' end) ApplicableForName  
,(case when B.Is_Teaching_Staff=1 then '1' else '2' end) ApplicableForId  
from T_ERP_User A left outer join  
T_ERP_User_Brand B on A.I_User_ID=B.I_User_ID where b.I_Brand_ID=@NotificationBrandId and A.I_Status=1  
) T where T.ApplicableForId=@NotificationApplicableForID  
     
END TRY    
    
BEGIN CATCH    
 ROLLBACK TRANSACTION    
    DECLARE @ErrMsg NVARCHAR(4000),@ErrSeverity INT    
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()    
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )    
    
END CATCH    
  