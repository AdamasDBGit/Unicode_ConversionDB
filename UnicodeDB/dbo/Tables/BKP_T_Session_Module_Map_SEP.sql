CREATE TABLE [dbo].[BKP_T_Session_Module_Map_SEP] (
    [I_Session_Module_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Module_ID]         INT            NULL,
    [I_Session_ID]        INT            NULL,
    [I_Sequence]          INT            NULL,
    [S_Crtd_By]           NVARCHAR (MAX) NULL,
    [S_Upd_By]            NVARCHAR (MAX) NULL,
    [Dt_Valid_From]       DATETIME       NULL,
    [Dt_Crtd_On]          DATETIME       NULL,
    [Dt_Valid_To]         DATETIME       NULL,
    [Dt_Upd_On]           DATETIME       NULL,
    [I_Status]            INT            NULL
);

