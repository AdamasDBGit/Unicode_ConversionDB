  
--Ref#   Modified By    Modified date    Description    
-- #1    QutubHaider    17-July-2024     Arivoo SMS Monthly Task status.xlsx (sharepoint.com) #103  
-- #2    QutubHaider    19-July-2024     I have added column (unUserId) in table (T_ERP_User) for Security purpose   
  
CREATE PROCEDURE [dbo].[uspGet_ERP_UserLoginInformationAdmin]        
(        
      @vLoginID VARCHAR(200) ,        
      @vPassword NVARCHAR(200)  
)        
AS        
BEGIN         
        SET NOCOUNT ON;        
         
        DECLARE @vUserType int        
        DECLARE @vPasswordTemp NVARCHAR(200)        
        DECLARE @iUserID INT        
        DECLARE @bLDAPUser BIT        
        
        SELECT  @iUserID = I_User_ID ,        
                @vPasswordTemp = S_Password ,        
                @vUserType = I_User_Type      
        FROM    dbo.T_ERP_User        
        WHERE   S_Username = @vLoginID        
                AND I_Status = 1        
        
         
       SELECT  TOP 1 '' AS Title ,        
          @vLoginID AS LoginID ,        
          UM.S_First_Name AS FirstName ,        
          ISNULL(UM.S_Middle_Name,'') AS MiddleName ,        
          UM.S_Last_Name AS LastName ,        
          UM.S_Email AS EmailID ,        
          UM.I_User_Type AS UserType ,       
          UM.I_User_ID AS UserID,         
          BM.I_Brand_ID as BrandID,  
          BM.S_Brand_Name as BrandName,        
          ISNULL(UM.IsAllAllowedEligible,'false') as IsAllAllowedEligible,        
          BM.S_Brand_Code as BrandCode,  
          Isnull(UM.Is_Teaching_Staff,0) as D_UserType,  
       EUP.S_Photo as UserPhoto,  
       UM.isPasswordChanged, --Ref #1 QutubHaider  
       UM.unUserId --Ref #2 QutubHaider  
      FROM    
          dbo.T_ERP_User as UM        
          INNER JOIN dbo.T_ERP_User_Brand as UB on UB.I_User_ID=UM.I_User_ID        
          INNER JOIN T_Brand_Master as BM on BM.I_Brand_ID=UB.I_Brand_ID    
       LEFT JOIN  T_User_Profile as EUP on UM.I_User_ID=EUP.I_User_ID and EUP.I_Status=1  
      WHERE    
          UM.S_Username = @vLoginID  AND   
          UM.S_Password = @vPassword AND   
          UM.I_Status=1     
END 