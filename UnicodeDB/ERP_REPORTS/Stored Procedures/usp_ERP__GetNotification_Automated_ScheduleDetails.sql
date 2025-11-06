
CREATE PROCEDURE ERP_REPORTS.usp_ERP__GetNotification_Automated_ScheduleDetails    
    @BrandID INT,    
    @NotificationScheduleType VARCHAR(100)='AUTOMATED',    
    @NotificationTypeID INT = NULL,    
    @NotificationCategoryID INT = NULL,    
    @DeliveryModeID INT = NULL,    
    @ScheduleFromdate DATE = NULL,    
    @ScheduleTodate DATE = NULL,    
    @PriorityID INT = NULL,    
    @RecipientTypeID INT = NULL,  
 @Frequency varchar(100)=NULL,  
 @statusID int =NULL  
   -- @Recipient_SelectionID INT = NULL    
AS    
BEGIN    
    SET NOCOUNT ON;    
    
   
    Begin    
        ;WITH DeliveryID_CTE AS (    
            SELECT     
                ENS.inNotificationScheduleID,    
                ROW_NUMBER() OVER (PARTITION BY ENS.inNotificationScheduleID ORDER BY (SELECT NULL)) AS RowNum,     
                value AS DeliveryID     
            FROM T_ERP_Notification_Schedule ENS    
            CROSS APPLY ERP_SplitString(ENS.stDeliveryChannelId, ',')    
        ),    
        DeliveryName_CTE AS (    
            SELECT     
                ENS.inNotificationScheduleID,    
                ROW_NUMBER() OVER (PARTITION BY ENS.inNotificationScheduleID ORDER BY (SELECT NULL)) AS RowNum,     
                value AS DeliveryName     
            FROM T_ERP_Notification_Schedule ENS    
            CROSS APPLY ERP_SplitString(ENS.stDeliveryChannelName, ',')    
        )    
    
        SELECT     
            ENS.stNotificationType,     
            ENS.inNotificationScheduleID AS Notification_ID,       
            ENS.inTypeId AS Notification_TypeID,    
            ENS.stTypeName AS Notification_Type,    
            ENS.inCategoryId AS CategoryID,    
            ENS.stCategoryName AS Category,    
            ENS.inPriorityId AS PriorityID,    
            ENS.stPriorityName AS Priority,    
            DeliveryID_CTE.DeliveryID AS DeliveryID,    
            DeliveryName_CTE.DeliveryName AS DeliveryModeName,    
            ENS.inRecipientID AS RecipientID,    
            ENS.stRecipientName AS RecipientName,    
            ENS.stForAllOrIndividual AS RecipientSelectionID,    
            CASE     
                WHEN ENS.stForAllOrIndividual = 0 THEN 'ALL'     
                ELSE 'Individual'     
            END AS Recipient_Selection,    
           CAST(ENS.dtStartDate AS DATE) AS Schedule_Start_Date,   
     CAST(ENS.dtEndDate AS DATE) AS Schedule_END_Date,    
            ENS.stTemplateTitle AS Message_Content,    
            CASE     
                WHEN ENS.stEmailAttachment IS NOT NULL THEN 'Yes'     
                ELSE 'No'     
            END AS Is_Attachment_Present,    
            CONCAT(BSD.ServerURL, '\', REPLACE(ENS.stEmailAttachment, '\', '/')) AS Email_Attachment,    
            Noti_TotRecp_Count.Total_Recipients,    
            ISNULL(Noti_sent.Total_Sent, 0) AS Total_Sent,    
            ISNULL(Tot_Deliver.Total_Deliver, 0) AS Total_Delivered,    
            ISNULL(Tot_Failed.Total_Failed, 0) AS Total_Failed,    
            CASE     
                WHEN EU.S_Middle_Name IS NULL OR EU.S_Middle_Name = ''     
                THEN EU.S_First_Name + ' ' + EU.S_Last_Name     
                ELSE EU.S_First_Name + ' ' + EU.S_Middle_Name + ' ' + EU.S_Last_Name     
            END AS Created_By,    
            CONVERT(DATE, ENS.dtCreatedDate) AS Created_Date,    
            ENL.stStudentId AS StudentID,    
            ENL.stStudentName    
        FROM T_ERP_Notification_Schedule ENS    
        LEFT JOIN (    
            SELECT COUNT(inNotificationLogsID) AS Total_Recipients, inNotificationScheduleID    
            FROM T_ERP_Notification_Schedule_Logs     
            GROUP BY inNotificationScheduleID    
        ) AS Noti_TotRecp_Count ON Noti_TotRecp_Count.inNotificationScheduleID = ENS.inNotificationScheduleID    
    
        LEFT JOIN (    
            SELECT COUNT(inNotificationLogsID) AS Total_Sent, inNotificationScheduleID    
            FROM T_ERP_Notification_Schedule_Logs     
            GROUP BY inNotificationScheduleID    
        ) AS Noti_sent ON Noti_sent.inNotificationScheduleID = ENS.inNotificationScheduleID    
    
        LEFT JOIN (    
            SELECT COUNT(inNotificationLogsID) AS Total_Deliver, inNotificationScheduleID    
 FROM T_ERP_Notification_Schedule_Logs     
            WHERE insendstatus = 1    
            GROUP BY inNotificationScheduleID    
        ) AS Tot_Deliver ON Tot_Deliver.inNotificationScheduleID = ENS.inNotificationScheduleID    
    
        LEFT JOIN (    
            SELECT COUNT(inNotificationLogsID) AS Total_Failed, inNotificationScheduleID    
            FROM T_ERP_Notification_Schedule_Logs     
            WHERE insendstatus = 2    
            GROUP BY inNotificationScheduleID    
        ) AS Tot_Failed ON Tot_Failed.inNotificationScheduleID = ENS.inNotificationScheduleID    
    
        LEFT JOIN T_ERP_USER EU ON EU.I_User_ID = ENS.inCreatedBy    
        LEFT JOIN DeliveryID_CTE ON ENS.inNotificationScheduleID = DeliveryID_CTE.inNotificationScheduleID     
        LEFT JOIN DeliveryName_CTE ON     
            DeliveryID_CTE.inNotificationScheduleID = DeliveryName_CTE.inNotificationScheduleID     
            AND DeliveryID_CTE.RowNum = DeliveryName_CTE.RowNum    
        LEFT JOIN T_ERP_Brand_ServerDetrails BSD ON BSD.BrandID = @BrandID    
        INNER JOIN T_ERP_Notification_Schedule_Logs ENL ON ENL.inNotificationScheduleID = ENS.inNotificationScheduleID    
        WHERE ENS.inBrandId = @BrandID     
        AND ENS.stNotificationType = @NotificationScheduleType    
        AND (@NotificationTypeID IS NULL OR ENS.inTypeID = @NotificationTypeID)    
        AND (@NotificationCategoryID IS NULL OR ENS.inCategoryId = @NotificationCategoryID)    
        AND (@DeliveryModeID IS NULL OR DeliveryID_CTE.DeliveryID = @DeliveryModeID)    
        AND (@PriorityID IS NULL OR ENS.inPriorityId = @PriorityID)    
        AND (@RecipientTypeID IS NULL OR ENS.inRecipientID = @RecipientTypeID)    
       -- AND (@Recipient_SelectionID IS NULL OR ENS.stForAllOrIndividual = @Recipient_SelectionID)    
        AND CONVERT(DATE, ENS.dtStartDate) >=@ScheduleFromdate and  Convert(date,ENS.dtEndDate )<=@ScheduleTodate  
    END    
   
END