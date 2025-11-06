CREATE TABLE [ECOMMERCE].[T_Schedule_Subject] (
    [SubjectID]   INT            IDENTITY (1, 1) NOT NULL,
    [SubjectName] NVARCHAR (MAX) NULL,
    [SMID]        INT            NULL,
    [StatusID]    INT            NULL,
    [CreatedBy]   VARCHAR (MAX)  NULL,
    [CreatedOn]   DATETIME       NULL,
    [UpdatedBy]   VARCHAR (MAX)  NULL,
    [UpdatedOn]   DATETIME       NULL,
    CONSTRAINT [PK__T_Schedu__AC1BA388AF60D951] PRIMARY KEY CLUSTERED ([SubjectID] ASC)
);

