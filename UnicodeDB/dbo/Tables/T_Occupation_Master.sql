CREATE TABLE [dbo].[T_Occupation_Master] (
    [I_Occupation_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Occupation_Name] NVARCHAR (MAX) NULL,
    [I_Status]          INT            NULL,
    [S_Crtd_By]         NVARCHAR (MAX) NULL,
    [S_Upd_By]          NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]        DATETIME       NULL,
    [Dt_Upd_On]         DATETIME       NULL,
    CONSTRAINT [PK__T_Occupation_Mas__525A080F] PRIMARY KEY CLUSTERED ([I_Occupation_ID] ASC)
);

