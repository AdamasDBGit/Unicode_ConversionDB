CREATE PROCEDURE [SMManagement].[GetUserInfo] ( @UserID INT )
AS
    BEGIN

        DECLARE @AccessRight VARCHAR(MAX)= NULL



        SELECT  @AccessRight = 'Admin'
        FROM    dbo.T_User_Role_Details AS TURD
                INNER JOIN dbo.T_Role_Master AS TRM ON TRM.I_Role_ID = TURD.I_Role_ID
        WHERE   TURD.I_Status = 1
                AND TRM.I_Role_ID = 1
                AND TURD.I_User_ID = @UserID

        IF @AccessRight IS NULL
            SELECT  @AccessRight = 'CH'
            FROM    dbo.T_User_Role_Details AS TURD
                    INNER JOIN dbo.T_Role_Master AS TRM ON TRM.I_Role_ID = TURD.I_Role_ID
            WHERE   TURD.I_Status = 1
                    AND TRM.I_Role_ID = 8
                    AND TURD.I_User_ID = @UserID

        IF @AccessRight IS NULL
            SELECT  @AccessRight = 'CW'
            FROM    dbo.T_User_Role_Details AS TURD
                    INNER JOIN dbo.T_Role_Master AS TRM ON TRM.I_Role_ID = TURD.I_Role_ID
            WHERE   TURD.I_Status = 1
                    AND TRM.I_Role_ID = 40
                    AND TURD.I_User_ID = @UserID
                    
        SELECT  TUHD.I_User_ID ,
                @AccessRight AS AccessRight ,
                MIN(TUHD.I_Hierarchy_Detail_ID) AS HierarchyDetailID
        FROM    dbo.T_User_Hierarchy_Details AS TUHD
        WHERE   TUHD.I_User_ID = @UserID
                AND TUHD.I_Hierarchy_Master_ID = 4
                AND TUHD.I_Status = 1
        GROUP BY TUHD.I_User_ID            



    END
