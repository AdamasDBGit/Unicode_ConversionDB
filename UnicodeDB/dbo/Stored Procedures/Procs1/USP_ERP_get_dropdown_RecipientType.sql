Create Proc USP_ERP_get_dropdown_RecipientType  
as begin  
select I_NotificationApplicable_ID as RecipientTypeID  
, S_NotificationApplicable_Name as RecipientTypeName from T_ERP_NotificationApplicable  
where Is_Active=1  
End