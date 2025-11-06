CREATE TABLE [ASSESSMENT].[T_Evaluation_Master] (
    [I_EvaluationID]   INT           IDENTITY (1, 1) NOT NULL,
    [S_EvaluationName] VARCHAR (150) NOT NULL,
    CONSTRAINT [PK_T_Evaluation_Master] PRIMARY KEY CLUSTERED ([I_EvaluationID] ASC)
);

