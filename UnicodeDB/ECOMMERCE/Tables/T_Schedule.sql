CREATE TABLE [ECOMMERCE].[T_Schedule] (
    [ScheduleID]   INT            IDENTITY (1, 1) NOT NULL,
    [ScheduleName] NVARCHAR (MAX) NULL,
    [CourseID]     INT            NULL,
    [StatusID]     INT            NULL,
    [ValidFrom]    DATETIME       NULL,
    [ValidTo]      DATETIME       NULL,
    [CreatedBy]    VARCHAR (MAX)  NULL,
    [CreatedOn]    DATETIME       NULL,
    [UpdatedBy]    VARCHAR (MAX)  NULL,
    [UpdatedOn]    DATETIME       NULL,
    CONSTRAINT [PK__T_Schedu__9C8A5B69738B536C] PRIMARY KEY CLUSTERED ([ScheduleID] ASC)
);

