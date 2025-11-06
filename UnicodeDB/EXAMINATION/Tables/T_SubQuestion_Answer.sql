CREATE TABLE [EXAMINATION].[T_SubQuestion_Answer] (
    [I_SubQuestion_Answer_ID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Question_Paper_ID]     INT          NULL,
    [I_Question_ID]           INT          NULL,
    [I_SubQuestion_ID]        INT          NULL,
    [I_SubQuestion_Choice_ID] INT          NULL,
    [I_Marks]                 INT          NULL,
    [S_Crtd_By]               VARCHAR (20) NULL,
    [S_Upd_By]                VARCHAR (20) NULL,
    [Dt_Crtd_On]              DATETIME     NULL,
    [Dt_Upd_On]               DATETIME     NULL,
    CONSTRAINT [PK__T_SubQuestion_An__66B60677] PRIMARY KEY CLUSTERED ([I_SubQuestion_Answer_ID] ASC)
);

