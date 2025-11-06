CReate Proc USP_ERP_Get_DropDown_Priority  
as begin  
select I_NotificationPriority_ID as PriorityID,S_NotificationPriority_Name as PriorityName  
from T_ERP_NotificationPriority  
where Is_Active=1  
End