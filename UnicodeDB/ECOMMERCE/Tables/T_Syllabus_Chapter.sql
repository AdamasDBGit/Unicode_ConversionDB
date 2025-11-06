CREATE TABLE [ECOMMERCE].[T_Syllabus_Chapter] (
    [ChapterID]   INT            IDENTITY (1, 1) NOT NULL,
    [ChapterName] NVARCHAR (MAX) NULL,
    [SubjectID]   INT            NULL,
    [StatusID]    INT            NULL,
    [CreatedBy]   VARCHAR (MAX)  NULL,
    [CreatedOn]   DATETIME       NULL,
    [UpdatedBy]   VARCHAR (MAX)  NULL,
    [UpdatedOn]   DATETIME       NULL,
    CONSTRAINT [PK__T_Syllab__0893A34A7C6F80F4] PRIMARY KEY CLUSTERED ([ChapterID] ASC)
);

