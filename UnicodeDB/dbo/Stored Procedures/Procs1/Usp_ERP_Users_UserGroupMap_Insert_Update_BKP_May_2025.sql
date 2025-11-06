
  
CREATE PROCEDURE [dbo].[Usp_ERP_Users_UserGroupMap_Insert_Update_BKP_May_2025]                
    @User_Group_Role_Map_ID bigint=Null ,            
   -- @User_ID Bigint null,   
 --@GroupID int=Null, 
    @IsFromUser int=null,  -----If 1 Then from User ,If 2 from Group
    @BrandID int,                
    @Is_Active bit null,              
    @CreatedBy  int,              
    @UT_UserGroup [UT_User_Group] READONLY              
                
AS                
BEGIN                
SET NOCOUNT ON;                       
--------------------------------     
Declare @c_GroupID int,@c_User_ID Bigint,@user_id bigint,@groupID int  
SET @c_User_ID=(select COUNT(distinct I_User_ID) from @UT_UserGroup)  
SET @c_GroupID=(select COUNT(distinct I_User_Group_Master_ID) from @UT_UserGroup)  
If @IsFromUser=1   
Begin  
Set @user_id=(select distinct I_User_ID from @UT_UserGroup)  
Print @user_id   
End   
Else if @IsFromUser=2
Begin  
set @groupID=(select distinct   I_User_Group_Master_ID from @UT_UserGroup)  
Print @groupID  
End   
  
Create Table #Userpermission(        
-- I_Users_Role_Permission_MapID int        
 I_User_Id int        
,Role_Id int        
,Permission_ID int        
,User_Group_ID int        
,Brand_ID int        
,Is_Active bit        
)        
     
---------------------------------------------        
      
 Insert Into #Userpermission(  
  
 I_User_Id         
,Role_Id         
,Permission_ID         
,User_Group_ID         
,Brand_ID         
,Is_Active    
 )  
Select    
distinct  
--URPM.I_Users_Role_Permission_MapID,  
UT.I_User_ID,UGR.I_Role_ID,  
PRM.I_Permission_ID,UGR.I_User_Group_Master_ID,@BrandID,UT.Is_Active  
  
from @UT_UserGroup UT  
Inner Join T_ERP_UserGroup_Role_Brand_Map UGR  
on UGR.I_User_Group_Master_ID=UT.I_User_Group_Master_ID  
Inner Join T_ERP_Permission_Role_Map PRM on PRM.I_Role_ID=UGR.I_Role_ID  
  
--Left Join T_ERP_Users_Role_Permission_Map URPM on URPM.Permission_ID =PRM.I_Permission_ID   
--and URPM.Role_Id =PRM.I_Role_ID and URPM.User_Group_ID=UT.I_User_Group_Master_ID  
--and URPM.I_User_Id=UT.I_User_ID  
where PRM.I_Status=1 and UGR.Is_Active=1  
and UGR.I_Brand_ID=@BrandID 
order by UT.I_User_ID  
              
     BEGIN TRY                
        BEGIN TRANSACTION;                
 --                       
  
----------User Permission Map-------------------------------------------------------  
If @IsFromUser=1  
  
BEGIN----For User to Group  
MERGE INTO T_ERP_Users_Role_Permission_Map AS target                
        Using #Userpermission AS Source                
        ON            
 target.I_User_ID = Source.I_User_Id   and   
 target.Role_Id=Source.Role_Id             
    And Target.Permission_ID=Source.Permission_ID    
 and Target.User_Group_ID=Source.User_Group_ID  
 --and Target.Is_Active=Source.Is_Active  
 and target.Brand_ID=Source.Brand_ID  
 --and target.I_Users_Role_Permission_MapID=Source.I_Users_Role_Permission_MapID  
        WHEN MATCHED  THEN                
            UPDATE SET Is_Active = 1               
                                   
        WHEN NOT MATCHED    THEN                
            INSERT                
            (                
               --I_Users_Role_Permission_MapID  
                I_User_Id  
               ,Role_Id  
               ,Permission_ID  
               ,User_Group_ID  
               ,Brand_ID  
               ,Is_Active  
               ,I_Created_By  
               ,dt_Created_Dt  
               ,Dt_Modified_Dt           
            )                
            Values                
            (Source.I_User_Id                
           , Source.Role_Id                
           , Source.Permission_ID   
           ,Source.User_Group_ID  
           ,Source.Brand_ID  
     ,1  
     ,@CreatedBy  
     ,Getdate()  
     ,Null  
            )             
        WHEN NOT MATCHED BY SOURCE and target.I_User_Id  =@User_ID and target.Brand_ID=@BrandID
              
  THEN                
            Update SET Is_Active = 0   
   ,Dt_Modified_Dt=getdate()  
    
   ;  
   End  
   Else If @IsFromUser=2 
   Begin-----For Group to User  
   MERGE INTO T_ERP_Users_Role_Permission_Map AS target                
        Using #Userpermission AS Source                
        ON            
    target.I_User_ID = Source.I_User_Id   and   
 target.Role_Id=Source.Role_Id             
    And Target.Permission_ID=Source.Permission_ID    
 and Target.User_Group_ID=Source.User_Group_ID  
 --and Target.Is_Active=Source.Is_Active  
 and target.Brand_ID=Source.Brand_ID  
 --and target.I_Users_Role_Permission_MapID=Source.I_Users_Role_Permission_MapID  
        WHEN MATCHED  THEN                
            UPDATE SET Is_Active = 1               
                                   
        WHEN NOT MATCHED    THEN                
            INSERT                
            (                
               --I_Users_Role_Permission_MapID  
                I_User_Id  
               ,Role_Id  
               ,Permission_ID  
               ,User_Group_ID  
               ,Brand_ID  
               ,Is_Active  
               ,I_Created_By  
               ,dt_Created_Dt  
               ,Dt_Modified_Dt           
            )                
            Values                
            (Source.I_User_Id                
           , Source.Role_Id                
           , Source.Permission_ID   
     ,Source.User_Group_ID  
     ,Source.Brand_ID  
     ,1  
     ,@CreatedBy  
     ,Getdate()  
     ,Null  
            )             
        WHEN NOT MATCHED BY SOURCE and target.User_Group_ID  =@GroupID  
              
  THEN                
            Update SET Is_Active = 0   
           ,Dt_Modified_Dt=getdate()  
    
   ;  
   End   
  
     
  
 select 1    StatusFlag  , 'User-Group/Role Mapped' Message   
  
  
------------------End----------------------------------------------  
                
                
        COMMIT;          
    END TRY                
    BEGIN CATCH                
        IF @@TRANCOUNT > 0                
            ROLLBACK;                
DECLARE @ErrorMessage NVARCHAR(max);              
        SET @ErrorMessage = ERROR_MESSAGE();        
        -- Log the error message or handle it as needed              
              
        -- Raise an error to indicate the failure          
        Select @ErrorMessage as Message              
    END CATCH                
End

