CREATE TABLE [dbo].[BulkUploadEventTable] (
    [ID]                    INT            IDENTITY (1, 1) NOT NULL,
    [S_Event_Name]          NVARCHAR (MAX) NULL,
    [S_Event_For]           NVARCHAR (MAX) NULL,
    [S_Event_Desc]          NVARCHAR (MAX) NULL,
    [S_CreatedBy]           NVARCHAR (MAX) NULL,
    [S_Event_Category_Name] NVARCHAR (MAX) NULL,
    [S_Address]             NVARCHAR (MAX) NULL,
    [S_School_Group_Name]   NVARCHAR (MAX) NULL,
    [S_Class]               NVARCHAR (MAX) NULL,
    [S_Faculty_Name]        NVARCHAR (MAX) NULL,
    [Dt_StartDate]          DATETIME       NULL,
    [Dt_EndDate]            DATETIME       NULL
);

