CREATE TABLE [LMS].[LMS_Push_Log] (
    [LMSPushID]       INT           IDENTITY (1, 1) NOT NULL,
    [ExecutedService] VARCHAR (MAX) NOT NULL,
    [PushJson]        VARCHAR (MAX) NOT NULL,
    [PushResult]      VARCHAR (MAX) NULL,
    [Remarks]         VARCHAR (MAX) NULL,
    [LogDate]         DATETIME      NULL,
    [IssueStudentID]  VARCHAR (MAX) NULL
);

