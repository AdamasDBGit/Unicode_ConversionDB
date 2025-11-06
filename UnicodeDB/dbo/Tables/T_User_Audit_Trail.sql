CREATE TABLE [dbo].[T_User_Audit_Trail] (
    [I_User_Audit_ID] INT      NOT NULL,
    [I_User_ID]       INT      NULL,
    [Dt_Login_Time]   DATETIME NULL,
    [Dt_Logout_Time]  DATETIME NULL,
    CONSTRAINT [PK__T_User_Audit_Tra__7D996BCF] PRIMARY KEY CLUSTERED ([I_User_Audit_ID] ASC)
);

