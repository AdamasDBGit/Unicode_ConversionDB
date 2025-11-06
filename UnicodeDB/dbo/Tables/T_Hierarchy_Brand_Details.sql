CREATE TABLE [dbo].[T_Hierarchy_Brand_Details] (
    [I_Hierarchy_Brand_ID]  INT            IDENTITY (1, 1) NOT NULL,
    [I_Hierarchy_Master_ID] INT            NULL,
    [I_Brand_ID]            INT            NULL,
    [I_Status]              INT            NULL,
    [Dt_Crtd_On]            DATETIME       NULL,
    [Dt_Upd_On]             CHAR (18)      NULL,
    [S_Crtd_By]             NVARCHAR (MAX) NULL,
    [S_Upd_By]              NVARCHAR (MAX) NULL,
    [Dt_Valid_From]         DATETIME       NULL,
    [Dt_Valid_To]           DATETIME       NULL,
    CONSTRAINT [PK__T_Hierarchy_Bran__00DFECCE] PRIMARY KEY CLUSTERED ([I_Hierarchy_Brand_ID] ASC)
);

