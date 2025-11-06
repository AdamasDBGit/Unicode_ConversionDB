CREATE TABLE [ECOMMERCE].[T_Schedule_Chapter] (
    [ChapterID]   INT           IDENTITY (1, 1) NOT NULL,
    [ChapterName] VARCHAR (MAX) NULL,
    [SubjectID]   INT           NULL,
    [StatusID]    INT           NULL,
    [CreatedBy]   VARCHAR (MAX) NULL,
    [CreatedOn]   DATETIME      NULL,
    [UpdatedBy]   VARCHAR (MAX) NULL,
    [UpdatedOn]   DATETIME      NULL,
    CONSTRAINT [PK__T_Schedu__0893A34A23FFAF3C] PRIMARY KEY CLUSTERED ([ChapterID] ASC)
);

