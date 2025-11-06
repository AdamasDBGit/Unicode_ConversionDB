CREATE TABLE [ECOMMERCE].[T_Syllabus] (
    [SyllabusID]   INT            IDENTITY (1, 1) NOT NULL,
    [SyllabusName] NVARCHAR (MAX) NULL,
    [CourseID]     INT            NULL,
    [StatusID]     INT            NULL,
    [ValidFrom]    DATETIME       NULL,
    [ValidTo]      DATETIME       NULL,
    [CreatedBy]    VARCHAR (MAX)  NULL,
    [CreatedOn]    DATETIME       NULL,
    [UpdatedBy]    VARCHAR (MAX)  NULL,
    [UpdatedOn]    DATETIME       NULL,
    CONSTRAINT [PK__T_Syllab__9B801746D2FD2B4F] PRIMARY KEY CLUSTERED ([SyllabusID] ASC)
);

