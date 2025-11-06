CREATE TABLE [dbo].[T_Followup_Closure_Master] (
    [I_Followup_Closure_ID]   INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_Followup_Closure_Desc] NVARCHAR (MAX) NULL,
    [I_Status]                INT            NULL,
    [S_Crtd_By]               NVARCHAR (MAX) NULL,
    [S_Upd_By]                NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]              DATETIME       NULL,
    [Dt_Upd_On]               DATETIME       NULL,
    CONSTRAINT [PK__T_Followup_Closu__5ABA43E6] PRIMARY KEY CLUSTERED ([I_Followup_Closure_ID] ASC)
);

