CREATE TABLE [ECOMMERCE].[T_Syllabus_Topic] (
    [TopicID]   INT            IDENTITY (1, 1) NOT NULL,
    [TopicName] NVARCHAR (MAX) NULL,
    [ChapterID] INT            NULL,
    [StatusID]  INT            NULL,
    [CreatedBy] VARCHAR (MAX)  NULL,
    [CreatedOn] DATETIME       NULL,
    [UpdatedBy] VARCHAR (MAX)  NULL,
    [UpdatedOn] DATETIME       NULL,
    CONSTRAINT [PK__T_Syllab__022E0F7D2725727D] PRIMARY KEY CLUSTERED ([TopicID] ASC)
);

