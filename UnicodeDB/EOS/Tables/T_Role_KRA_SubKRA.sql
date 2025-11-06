CREATE TABLE [EOS].[T_Role_KRA_SubKRA] (
    [I_Role_KRA_SubKRA_ID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Brand_ID]           INT          NULL,
    [I_Role_ID]            INT          NULL,
    [I_KRA_ID]             INT          NULL,
    [I_SubKRA_ID]          INT          NULL,
    [I_SubKRA_Index_ID]    INT          NULL,
    [I_Status]             INT          NULL,
    [S_Crtd_By]            VARCHAR (20) NULL,
    [S_Upd_By]             VARCHAR (20) NULL,
    [Dt_Crtd_On]           DATETIME     NULL,
    [Dt_Upd_On]            DATETIME     NULL,
    CONSTRAINT [PK__T_Role_KRA_SubKR__7FD78553] PRIMARY KEY CLUSTERED ([I_Role_KRA_SubKRA_ID] ASC)
);

