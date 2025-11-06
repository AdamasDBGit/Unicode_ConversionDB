CREATE TABLE [EXAMINATION].[T_Answer_Type_Master] (
    [I_Answer_Type_ID]   INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_Answer_Type_Desc] VARCHAR (50) NULL,
    [I_Status]           INT          NULL,
    [S_Crtd_By]          VARCHAR (20) NULL,
    [S_Upd_By]           VARCHAR (20) NULL,
    [Dt_Crtd_On]         DATETIME     NULL,
    [Dt_Upd_On]          DATETIME     NULL,
    CONSTRAINT [PK__T_Answer_Type_Ma__5110DE1B] PRIMARY KEY CLUSTERED ([I_Answer_Type_ID] ASC)
);

