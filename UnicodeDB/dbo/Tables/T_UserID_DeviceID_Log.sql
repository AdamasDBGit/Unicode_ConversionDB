CREATE TABLE [dbo].[T_UserID_DeviceID_Log] (
    [I_User_ID]        INT            NOT NULL,
    [S_User_Role_Type] NVARCHAR (MAX) NULL,
    [S_Mobile_No]      NVARCHAR (50)  NULL,
    [DeviceId]         NVARCHAR (MAX) NULL,
    [Dt_Created_On]    DATETIME       NULL
);

