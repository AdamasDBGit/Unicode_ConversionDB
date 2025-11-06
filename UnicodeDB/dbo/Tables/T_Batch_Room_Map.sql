CREATE TABLE [dbo].[T_Batch_Room_Map] (
    [I_Batch_Room_ID] BIGINT         IDENTITY (1, 1) NOT NULL,
    [I_Batch_ID]      INT            NOT NULL,
    [I_Room_ID]       INT            NOT NULL,
    [I_Status]        INT            NULL,
    [S_Crtd_By]       NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]      DATETIME       NULL,
    [S_Upd_By]        NVARCHAR (MAX) NULL,
    [Dt_Upd_On]       DATETIME       NULL,
    CONSTRAINT [PK_T_Batch_Room_Map] PRIMARY KEY CLUSTERED ([I_Batch_Room_ID] ASC)
);

