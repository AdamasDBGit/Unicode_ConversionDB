CREATE TABLE [dbo].[T_ERP_User_Password_Reset_Token] (
    [I_User_Password_Reset_Token_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_User_ID]                      INT            NOT NULL,
    [S_Token_Value]                  NVARCHAR (MAX) NOT NULL,
    [Dt_ExpiryAt]                    DATETIME       NOT NULL,
    [I_CreatedBy]                    INT            NULL,
    [Dt_CreatedAt]                   DATETIME       NULL
);

