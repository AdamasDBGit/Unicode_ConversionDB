CREATE TABLE [dbo].[T_POC_StudentChartData_EVS] (
    [Id]                                  INT            IDENTITY (1, 1) NOT NULL,
    [StudentName]                         NVARCHAR (255) NOT NULL,
    [CompetencyBasedAndHOTS]              DECIMAL (5, 2) NOT NULL,
    [ConceptualAndAnalyticalSkills]       DECIMAL (5, 2) NOT NULL,
    [LogicalReasoningAndCriticalThinking] DECIMAL (5, 2) NOT NULL,
    [UnderstandingAndContentBased]        DECIMAL (5, 2) NOT NULL,
    CONSTRAINT [PK__T_POC_St__3214EC07EDAB0121] PRIMARY KEY CLUSTERED ([Id] ASC)
);

