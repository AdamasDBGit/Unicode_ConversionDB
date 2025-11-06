CREATE TABLE [dbo].[T_Brand_Master] (
    [I_Brand_ID]    INT            NOT NULL,
    [S_Brand_Code]  NVARCHAR (MAX) NULL,
    [S_Brand_Name]  NVARCHAR (MAX) NULL,
    [S_Crtd_By]     NVARCHAR (MAX) NULL,
    [S_Upd_By]      NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]    DATETIME       NULL,
    [Dt_Upd_On]     DATETIME       NULL,
    [I_Status]      INT            NULL,
    [S_Short_Code]  NVARCHAR (MAX) NULL,
    [S_CIN]         NVARCHAR (MAX) NULL,
    [S_PAN]         NVARCHAR (MAX) NULL,
    [S_location]    NVARCHAR (MAX) NULL,
    [S_Client_Name] NVARCHAR (MAX) NULL,
    [tenant_ID]     NVARCHAR (MAX) NULL,
    CONSTRAINT [PK__T_Brand_Master__6B25B5D9] PRIMARY KEY CLUSTERED ([I_Brand_ID] ASC)
);

