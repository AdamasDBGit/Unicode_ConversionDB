CREATE TABLE [ACADEMICS].[T_Feedback_Master] (
    [I_Feedback_Master_ID] INT           IDENTITY (1, 1) NOT NULL,
    [I_Feedback_Group_ID]  INT           NULL,
    [I_Feedback_Type_ID]   INT           NULL,
    [I_Exam_Component_ID]  INT           NULL,
    [S_Feedback_Question]  VARCHAR (200) NULL,
    [I_Status]             INT           NULL,
    [S_Crtd_By]            VARCHAR (20)  NULL,
    [S_Upd_By]             VARCHAR (20)  NULL,
    [Dt_Crtd_On]           DATETIME      NULL,
    [Dt_Upd_On]            DATETIME      NULL,
    [I_Brand_ID]           INT           NULL,
    CONSTRAINT [PK__T_Feedback_Maste__1D072A30] PRIMARY KEY CLUSTERED ([I_Feedback_Master_ID] ASC)
);

