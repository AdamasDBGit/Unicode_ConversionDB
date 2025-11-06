CREATE TABLE [dbo].[T_POC_StudentChartData_Hindi] (
    [Id]                     INT            IDENTITY (1, 1) NOT NULL,
    [StudentName]            NVARCHAR (255) NOT NULL,
    [CreativeWriting]        DECIMAL (5, 2) NOT NULL,
    [LanguageProficiency]    DECIMAL (5, 2) NOT NULL,
    [LiteraryAnalysis]       DECIMAL (5, 2) NOT NULL,
    [LogicalThinking]        DECIMAL (5, 2) NOT NULL,
    [ResearchAndApplication] DECIMAL (5, 2) NOT NULL,
    CONSTRAINT [PK__T_POC_St__3214EC07ABE419FB] PRIMARY KEY CLUSTERED ([Id] ASC)
);

