CREATE TABLE [ECOMMERCE].[T_Recommended_Course] (
    [ID]                    INT IDENTITY (1, 1) NOT NULL,
    [CourseID]              INT NOT NULL,
    [Recommended_Course_ID] INT NOT NULL,
    [I_Status]              INT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

