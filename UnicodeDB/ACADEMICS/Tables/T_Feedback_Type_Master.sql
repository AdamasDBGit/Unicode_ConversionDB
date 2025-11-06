CREATE TABLE [ACADEMICS].[T_Feedback_Type_Master] (
    [I_Feedback_Type_ID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_Description]      VARCHAR (200) NULL,
    [S_Crtd_By]          VARCHAR (20)  NULL,
    [S_Upd_By]           VARCHAR (20)  NULL,
    [Dt_Crtd_On]         DATETIME      NULL,
    [Dt_Upd_On]          DATETIME      NULL,
    CONSTRAINT [PK__T_Feedback_Type___6D0DFE4B] PRIMARY KEY CLUSTERED ([I_Feedback_Type_ID] ASC)
);

