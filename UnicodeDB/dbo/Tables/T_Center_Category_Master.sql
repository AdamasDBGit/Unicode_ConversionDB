CREATE TABLE [dbo].[T_Center_Category_Master] (
    [I_Center_Category_ID]   INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_Center_Category_Name] NVARCHAR (MAX) NULL,
    [I_Status]               INT            NULL,
    [S_Crtd_By]              NVARCHAR (MAX) NULL,
    [S_Upd_By]               NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]             DATETIME       NULL,
    [Dt_Upd_On]              DATETIME       NULL,
    CONSTRAINT [PK_T_Center_Category_Master] PRIMARY KEY CLUSTERED ([I_Center_Category_ID] ASC)
);

