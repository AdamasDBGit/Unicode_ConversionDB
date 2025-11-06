CREATE TABLE [dbo].[T_Error_Log] (
    [I_Error_ID]          INT            IDENTITY (1, 1) NOT NULL,
    [S_Error_Number]      NVARCHAR (MAX) NULL,
    [S_Login_ID]          NVARCHAR (MAX) NULL,
    [S_Error_Description] TEXT           NULL,
    [Dt_Crtd_On]          DATETIME       NULL
);

