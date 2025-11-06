CREATE PROCEDURE [NETWORK].[uspNotificationForNetwork]                
(                    
  @iTaskID INT                
 ,@iBrandId int           
 ,@iCenterId int = NULL          
 ,@sLoginID VARCHAR(20) = NULL              
 ,@sMessage VARCHAR(500) = NULL            
)                
AS                
BEGIN                
          
declare @min int,@max int, @iTrastDomainId int          
declare @TrustDomain table (rowid  int identity(1,1), I_TrustDomain_Id int)          
declare @userlist table (I_User_Id int)          
insert into @TrustDomain          
select I_Hierarchy_Detail_Id FROM dbo.T_Task_Hierarchy_Mapping WHERE I_Task_Master_Id = @iTaskID          
          
select @min = min(rowid), @max = max(rowid) From @TrustDomain          
while @min <= 2          
begin          
 select @iTrastDomainId = I_TrustDomain_Id from  @TrustDomain where rowid = @min        
  --ASH    
 if @iTrastDomainId = 11          
  begin          
   insert into @userlist          
   select I_User_Id from [dbo].[fnNWGetCHandASH](@iCenterId,3)          
  end      
--RSH    
else if @iTrastDomainId = 10          
  begin          
   insert into @userlist          
   select I_User_Id from [dbo].[fnNWGetCHandASH](@iCenterId,4)          
  end     
--ZSH    
else if @iTrastDomainId = 9          
  begin          
   insert into @userlist          
   select I_User_Id from [dbo].[fnNWGetCHandASH](@iCenterId,5)          
  end      
--CENTER Manager         
 else if @iTrastDomainId = 32          
  begin          
   insert into @userlist          
   select I_User_Id from [dbo].[fnNWGetCHandASH](@iCenterId,8)          
  end     
--HO Accounts     
 else if @iTrastDomainId = 29          
  begin          
   insert into @userlist          
   select I_User_Id from [dbo].[fnNWGetCHandASH](@iCenterId,11)          
  end     
--Networks manager     
else if @iTrastDomainId = 24          
  begin   
  IF (@iCenterId IS NOT NULL)  
  BEGIN   
   insert into @userlist          
   select I_User_Id from [dbo].[fnNWGetCHandASH](@iCenterId,13)  
   END  
   ELSE  
   BEGIN  
   insert into @userlist          
   select I_User_Id from [dbo].[fnGetUserForBrandAndRole](@iBrandId,13)  
    END  
   END             
--HO Academics        
else if @iTrastDomainId = 14          
  begin          
   insert into @userlist          
   select I_User_Id from [dbo].[fnNWGetCHandASH](@iCenterId,17)          
  end            
 else          
  begin          
   insert into @userlist          
   select I_User_Id from [dbo].[fnGetUserForNotification](@iTrastDomainId,@iBrandId)          
  end          
 set @min = @min + 1          
end          
          
--select distinct userid from @userlist          
            
 DECLARE @id INT            
 DECLARE @sCenterName VARCHAR(500)          
           
IF(@iCenterId IS NOT NULL)           
BEGIN          
SET @sCenterName = (SELECT s_center_name FROM T_CENTRE_MASTER WHERE I_Centre_id =@iCenterId )          
END          
ELSE          
BEGIN          
SET @sCenterName ='';          
END          
           
  IF EXISTS(select distinct I_User_Id from @userlist)                    
  BEGIN                        
   SELECT @sMessage = @sMessage + @sCenterName                               
   SET @sMessage = ISNULL(@sMessage,'Task assigned')                  
                  
   INSERT INTO dbo.T_Task_Details                    
   VALUES(@iTaskID,@sMessage,'',2,2,1,NULL,getdate(),getdate(),NULL)                        
   SET @id = SCOPE_IDENTITY()                    
                    
   INSERT INTO dbo.T_Task_Assignment                    
   SELECT @id,I_User_Id,@sLoginID           
   FROM dbo.T_User_Master WHERE I_User_Id IN            
   (            
    select distinct I_User_Id from @userlist           
   )           
          
          
--   INSERT INTO dbo.T_Task_Assignment            
--   SELECT @id,@iTaskID,@sLoginID            
--   FROM dbo.T_User_Master WHERE S_Login_Id IN            
--   (            
--    select distinct userid from @userlist           
--   )            
 --SELECT @id,I_User_Id,@sLoginID FROM [dbo].[fnGetUserForNotification_1](@iTaskID,@sRole)                 
  END             
END
