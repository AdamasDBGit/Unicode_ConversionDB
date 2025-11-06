CREATE TABLE [ACADEMICS].[T_Training_Feedback] (
    [I_Training_Feedback_ID]   INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Training_ID]            INT            NULL,
    [I_Feedback_Type_ID]       INT            NULL,
    [Feedback_Provided_UserId] INT            NULL,
    [Feedback_Received_UserId] INT            NULL,
    [Dt_Feedback_Date]         DATETIME       NULL,
    [N_Previous_Score]         NUMERIC (8, 2) NULL,
    [N_Next_Score]             NUMERIC (8, 2) NULL,
    [S_Crtd_By]                VARCHAR (20)   NULL,
    [S_Upd_By]                 VARCHAR (20)   NULL,
    [Dt_Crtd_On]               DATETIME       NULL,
    [Dt_Upd_On]                DATETIME       NULL,
    CONSTRAINT [PK__T_Training_Feedb__3647D946] PRIMARY KEY CLUSTERED ([I_Training_Feedback_ID] ASC)
);

