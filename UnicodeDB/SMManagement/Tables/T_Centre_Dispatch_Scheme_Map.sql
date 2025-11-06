CREATE TABLE [SMManagement].[T_Centre_Dispatch_Scheme_Map] (
    [CentreDispatchSchemeID] INT           IDENTITY (1, 1) NOT NULL,
    [SchemeID]               INT           NULL,
    [CentreID]               INT           NULL,
    [StatusID]               INT           NULL,
    [ValidFrom]              DATETIME      NULL,
    [ValidTo]                DATETIME      NULL,
    [CreatedBy]              VARCHAR (MAX) NULL,
    [CreatedOn]              DATETIME      NULL,
    [UpdatedBy]              VARCHAR (MAX) NULL,
    [UpdatedOn]              DATETIME      NULL,
    [CourseID]               INT           NULL
);

