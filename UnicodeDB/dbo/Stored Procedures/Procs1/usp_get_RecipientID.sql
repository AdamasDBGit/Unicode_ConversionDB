CREATE proc usp_get_RecipientID  
as  
begin  
  
Select 1 as value, 'Individual' as Recipient
union all
Select 0 as value , 'ALL' as Recipient
end