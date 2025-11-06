CREATE function [dbo].[fnISZERO]  
(  
@iValue numeric(18,2)  
)  
returns numeric(18,2)  
as  
begin  
 if @iValue = 0  
 begin  
  set @iValue = 1  
 end  
return @iValue  
end