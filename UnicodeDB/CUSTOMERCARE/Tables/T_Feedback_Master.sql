CREATE TABLE [CUSTOMERCARE].[T_Feedback_Master] (
    [I_Feedback_ID]    INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Status_ID]      INT          NULL,
    [S_Feedback_Value] VARCHAR (20) NULL,
    [S_Feedback_Code]  VARCHAR (20) NULL,
    [S_Crtd_By]        VARCHAR (20) NULL,
    [S_Upd_By]         VARCHAR (20) NULL,
    [Dt_Crtd_On]       DATETIME     NULL,
    [Dt_Upd_On]        DATETIME     NULL,
    CONSTRAINT [PK__T_Feedback_Maste__46B34B39] PRIMARY KEY CLUSTERED ([I_Feedback_ID] ASC)
);

