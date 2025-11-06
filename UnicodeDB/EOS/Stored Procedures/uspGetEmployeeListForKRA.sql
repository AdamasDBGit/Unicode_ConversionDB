/**************************************************************************************************************
Created by  : Swagata De
Date		: 21.06.2007
Description : This SP will retrieve the employee list for KRA assignment
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspGetEmployeeListForKRA]
    (
      @iCenterID INT = NULL ,
      @iUserID INT
    )
AS 
    BEGIN
        SELECT  DISTINCT
                TURD.I_User_ID ,
                TED.I_Employee_ID ,
                TED.S_Emp_ID ,
                TED.S_Title ,
                TED.S_First_Name ,
                TED.S_Middle_Name ,
                TED.S_Last_Name ,
                TED.S_Email_ID
        FROM    dbo.T_User_Role_Details TURD WITH ( NOLOCK )
                INNER JOIN EOS.T_Role_Assessor TRA ON TURD.I_Role_ID = TRA.I_Role_ID
                INNER JOIN dbo.T_User_Master TUM WITH ( NOLOCK ) ON TUM.I_User_ID = TURD.I_User_ID
                INNER JOIN dbo.T_Employee_Dtls TED WITH ( NOLOCK ) ON TUM.I_Reference_ID = TED.I_Employee_ID
        WHERE   TRA.I_Assessor_Role_ID IN (
                SELECT  I_Role_ID
                FROM    dbo.T_User_Role_Details WITH ( NOLOCK )
                WHERE   I_User_ID = @iUserID
                        AND I_Status = 1 )
                AND TED.I_Centre_ID = ISNULL(@iCenterID, TED.I_Centre_ID)
                AND TED.I_Status <> 0
                AND TED.I_Status <> 4
                AND TED.I_Status <> 1
                AND TUM.I_Status <> 0
                AND TUM.S_User_Type <> 'ST'
                AND TUM.S_User_Type <> 'EM'
        ORDER BY TED.S_First_Name ,
                TED.S_Middle_Name,
                TED.S_Last_Name
    END
