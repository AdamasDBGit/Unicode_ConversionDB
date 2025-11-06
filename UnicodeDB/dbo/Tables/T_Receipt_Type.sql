CREATE TABLE [dbo].[T_Receipt_Type] (
    [I_Receipt_Type_ID]   INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_Receipt_Type_Desc] NVARCHAR (MAX) NULL,
    [I_Status]            INT            NULL,
    [S_Crtd_By]           NVARCHAR (MAX) NULL,
    [S_Upd_By]            NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]          DATETIME       NULL,
    [Dt_Upd_On]           DATETIME       NULL,
    CONSTRAINT [PK_T_Receipt_Type] PRIMARY KEY CLUSTERED ([I_Receipt_Type_ID] ASC)
);

