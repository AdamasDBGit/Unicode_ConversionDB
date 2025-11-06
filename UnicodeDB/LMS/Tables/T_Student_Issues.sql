CREATE TABLE [LMS].[T_Student_Issues] (
    [ID]              INT            IDENTITY (1, 1) NOT NULL,
    [Issue]           NVARCHAR (MAX) NULL,
    [IssueCategoryID] INT            NULL,
    [Name]            VARCHAR (MAX)  NULL,
    [StudentID]       VARCHAR (MAX)  NULL,
    [CustomerID]      VARCHAR (MAX)  NULL,
    [ContactNo]       VARCHAR (MAX)  NULL,
    [EmailID]         VARCHAR (MAX)  NULL,
    [StatusID]        INT            NULL,
    [CreatedOn]       DATETIME       NULL,
    CONSTRAINT [PK__T_Studen__3214EC271D43D1A2] PRIMARY KEY CLUSTERED ([ID] ASC)
);

