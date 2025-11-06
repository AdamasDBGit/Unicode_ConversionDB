CREATE TABLE [dbo].[Batch_Feeschedule_Log] (
    [LogID]                   INT            IDENTITY (1, 1) NOT NULL,
    [BrandID]                 INT            NULL,
    [ActionDate]              DATETIME       NULL,
    [ApproveDate]             DATETIME       NULL,
    [BatchID]                 INT            NULL,
    [CourseFeePlanID]         INT            NULL,
    [BatchFeePlanDetailJson]  NVARCHAR (MAX) NULL,
    [Actionstatus]            NVARCHAR (MAX) NULL,
    [BatchFeePlanCreatedBy]   NVARCHAR (MAX) NULL,
    [BatchFeePlanCreatedOn]   DATETIME       NULL,
    [BatchFeePlanUpdatedBy]   NVARCHAR (MAX) NULL,
    [BatchFeePlanUpdatedOn]   DATETIME       NULL,
    [CauseOfModify]           NVARCHAR (MAX) NULL,
    [PreviousCourseFeePlanID] INT            NULL
);

