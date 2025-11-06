CREATE FUNCTION [dbo].[fnGetCHandHOA]  
    (  
      @iCenterId INT ,  
      @iRoleId INT            
    )  
RETURNS @UserIDTable TABLE  
    (  
      I_User_Id INT ,  
      S_Email_Id VARCHAR(200)  
    )  
AS   
    BEGIN            
            
        IF @iRoleId = 8   
            BEGIN            
        
                     
                        INSERT  INTO @UserIDTable  
                                SELECT  UHD.I_User_Id ,  
                                        UM.S_Email_Id  
                                FROM    dbo.T_Center_Hierarchy_Details CHD  
                                        INNER JOIN dbo.T_Hierarchy_Mapping_Details HMD ON CHD.I_Hierarchy_Detail_ID = HMD.I_Hierarchy_Detail_ID  
                                        INNER JOIN dbo.T_User_Hierarchy_Details UHD ON HMD.I_Hierarchy_Detail_ID = UHD.I_Hierarchy_Detail_ID  
                                        INNER JOIN dbo.T_User_Role_Details URD ON UHD.I_User_Id = URD.I_User_Id  
                                        INNER JOIN dbo.T_User_Master UM ON UHD.I_User_Id = UM.I_User_Id  
                                WHERE   URD.I_Role_Id = @iRoleId  
                                        AND CHD.I_Center_Id = @iCenterId  
                                        AND CHD.I_Status = 1  
                                        AND HMD.I_Status = 1  
                                        AND UHD.I_Status = 1  
                                        AND UM.I_Status = 1         
                          
                     
           
            
            END            
            
        ELSE   
            IF @iRoleId = 1  
                BEGIN    
      INSERT  INTO @UserIDTable  
      SELECT TUM.I_User_ID,TUM.S_Email_ID FROM dbo.T_User_Master AS TUM INNER JOIN dbo.T_User_Role_Details AS TURD  
      ON TUM.I_User_ID = TURD.I_User_ID  
      WHERE I_Role_ID = @iRoleId  
      AND TUM.I_Status = 1  
      AND TURD.I_Status = 1  
                   END   
                              
        RETURN ;            
    END