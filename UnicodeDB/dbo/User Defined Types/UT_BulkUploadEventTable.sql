CREATE TYPE [dbo].[UT_BulkUploadEventTable] AS TABLE (
    [ID]                    INT           IDENTITY (1, 1) NOT NULL,
    [I_Brand_Id]            INT           NOT NULL,
    [S_Event_Name]          VARCHAR (500) NULL,
    [S_Event_For]           VARCHAR (500) NULL,
    [S_Event_Desc]          VARCHAR (500) NULL,
    [S_CreatedBy]           VARCHAR (500) NULL,
    [S_Event_Category_Name] VARCHAR (500) NULL,
    [S_Address]             VARCHAR (500) NULL,
    [S_School_Group_Name]   VARCHAR (500) NULL,
    [S_Class]               VARCHAR (500) NULL,
    [S_Faculty_Name]        VARCHAR (500) NULL,
    [Dt_StartDate]          DATE          NULL,
    [Dt_EndDate]            DATE          NULL,
    [S_Status]              VARCHAR (225) NULL);

