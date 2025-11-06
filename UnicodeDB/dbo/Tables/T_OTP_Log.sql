CREATE TABLE [dbo].[T_OTP_Log] (
    [I_User_ID]        INT            NOT NULL,
    [S_User_Role_Type] NVARCHAR (MAX) NULL,
    [S_Mobile_No]      NVARCHAR (50)  NULL,
    [S_OTP]            NVARCHAR (MAX) NULL,
    [Dt_Created_On]    DATETIME       NULL
);

