CREATE TABLE [LMS].[T_Student_Leave_Details_Interface_API] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [StudentDetailID] INT           NULL,
    [StudentID]       VARCHAR (MAX) NULL,
    [FirstName]       VARCHAR (MAX) NULL,
    [MiddleName]      VARCHAR (MAX) NULL,
    [LastName]        VARCHAR (MAX) NULL,
    [LeaveID]         INT           NULL,
    [LeaveStartDate]  DATETIME      NULL,
    [LeaveEndDate]    DATETIME      NULL,
    [ActionType]      VARCHAR (MAX) NULL,
    [ActionStatus]    INT           NULL,
    [NoofAttempts]    INT           NULL,
    [StatusID]        INT           NULL,
    [CreatedOn]       DATETIME      NULL,
    [CompletedOn]     DATETIME      NULL,
    [Remarks]         VARCHAR (MAX) NULL
);

