CREATE TABLE [dbo].[T_ERP_Information_Source_Master] (
    [I_Info_Source_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Info_Source_Name] NVARCHAR (MAX) NULL,
    [I_Status]           INT            NULL,
    [S_Crtd_By]          NVARCHAR (MAX) NULL,
    [S_Upd_By]           NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]         DATETIME       NULL,
    [Dt_Upd_On]          DATETIME       NULL,
    [I_ERP_Status]       TINYINT        NULL,
    CONSTRAINT [PK__T_Information_So__5319221ERP] PRIMARY KEY CLUSTERED ([I_Info_Source_ID] ASC)
);

