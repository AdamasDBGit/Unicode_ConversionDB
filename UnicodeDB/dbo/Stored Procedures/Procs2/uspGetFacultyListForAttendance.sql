CREATE PROCEDURE [dbo].[uspGetFacultyListForAttendance] -- [dbo].[uspGetFacultyListForAttendance] 19,50      
    (    
      @iCenterID INT ,    
      @iModuleID INT      
    )    
AS     
    BEGIN 
    
		---Akash---
		
		DECLARE @iBrandID INT=(SELECT I_Brand_ID FROM dbo.T_Center_Hierarchy_Name_Details WHERE I_Center_ID=@iCenterID) 
		
		
		---Akash---    
      
        DECLARE @sCheckFacultyEligibility VARCHAR(20) ,    
            @iRoleID INT      
       
        SELECT  @iRoleID = ISNULL(I_Role_ID, 18)    
        FROM    dbo.T_Role_Master    
        WHERE   S_Role_Code = 'FAC'      
       
       
       
        SELECT TOP 1    
                @sCheckFacultyEligibility = ISNULL(TCC.S_Config_Value, '')    
        FROM    dbo.T_Center_Configuration TCC WITH ( NOLOCK )    
        WHERE   TCC.S_Config_Code = 'ACADEMICS_EMPLOYEE_ELIGIBILITY_ATTENDANCE'    
                --AND TCC.I_Center_ID = @iCenterID
                AND TCC.I_Brand_ID=@iBrandID  
                AND I_Status = 1      
       
        IF ( @sCheckFacultyEligibility IS NULL    
             OR @sCheckFacultyEligibility = ''    
           )     
            BEGIN      
                SELECT TOP 1    
                        @sCheckFacultyEligibility = ISNULL(TCC.S_Config_Value,    
                                                           '')    
                FROM    dbo.T_Center_Configuration TCC WITH ( NOLOCK )    
                WHERE   TCC.S_Config_Code = 'ACADEMICS_EMPLOYEE_ELIGIBILITY_ATTENDANCE'    
                        AND I_Status = 1      
            END      
       
        SELECT  TED.I_Employee_ID ,    
                TED.I_Centre_Id ,    
                TED.S_Title ,    
                --TED.S_First_Name + ' ' + TED.S_Middle_Name + ' '    
                TED.S_First_Name + ' ' + ISNULL(TED.S_Middle_Name,'') + ' '  
                + TED.S_Last_Name AS S_Faculty_Name ,    
                TUM.I_User_ID ,    
                TUM.S_Login_ID ,    
                TUM.S_User_Type ,    
                TUM.S_Email_ID ,    
                TED.I_Status,    
                TUD.S_Document_Name    
        FROM    dbo.T_Employee_Dtls TED WITH ( NOLOCK )    
                INNER JOIN dbo.T_User_Master TUM WITH ( NOLOCK ) ON TED.I_Employee_ID = TUM.I_Reference_ID    
                LEFT OUTER JOIN dbo.T_Upload_Document TUD WITH ( NOLOCK ) ON TED.I_Document_ID = TUD.I_Document_ID    
                AND TUD.I_Status = 1    
        WHERE  TED.I_Centre_Id IN (SELECT I_Center_ID FROM dbo.T_Center_Hierarchy_Name_Details TCHND WHERE I_Brand_ID=@iBrandID) 
        --TED.I_Centre_Id = @iCenterID    
                AND TED.I_Status <> 0    
                AND TUM.I_Status = 1    
                AND TUM.S_User_Type <> 'ST'    
                AND TUM.S_User_Type <> 'EM'    
                AND TED.S_First_Name <> 'DUMMY'    
                AND TED.I_Employee_ID IN ( SELECT   I_Employee_ID    
                                           FROM     EOS.T_Employee_Role_Map    
                                           WHERE    I_Role_ID = @iRoleID    
                                                    AND I_Status_ID <>0 ) --akash 4.11.2015
                AND ( @sCheckFacultyEligibility = 'No'    
                      OR TED.I_Employee_ID IN (    
                      SELECT    I_Employee_ID    
                      FROM      EOS.T_Employee_Skill_Map ESM    
                                INNER JOIN dbo.T_Module_Master MM WITH ( NOLOCK ) ON ESM.I_Skill_ID = MM.I_Skill_ID    
                      WHERE     MM.I_Module_ID = @iModuleID    
                                AND MM.I_Status = 1    
                                AND ESM.I_Status = 1 )    
                      OR TED.I_Employee_ID IN (    
                      SELECT    DISTINCT TESM.I_Employee_ID    
                      FROM      EOS.T_Employee_Skill_Map AS TESM    
                                INNER JOIN dbo.T_Employee_Dtls AS TED ON TESM.I_Employee_ID = TED.I_Employee_ID    
                      WHERE     I_Skill_ID IN (    
                                SELECT DISTINCT    
                                        TSM.I_Skill_ID    
                                FROM    dbo.T_Session_Module_Map AS TSMM    
                                        INNER JOIN dbo.T_Session_Master AS TSM ON TSMM.I_Session_ID = TSM.I_Session_ID    
                                WHERE   
                                I_Module_ID = @iModuleID  
                                AND  
                                        TSM.I_Status = 1    
                                        AND TSMM.I_Status = 1 )    
                                --AND I_Centre_Id = @iCenterID ) 
                                AND I_Centre_Id IN (SELECT I_Center_ID FROM dbo.T_Center_Hierarchy_Name_Details TCHND WHERE I_Brand_ID=@iBrandID))   
    )         
         
    END
