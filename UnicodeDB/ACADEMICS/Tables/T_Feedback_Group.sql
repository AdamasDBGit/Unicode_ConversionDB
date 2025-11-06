CREATE TABLE [ACADEMICS].[T_Feedback_Group] (
    [I_Feedback_Group_ID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_Description]       VARCHAR (500) NULL,
    [S_Crtd_By]           VARCHAR (20)  NULL,
    [S_Upd_By]            VARCHAR (20)  NULL,
    [Dt_Crtd_On]          DATETIME      NULL,
    [Dt_Upd_On]           DATETIME      NULL,
    CONSTRAINT [PK__T_Feedback_Group__675524F5] PRIMARY KEY CLUSTERED ([I_Feedback_Group_ID] ASC)
);

