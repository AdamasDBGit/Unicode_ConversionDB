CREATE TABLE [dbo].[T_Stream_Master] (
    [I_Stream_ID]             INT            IDENTITY (1, 1) NOT NULL,
    [S_Stream_Name]           NVARCHAR (MAX) NULL,
    [I_Status]                INT            NULL,
    [S_Crtd_By]               NVARCHAR (MAX) NULL,
    [S_Upd_By]                NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]              DATETIME       NULL,
    [Dt_Upd_On]               DATETIME       NULL,
    [I_Qualification_Name_ID] INT            NULL,
    CONSTRAINT [PK__T_Stream_Master__5CA28C58] PRIMARY KEY CLUSTERED ([I_Stream_ID] ASC)
);

