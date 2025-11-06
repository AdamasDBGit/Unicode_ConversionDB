Create Proc USP_ERP_Get_Dropdown_Notification_DeliveryMode  
as Begin  
select I_NotificationDelivery_ID,S_NotificationDelivery_Name  from T_ERP_NotificationDelivery  
where Is_Active=1  
End