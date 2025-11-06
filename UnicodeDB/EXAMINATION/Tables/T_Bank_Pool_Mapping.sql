CREATE TABLE [EXAMINATION].[T_Bank_Pool_Mapping] (
    [I_Bank_Pool_Mapping_ID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Pool_ID]              INT          NOT NULL,
    [I_Question_Bank_ID]     INT          NOT NULL,
    [S_Crtd_By]              VARCHAR (20) NULL,
    [S_Upd_By]               VARCHAR (20) NULL,
    [Dt_Crtd_On]             DATETIME     NULL,
    [Dt_Upd_On]              DATETIME     NULL,
    CONSTRAINT [PK__T_Bank_Pool_Mapp__64CDBE05] PRIMARY KEY CLUSTERED ([I_Bank_Pool_Mapping_ID] ASC)
);

