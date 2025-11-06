CREATE TABLE [dbo].[T_Upload_Document] (
    [I_Document_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Document_Name] NVARCHAR (MAX) NULL,
    [S_Document_Type] NVARCHAR (MAX) NULL,
    [S_Document_Path] NVARCHAR (MAX) NULL,
    [S_Document_URL]  NVARCHAR (MAX) NULL,
    [I_Status]        INT            NULL,
    [S_Crtd_By]       NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]      DATETIME       NULL,
    [S_Upd_By]        NVARCHAR (MAX) NULL,
    [Dt_Upd_On]       DATETIME       NULL,
    CONSTRAINT [PK_T_Upload_Document] PRIMARY KEY CLUSTERED ([I_Document_ID] ASC)
);

