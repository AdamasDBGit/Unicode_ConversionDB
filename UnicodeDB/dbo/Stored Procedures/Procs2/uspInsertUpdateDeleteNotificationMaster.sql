 
CREATE PROCEDURE [dbo].[uspInsertUpdateDeleteNotificationMaster]   
(  
	 @iMode int =0,  
	 @iAcademicSessionID int = null,  
	 @iBrandID int = null,  
	 @iNotificationTypeID int =null,  
	 @iNotificationCategoryID int = null,  
	 @iNotificationPriorityID int=null,  
	 @dNotificationDate datetime=null,  
	 @tNotificationTime time = null,  
	 @sNotificationTitle NVARCHAR(max)=null,
	 @sNotificationDesc NVARCHAR(max)=null,
	 @iCreatedBy int=null,
	 @dCreatedDate datetime=null,
	 @iUpdatedBy int=null,
	 @dUpdatedDate datetime=null,
	 @iIsActive bit,
	 @iIsDeleted bit,
	 @UTNotificationComponents UT_NotificationComponents readonly  
)  
AS  
begin transaction  
BEGIN TRY   
 IF(@iMode>0)  
 BEGIN  
  
     SELECT 1 StatusFlag,'Notification deleted successfully' Message  
 END  
 ELSE  
  BEGIN     
     BEGIN  
      INSERT INTO T_ERP_NotificationMaster  
      (  
         Notification_AcademicSessionID
		,Notification_Title
		,Notification_Desc
		,Notification_Type
		,Notification_BrandID
		,Notification_EventID
		,Notification_PriorityID
		,Notification_Date
		,Notification_Time
		,Created_By
		,Created_Date
		,Updated_By
		,Updated_Date
		,IssActive
		,Is_Deleted  
      )  
      VALUES  
      (  
        @iAcademicSessionID 
	   ,@sNotificationTitle 
	   ,@sNotificationDesc 	     
	   ,@iNotificationTypeID
	   ,@iBrandID
	   ,@iNotificationCategoryID
	   ,@iNotificationPriorityID
	   ,@dNotificationDate
	   ,@tNotificationTime  	   
	   ,@iCreatedBy 
	   ,@dCreatedDate
	   ,@iUpdatedBy
	   ,@dUpdatedDate
	   ,@iIsActive
	   ,@iIsDeleted    
      )  

      DECLARE @I_Notification_ID bigint  
      SET @I_Notification_ID = SCOPE_IDENTITY();
	  
  
      INSERT INTO T_ERP_NotificationDetails  
      (  
        Notification_ID
	   ,Notification_ApplicableForID
	   ,Notification_ApplicableID
	   ,Notification_ClassGroupID
	   ,Notification_ClassID
	   ,Notification_StreamID
	   ,Notification_SectionID
	   ,Notification_StudentID
	   ,Notification_DeliveryMethod
	   ,Notification_Attachments
      )  
      SELECT @I_Notification_ID 
	  ,Notification_ApplicableForID
      ,Notification_ApplicableID
      ,Notification_ClassGroupID
      ,Notification_ClassID
      ,Notification_StreamID
      ,Notification_SectionID
      ,Notification_StudentID
      ,Notification_DeliveryMethod
      ,Notification_Attachments
	  from @UTNotificationComponents  

	  update T_ERP_NotificationMaster set Notification_EventID=1 where Notification_ID=@I_Notification_ID
	  update T_ERP_NotificationDetails set Notification_DeliveryMethod=1 where Notification_ID=@I_Notification_ID
  
      SELECT 1 StatusFlag,'Notification save successfully' Message  
     END  
  END  
END TRY  
BEGIN CATCH  
 rollback transaction  
 DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity int  
  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
select 0 StatusFlag,@ErrMsg Message  
END CATCH  
commit transaction 

