CREATE TABLE [dbo].[T_ActivityEvalCriteria_Map] (
    [I_Activity_ID]   INT NOT NULL,
    [I_Evaluation_ID] INT NOT NULL,
    CONSTRAINT [PK_T_ActivityEvalCriteria_Master] PRIMARY KEY CLUSTERED ([I_Activity_ID] ASC, [I_Evaluation_ID] ASC)
);

