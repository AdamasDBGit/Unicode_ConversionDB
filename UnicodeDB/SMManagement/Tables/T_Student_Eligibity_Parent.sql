CREATE TABLE [SMManagement].[T_Student_Eligibity_Parent] (
    [EligibilityHeaderID]    INT           IDENTITY (1, 1) NOT NULL,
    [StudentDetailID]        INT           NULL,
    [CenterDispatchSchemeID] INT           NULL,
    [CourseID]               INT           NULL,
    [CenterID]               INT           NULL,
    [BatchID]                INT           NULL,
    [StatusID]               INT           NULL,
    [IsScheduled]            BIT           NULL,
    [CreatedOn]              DATETIME      NULL,
    [CreatedBy]              VARCHAR (MAX) NULL,
    [UpdatedOn]              DATETIME      NULL,
    [UpdatedBy]              VARCHAR (MAX) NULL
);

