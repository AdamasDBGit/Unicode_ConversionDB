CREATE TABLE [SMManagement].[T_Migration_Interface] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [StudentID]       VARCHAR (MAX) NULL,
    [StudentDetailID] INT           NULL,
    [StudentStatus]   INT           NULL,
    [CourseID]        INT           NULL,
    [BatchID]         INT           NULL,
    [OpsCenter]       VARCHAR (MAX) NULL,
    [Center]          VARCHAR (MAX) NULL,
    [CenterID]        INT           NULL,
    [LastDelivery]    INT           NULL,
    [StatusID]        INT           NULL,
    [LogText]         VARCHAR (MAX) NULL
);

