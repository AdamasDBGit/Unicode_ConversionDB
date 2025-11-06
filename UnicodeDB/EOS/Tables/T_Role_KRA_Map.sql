CREATE TABLE [EOS].[T_Role_KRA_Map] (
    [I_Role_KRA_Mapping_ID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Brand_ID]            INT          NOT NULL,
    [I_Role_ID]             INT          NOT NULL,
    [I_KRA_ID]              INT          NOT NULL,
    [I_KRA_Index_ID]        INT          NOT NULL,
    [I_Status]              INT          NULL,
    [S_Crtd_By]             VARCHAR (20) NULL,
    [S_Upd_By]              VARCHAR (20) NULL,
    [Dt_Crtd_On]            DATETIME     NULL,
    [Dt_Upd_On]             DATETIME     NULL,
    CONSTRAINT [PK_T_Role_KRA_Map] PRIMARY KEY CLUSTERED ([I_Role_KRA_Mapping_ID] ASC)
);

