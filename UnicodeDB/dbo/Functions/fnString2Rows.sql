CREATE FUNCTION [dbo].[fnString2Rows] (@strInput VARCHAR(MAX),@strchar VARCHAR(10))  
RETURNS @dataTab TABLE
   (
    Val    varchar(MAX)
   )

AS
BEGIN 
declare @commaPos int
declare @rowValue varchar(MAX)
declare @currLen int
declare @strSeperator varchar(10)
set @strSeperator='%'+@strchar+'%'
while (@strInput  is not null and @strInput !='' )
	begin
		select @currLen = len(@strInput)		
		select @commaPos = patindex( @strSeperator, @strInput)
	
		if (@commaPos <= 0) 
		 begin
                                           insert @dataTab values ( ltrim(rtrim(@strInput)))
			break
		end
		if (@commaPos != 1)
		begin
			select @rowValue = left(@strInput, @commaPos -1)		
			 insert @dataTab values (ltrim(rtrim(@rowValue)))
		end
		select @strInput = right(@strInput, @currLen - @commaPos)
	end
Return
END