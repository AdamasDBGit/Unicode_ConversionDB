CREATE PROCEDURE [dbo].[uspGetTaskForUser]
    (
      @iUserID INT ,
      @sLoginID VARCHAR(200)
    )
AS
    BEGIN 
        SELECT  TD.* ,
                TM.S_URL ,
                TM.I_Type ,
                UM.S_First_Name + ' ' + ISNULL(UM.S_Middle_Name, '') + ' '
                + ISNULL(UM.S_Last_Name, '') AS FromName
        FROM    dbo.T_Task_Details TD
                INNER JOIN [dbo].[T_Task_Assignment] TA ON TD.I_Task_Details_Id = TA.I_Task_ID
                INNER JOIN dbo.T_Task_Master TM ON TD.I_Task_Master_Id = TM.I_Task_Master_Id
                INNER JOIN dbo.T_User_Master UM ON TA.S_From_User = UM.S_Login_ID
        WHERE   TA.I_To_User_ID = @iUserID 
--AND TD.I_Status NOT IN (4,5,0)
                AND TD.I_Status NOT IN ( 0 )
                AND DATEDIFF(D, TD.Dt_Due_date, GETDATE()) <= 5
                AND TM.S_Description <> 'Pending center transfer request for ~'
                AND DATEDIFF(d,TD.Dt_Created_Date,GETDATE())<30
                --AND (SELECT TUM.I_User_ID FROM dbo.T_User_Master AS TUM WHERE TUM.S_Login_ID=TA.S_From_User)!=TA.I_To_User_ID
        UNION
        SELECT  TD.* ,
                TM.S_URL ,
                TM.I_Type ,
                UM.S_First_Name + ' ' + ISNULL(UM.S_Middle_Name, '') + ' '
                + ISNULL(UM.S_Last_Name, '') AS FromName
        FROM    dbo.T_Task_Details TD
                INNER JOIN [dbo].[T_Task_Assignment] TA ON TD.I_Task_Details_Id = TA.I_Task_ID
                INNER JOIN dbo.T_Task_Master TM ON TD.I_Task_Master_Id = TM.I_Task_Master_Id
                INNER JOIN dbo.T_User_Master UM ON TA.S_From_User = UM.S_Login_ID
        WHERE   TA.I_To_User_ID = @iUserID 
--AND TD.I_Status NOT IN (4,5,0) 
                AND TD.I_Status NOT IN ( 0 )
                AND TM.S_Description = 'Pending center transfer request for ~'
                AND DATEDIFF(d,TD.Dt_Created_Date,GETDATE())<30
                --AND (SELECT TUM.I_User_ID FROM dbo.T_User_Master AS TUM WHERE TUM.S_Login_ID=TA.S_From_User)!=TA.I_To_User_ID
        ORDER BY TD.I_Task_Details_Id DESC 

        SELECT  UM.S_First_Name + ' ' + ISNULL(UM.S_Middle_Name, '') + ' '
                + ISNULL(UM.S_Last_Name, '') AS ToName ,
                TD.* ,
                TM.I_Type ,
                '' AS S_URL
        FROM    dbo.T_Task_Details TD
                INNER JOIN [dbo].[T_Task_Assignment] TA ON TD.I_Task_Details_Id = TA.I_Task_ID
                INNER JOIN dbo.T_Task_Master TM ON TD.I_Task_Master_Id = TM.I_Task_Master_Id
                INNER JOIN dbo.T_User_Master UM ON TA.I_To_User_ID = UM.I_User_ID
        WHERE   TA.S_From_User LIKE @sLoginID 
--AND TD.I_Status NOT IN (4,5,0) 
                AND TD.I_Status NOT IN ( 0 )
                AND DATEDIFF(D, TD.Dt_Due_date, GETDATE()) <= 5
                AND TM.S_Description <> 'Pending center transfer request for ~'
                AND DATEDIFF(d,TD.Dt_Created_Date,GETDATE())<30
                --AND (SELECT TUM.I_User_ID FROM dbo.T_User_Master AS TUM WHERE TUM.S_Login_ID=TA.S_From_User)!=TA.I_To_User_ID
        UNION
        SELECT  UM.S_First_Name + ' ' + ISNULL(UM.S_Middle_Name, '') + ' '
                + ISNULL(UM.S_Last_Name, '') AS ToName ,
                TD.* ,
                TM.I_Type ,
                '' AS S_URL
        FROM    dbo.T_Task_Details TD
                INNER JOIN [dbo].[T_Task_Assignment] TA ON TD.I_Task_Details_Id = TA.I_Task_ID
                INNER JOIN dbo.T_Task_Master TM ON TD.I_Task_Master_Id = TM.I_Task_Master_Id
                INNER JOIN dbo.T_User_Master UM ON TA.I_To_User_ID = UM.I_User_ID
        WHERE   TA.S_From_User LIKE @sLoginID 
--AND TD.I_Status NOT IN (4,5,0) 
                AND TD.I_Status NOT IN ( 0 )
                AND TM.S_Description = 'Pending center transfer request for ~'
                AND DATEDIFF(d,TD.Dt_Created_Date,GETDATE())<30
                --AND (SELECT TUM.I_User_ID FROM dbo.T_User_Master AS TUM WHERE TUM.S_Login_ID=TA.S_From_User)!=TA.I_To_User_ID
        ORDER BY TD.I_Task_Details_Id DESC 
    END
