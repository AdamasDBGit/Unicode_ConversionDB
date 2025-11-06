CREATE TABLE [EXAMINATION].[T_SubQuestion_Choice] (
    [I_SubQuestion_Choice_ID]   INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_SubQuestion_ID]          INT           NOT NULL,
    [S_SubAnswer_Value]         VARCHAR (50)  NULL,
    [I_SubQuestion_Choice_Type] TINYINT       NULL,
    [S_SubAnswer_Desc]          VARCHAR (500) NULL,
    [I_Document_ID]             INT           NULL,
    [B_Is_Answer]               BIT           NULL,
    [S_Crtd_By]                 VARCHAR (20)  NULL,
    [S_Upd_By]                  VARCHAR (20)  NULL,
    [Dt_Crtd_On]                DATETIME      NULL,
    [Dt_Upd_On]                 DATETIME      NULL,
    CONSTRAINT [PK__T_SubQuestion_Ch__6423B28F] PRIMARY KEY CLUSTERED ([I_SubQuestion_Choice_ID] ASC)
);

