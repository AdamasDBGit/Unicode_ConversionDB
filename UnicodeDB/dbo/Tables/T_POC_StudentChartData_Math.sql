CREATE TABLE [dbo].[T_POC_StudentChartData_Math] (
    [Id]                       INT            IDENTITY (1, 1) NOT NULL,
    [StudentName]              NVARCHAR (255) NOT NULL,
    [ArithmeticComputation]    DECIMAL (5, 2) NOT NULL,
    [CriticalThinking]         DECIMAL (5, 2) NOT NULL,
    [MathematicalIntelligence] DECIMAL (5, 2) NOT NULL,
    CONSTRAINT [PK__T_POC_St__3214EC07C0465C28] PRIMARY KEY CLUSTERED ([Id] ASC)
);

