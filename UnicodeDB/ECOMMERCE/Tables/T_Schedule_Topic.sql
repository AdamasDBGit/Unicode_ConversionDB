CREATE TABLE [ECOMMERCE].[T_Schedule_Topic] (
    [TopicID]   INT            IDENTITY (1, 1) NOT NULL,
    [TopicName] NVARCHAR (MAX) NULL,
    [ChapterID] INT            NULL,
    [StatusID]  INT            NULL,
    [CreatedBy] VARCHAR (MAX)  NULL,
    [CreatedOn] DATETIME       NULL,
    [UpdatedBy] VARCHAR (MAX)  NULL,
    [UpdatedOn] DATETIME       NULL,
    [SubjectID] INT            NULL,
    CONSTRAINT [PK__T_Schedu__022E0F7DBE5E5621] PRIMARY KEY CLUSTERED ([TopicID] ASC)
);

