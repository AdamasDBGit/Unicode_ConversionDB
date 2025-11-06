CREATE TABLE [dbo].[T_ERP_Subject_Group_Master] (
    [SubjectGroupID]   INT            IDENTITY (1, 1) NOT NULL,
    [SubjectGroupName] NVARCHAR (MAX) NOT NULL,
    [ClassID]          INT            NOT NULL,
    [SchoolGroupID]    INT            NOT NULL,
    [CreatedBy]        INT            NULL,
    [CreatedOn]        DATETIME       NULL,
    [UpdatedBy]        INT            NULL,
    [UpdatedOn]        DATETIME       NULL,
    [StreamID]         INT            NULL
);

