CREATE TABLE [ECOMMERCE].[T_Syllabus_Subject] (
    [SubjectID]   INT            IDENTITY (1, 1) NOT NULL,
    [SubjectName] NVARCHAR (MAX) NULL,
    [SyllabusID]  INT            NULL,
    [StatusID]    INT            NULL,
    [CreatedBy]   VARCHAR (MAX)  NULL,
    [CreatedOn]   DATETIME       NULL,
    [UpdatedBy]   VARCHAR (MAX)  NULL,
    [UpdatedOn]   DATETIME       NULL,
    CONSTRAINT [PK__T_Syllab__AC1BA388B897E421] PRIMARY KEY CLUSTERED ([SubjectID] ASC)
);

