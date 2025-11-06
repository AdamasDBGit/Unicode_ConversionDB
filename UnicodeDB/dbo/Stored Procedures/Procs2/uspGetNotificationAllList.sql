

CREATE PROCEDURE [dbo].[uspGetNotificationAllList]  
(  
@NotificationAcademicSessionId int  
,@NotificationBrandId int
)  
  
AS   
  
BEGIN TRY  
  
    SET NoCount ON ;  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  
  
select distinct asm.S_Label as [SchoolSessionName]
,(case when nd.Notification_ApplicableForID=napl.I_NotificationApplicable_ID then napl.S_NotificationApplicable_Name else 'All' end) ApplicationForName
,tec.S_Event_Category as [EventCategoryName]
,np.S_NotificationPriority_Name as [NotificationPriorityName]
,ndm.S_NotificationDelivery_Name as [NotificationDeliveryName]
,nm.Notification_Title as [NotificationTitle]
--,nm.Notification_Desc as [NotificationDescription]
,SUBSTRING(nm.notification_desc, 1, 30)  as [NotificationDescription]
,convert(varchar,nm.Notification_Date,106) as [NotificationDate]
,(case when nm.Notification_Date >= GETDATE() then 'Upcoming' else 'Closed' end) NotificationStatus
,nm.IssActive as [Active]
,nm.Notification_ID as [NotificationID]
from T_ERP_NotificationMaster nm
inner join T_ERP_NotificationDetails nd on nm.Notification_ID=nd.Notification_ID
inner join T_School_Academic_Session_Master asm on nm.Notification_AcademicSessionID=asm.I_School_Session_ID
left join T_ERP_NotificationApplicable napl on nd.Notification_ApplicableForID=napl.I_NotificationApplicable_ID
left join T_Event_Category tec on nm.Notification_EventID=tec.I_Event_Category_ID
left join T_ERP_NotificationPriority np on nm.Notification_PriorityID=np.I_NotificationPriority_ID
left join T_ERP_NotificationDelivery ndm on nm.Notification_PriorityID=ndm.I_NotificationDelivery_ID
where nm.Notification_AcademicSessionID=@NotificationAcademicSessionId and nm.Notification_BrandID=@NotificationBrandId 
--and nm.Notification_Date >= GETDATE() 
and nm.Is_Deleted=0
order by NotificationStatus desc   
END TRY  
  
BEGIN CATCH  
 ROLLBACK TRANSACTION  
    DECLARE @ErrMsg Nnvarchar(max),@ErrSeverity INT  
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()  
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )  
  
END CATCH  


