-- =============================================    
-- Author:  Indranil Bhattacharya   
-- Create date: 12/05/2012    
--Comments   : Further details such as course details can be retrieved later    
-- =============================================    
CREATE PROCEDURE [dbo].[uspGetCenterEmployeeDetails] --[dbo].[uspGetCenterEmployeeDetails] 19,18    
    (
      @ICenterID INT ,    
      @IRoleID INT
    )
AS 
    BEGIN
        SELECT  TED.S_First_Name ,
                TED.S_Middle_Name ,
                TED.S_Last_Name ,
                TED.I_Employee_ID
        FROM    dbo.T_Employee_Dtls AS TED
                INNER JOIN EOS.T_Employee_Role_Map AS TERM ON TED.I_Employee_ID = TERM.I_Employee_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TED.I_Centre_Id=TCHND.I_Center_ID--akash
        WHERE   (I_Centre_Id = @ICenterID OR TED.B_IsRoamingFaculty = 1)
                AND I_Role_ID = @IRoleID
                AND TED.I_Status = 3 
                AND I_Brand_ID=(SELECT I_Brand_ID FROM dbo.T_Center_Hierarchy_Name_Details WHERE I_Center_ID=@ICenterID)--akash
    END
