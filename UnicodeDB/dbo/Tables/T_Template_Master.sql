CREATE TABLE [dbo].[T_Template_Master] (
    [I_Template_ID]          INT            IDENTITY (1, 1) NOT NULL,
    [S_Template_Code]        NVARCHAR (MAX) NOT NULL,
    [S_Template_Type]        SMALLINT       NOT NULL,
    [S_Template_Description] NVARCHAR (MAX) NULL,
    [S_File_Location]        NVARCHAR (MAX) NULL,
    [I_Status]               INT            NOT NULL,
    [S_Crtd_By]              NVARCHAR (MAX) NULL,
    [S_Upd_By]               NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]             DATETIME       NULL,
    [Dt_Upd_On]              DATETIME       NULL,
    CONSTRAINT [PK_dbo.T_Template_Master] PRIMARY KEY CLUSTERED ([I_Template_ID] ASC)
);

