CREATE TABLE [dbo].[T_Bridge_Course_Mapping] (
    [I_Bridge_Course_Map_ID] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Bridge_ID]            INT            NOT NULL,
    [I_Prev_Course_ID]       INT            NOT NULL,
    [I_Next_Course_ID]       INT            NOT NULL,
    [I_Status]               INT            NULL,
    [S_Crtd_By]              NVARCHAR (MAX) NULL,
    [S_Upd_By]               NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]             DATETIME       NULL,
    [Dt_Upd_On]              DATETIME       NULL,
    CONSTRAINT [PK_T_Bridge_Course_Mapping] PRIMARY KEY CLUSTERED ([I_Bridge_Course_Map_ID] ASC)
);

