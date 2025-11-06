CREATE TABLE [LMS].[T_Teacher_Details_Interface_API] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [BrandID]      INT           NULL,
    [BrandName]    VARCHAR (MAX) NULL,
    [FacultyID]    INT           NULL,
    [FacultyName]  VARCHAR (MAX) NULL,
    [EmailID]      VARCHAR (MAX) NULL,
    [TimeSlots]    VARCHAR (MAX) NULL,
    [CentreCodes]  VARCHAR (MAX) NULL,
    [CentreIDs]    VARCHAR (MAX) NULL,
    [DayofLeave]   VARCHAR (MAX) NULL,
    [ForOnline]    BIT           NULL,
    [ForOffline]   BIT           NULL,
    [Subjects]     VARCHAR (MAX) NULL,
    [ActionType]   VARCHAR (MAX) NULL,
    [ActionStatus] INT           NULL,
    [NoofAttempts] INT           NULL,
    [StatusID]     INT           NULL,
    [CreatedOn]    DATETIME      NULL,
    [CompletedOn]  DATETIME      NULL,
    [Remarks]      VARCHAR (MAX) NULL
);

