CREATE TABLE [dbo].[T_Hierarchy_Mapping_Details] (
    [I_Hierarchy_Mapping_ID]  INT            IDENTITY (1, 1) NOT NULL,
    [I_Hierarchy_Detail_ID]   INT            NULL,
    [I_Parent_ID]             INT            NULL,
    [S_Hierarchy_Chain]       VARCHAR (100)  NULL,
    [S_Hierarchy_Level_Chain] NVARCHAR (MAX) NULL,
    [Dt_Valid_From]           DATETIME       NULL,
    [Dt_Valid_To]             DATETIME       NULL,
    [I_Status]                INT            NULL,
    [S_Crtd_By]               NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]              DATETIME       NULL,
    [S_Upd_By]                NVARCHAR (MAX) NULL,
    [Dt_Upd_On]               DATETIME       NULL,
    CONSTRAINT [PK__T_Hierarchy_Mapp__123F82FA] PRIMARY KEY CLUSTERED ([I_Hierarchy_Mapping_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [index_S_Hierarchy_Chain]
    ON [dbo].[T_Hierarchy_Mapping_Details]([S_Hierarchy_Chain] ASC);

