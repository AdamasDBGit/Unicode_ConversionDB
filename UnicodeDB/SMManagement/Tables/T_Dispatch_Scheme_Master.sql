CREATE TABLE [SMManagement].[T_Dispatch_Scheme_Master] (
    [DispatchSchemeID]   INT           IDENTITY (1, 1) NOT NULL,
    [DispatchSchemeName] VARCHAR (100) NULL,
    [NoOfDelivery]       INT           NULL,
    [Frequency]          INT           NULL,
    [BooksPerDelivery]   INT           NULL,
    [StatusID]           INT           NULL,
    [ValidFrom]          DATETIME      NULL,
    [ValidTo]            DATETIME      NULL,
    [IsScheduled]        BIT           NULL,
    [CourseID]           INT           NULL,
    [CreatedBy]          VARCHAR (50)  NULL,
    [CreatedOn]          DATETIME      NULL,
    [UpdatedBy]          VARCHAR (50)  NULL,
    [UpdatedOn]          DATETIME      NULL
);

