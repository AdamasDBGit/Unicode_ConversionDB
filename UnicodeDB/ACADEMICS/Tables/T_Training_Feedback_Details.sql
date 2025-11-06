CREATE TABLE [ACADEMICS].[T_Training_Feedback_Details] (
    [I_Training_Feedback_Detail_ID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Training_Feedback_ID]        INT          NULL,
    [I_Feedback_Option_Master_ID]   INT          NULL,
    [S_Crtd_By]                     VARCHAR (20) NULL,
    [S_Upd_By]                      VARCHAR (20) NULL,
    [Dt_Crtd_On]                    DATETIME     NULL,
    [Dt_Upd_On]                     DATETIME     NULL,
    CONSTRAINT [PK__T_Training_Feedb__6502C82F] PRIMARY KEY CLUSTERED ([I_Training_Feedback_Detail_ID] ASC)
);

