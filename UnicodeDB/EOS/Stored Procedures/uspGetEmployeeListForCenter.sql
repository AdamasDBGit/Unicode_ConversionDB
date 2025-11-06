/**************************************************************************************************************  
Created by  : Swagata De  
Date  : 01.05.2007  
Description : This SP will retrieve the employee list for a particular center  
Parameters  :   
Returns     : Dataset  
**************************************************************************************************************/  
  
CREATE PROCEDURE [EOS].[uspGetEmployeeListForCenter] ( @iCenterID INT )
AS 
    BEGIN  
        SELECT  TED.I_Employee_ID ,
                TED.I_Centre_Id ,
                TED.S_Title ,
                TED.S_First_Name ,
                TED.S_Middle_Name ,
                TED.S_Last_Name ,
                TUM.I_User_ID ,
                TUM.S_Login_ID ,
                TUM.S_User_Type ,
                TUM.S_Email_ID ,
                TED.I_Status
        FROM    dbo.T_Employee_Dtls TED WITH ( NOLOCK )
                INNER JOIN dbo.T_User_Master TUM WITH ( NOLOCK ) ON TED.I_Employee_ID = TUM.I_Reference_ID
                --INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TED.I_Centre_Id=TCHND.I_Center_ID
        WHERE   (TED.I_Centre_Id = @iCenterID OR TED.B_IsRoamingFaculty = 1)
                AND TED.I_Status IN ( 3, 6 )
                AND TUM.I_Status = 1
                AND TUM.S_User_Type = 'CE' 
                --AND TCHND.I_Brand_ID=(SELECT I_Brand_ID FROM dbo.T_Center_Hierarchy_Name_Details WHERE I_Center_ID=@iCenterID) 
        ORDER BY TED.S_First_Name, ISNULL(TED.S_Middle_Name,''), TED.S_Last_Name
    END
