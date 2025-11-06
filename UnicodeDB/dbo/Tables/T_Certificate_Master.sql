CREATE TABLE [dbo].[T_Certificate_Master] (
    [I_Certificate_ID]          INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]                INT            NULL,
    [I_Template_ID]             INT            NULL,
    [S_Certificate_Name]        NVARCHAR (MAX) NULL,
    [S_Certificate_Description] NVARCHAR (MAX) NULL,
    [S_Certificate_Type]        NVARCHAR (MAX) NULL,
    [I_Status]                  INT            NULL,
    [S_Crtd_By]                 NVARCHAR (MAX) NULL,
    [S_Upd_By]                  NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                DATETIME       NULL,
    [Dt_Upd_On]                 DATETIME       NULL,
    CONSTRAINT [PK__T_Certificate_Ma__1B93E30A] PRIMARY KEY CLUSTERED ([I_Certificate_ID] ASC)
);

