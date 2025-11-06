Create Proc Usp_ERP_GetDropdown_NotificationType  
as   
Begin  
Select I_NotificationType_ID as NotificationTypeID,S_NotificationType_Name as NotificationTypeName  
from T_ERP_NotificationType  
Where Is_Active=1  
  
End