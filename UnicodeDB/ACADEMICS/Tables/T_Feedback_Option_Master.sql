CREATE TABLE [ACADEMICS].[T_Feedback_Option_Master] (
    [I_Feedback_Option_Master_ID] INT           IDENTITY (1, 1) NOT NULL,
    [I_Feedback_Master_ID]        INT           NULL,
    [S_Feedback_Option_Name]      VARCHAR (100) NULL,
    [I_Value]                     INT           NOT NULL,
    [I_Status]                    INT           NULL,
    [S_Crtd_By]                   VARCHAR (20)  NULL,
    [S_Upd_By]                    VARCHAR (20)  NULL,
    [Dt_Crtd_On]                  DATETIME      NULL,
    [Dt_Upd_On]                   DATETIME      NULL,
    CONSTRAINT [PK__T_Feedback_Optio__19E0A4C2] PRIMARY KEY CLUSTERED ([I_Feedback_Option_Master_ID] ASC)
);

