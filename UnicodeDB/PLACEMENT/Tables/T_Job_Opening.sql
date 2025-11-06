CREATE TABLE [PLACEMENT].[T_Job_Opening] (
    [I_Vacancy_ID] INT NOT NULL,
    [I_City_ID]    INT NOT NULL,
    [I_Vacancy]    INT NOT NULL,
    CONSTRAINT [PK_T_Job_Opening] PRIMARY KEY CLUSTERED ([I_Vacancy_ID] ASC, [I_City_ID] ASC)
);

