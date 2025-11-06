CREATE TABLE [dbo].[T_Bridge_Master] (
    [I_Bridge_ID]   INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_Bridge_Code] NVARCHAR (MAX) NULL,
    [S_Bridge_Desc] NVARCHAR (MAX) NULL,
    [I_Brand_ID]    INT            NULL,
    [I_Status]      INT            NULL,
    [S_Crtd_By]     NVARCHAR (MAX) NULL,
    [S_Upd_By]      NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]    DATETIME       NULL,
    [Dt_Upd_On]     DATETIME       NULL,
    CONSTRAINT [PK_T_Bridge_Master] PRIMARY KEY CLUSTERED ([I_Bridge_ID] ASC)
);

