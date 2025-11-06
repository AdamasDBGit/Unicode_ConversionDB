CREATE TABLE [dbo].[T_Country_Master] (
    [I_Country_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Country_Code] NVARCHAR (MAX) NULL,
    [S_Country_Name] NVARCHAR (MAX) NULL,
    [I_Currency_ID]  INT            NULL,
    [S_Crtd_By]      NVARCHAR (MAX) NULL,
    [S_Upd_By]       NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]     DATETIME       NULL,
    [Dt_Upd_On]      DATETIME       NULL,
    [I_Status]       INT            NULL,
    CONSTRAINT [PK__T_Country_Master__7F60ED59] PRIMARY KEY CLUSTERED ([I_Country_ID] ASC)
);

