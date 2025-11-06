CREATE PROCEDURE [dbo].[uspGetCenterManegerDtl]  
(  
 @iCenterID int,  
 @srole varchar(50) = null  
)  
AS  
BEGIN  
  If @iCenterID=0  
    BEGIN  
  Select * from dbo.T_User_Master USERDTL  
  inner join dbo.T_User_Role_Details USERRODTL  
  on USERDTL.I_User_ID= USERRODTL.I_User_ID   
  inner join dbo.T_Role_Master RM  
  on USERRODTL.I_Role_ID=RM.I_Role_ID   
  where  RM.S_Role_Code=@srole  
    END  
  ELSE  
   BEGIN  
  Select * from dbo.T_Employee_Dtls EMPDTL  
  inner join EOS.T_Employee_Role_Map EMPRM  
  on EMPDTL.I_Employee_ID=EMPRM.I_Employee_ID  
  inner join dbo.T_Role_Master RM  
  on EMPRM.I_Role_ID=RM.I_Role_ID   
  where EMPDTL.I_Status=3 and EMPDTL.I_Centre_Id=@iCenterID and EMPRM.I_Status_ID=1 and RM.S_Role_Code=@srole  
    END  
  
END  
  
---exec [dbo].[uspgetCenterManegerDtl] 720,'CH'  
---exec [dbo].[uspgetCenterManegerDtl] 0,'HOCC'
