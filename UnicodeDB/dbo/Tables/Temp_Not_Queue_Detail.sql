CREATE TABLE [dbo].[Temp_Not_Queue_Detail] (
    [ID]            INT            IDENTITY (1, 1) NOT NULL,
    [EnquiryID]     INT            NULL,
    [CandidateName] NVARCHAR (MAX) NULL,
    [ContactNo]     NVARCHAR (MAX) NULL,
    [EmailID]       NVARCHAR (MAX) NULL,
    [ActionType]    NVARCHAR (MAX) NULL,
    [ActionStatus]  NVARCHAR (MAX) NULL,
    [NoofAttempts]  INT            NULL,
    [StatusID]      INT            NULL,
    [CreatedOn]     DATETIME       NULL,
    [CompletedOn]   DATETIME       NULL,
    [Remarks]       NVARCHAR (MAX) NULL,
    [CustomerID]    NVARCHAR (MAX) NULL
);

