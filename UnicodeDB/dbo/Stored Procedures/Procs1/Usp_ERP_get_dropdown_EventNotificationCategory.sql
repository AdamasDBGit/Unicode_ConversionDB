Create Proc Usp_ERP_get_dropdown_EventNotificationCategory(@BrandID int)  
as  
Begin  
select I_Event_Category_ID,S_Event_Category from T_Event_Category  
where I_Brand_ID =@BrandID and I_Status=1  
End