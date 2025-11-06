CREATE PROCEDURE [dbo].[uspStudentLoginDetailsUpdationScript]
AS 
    BEGIN

        DECLARE @dtStartDate DATE= DATEADD(d, -1, CONVERT(DATE, GETDATE()))
        DECLARE @dtEndDate DATE= CONVERT(DATE, GETDATE())

        INSERT  INTO dbo.T_User_Role_Details
                ( I_Role_ID ,
                  I_User_ID ,
                  I_Status ,
                  S_Crtd_By ,
                  Dt_Crtd_On 
          
                )
                SELECT  16 ,
                        UserID ,
                        1 ,
                        'dba' ,
                        GETDATE()
                FROM    ( SELECT    TUM.I_User_ID AS UserID ,
                                    TURD.I_User_Role_Detail_ID AS RDID
                          FROM      dbo.T_User_Master TUM
                                    FULL OUTER JOIN dbo.T_User_Role_Details TURD ON TUM.I_User_ID = TURD.I_User_ID
                          WHERE     TUM.S_User_Type = 'ST'
                                    AND TUM.I_Status = 1
                                    AND ( TUM.Dt_Crtd_On >= @dtStartDate
                                          AND TUM.Dt_Crtd_On < @dtEndDate
                                        )
                        ) XX
                WHERE   XX.RDID IS NULL


        UPDATE  dbo.T_User_Master
        SET     S_Password = 'nEnKkpAzTK6P3avg1/PN/Q=='
        WHERE   S_User_Type = 'ST'
                AND I_Status = 1
                AND ( Dt_Crtd_On >= @dtStartDate
                      AND Dt_Crtd_On < @dtEndDate
                    )
                AND S_Password!='nEnKkpAzTK6P3avg1/PN/Q=='     

    END
