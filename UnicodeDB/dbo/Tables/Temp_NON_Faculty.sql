CREATE TABLE [dbo].[Temp_NON_Faculty] (
    [ID]           INT            IDENTITY (1, 1) NOT NULL,
    [SubjectID]    INT            NULL,
    [School_Group] NVARCHAR (MAX) NULL,
    [Class]        NVARCHAR (MAX) NULL,
    [Stream]       NVARCHAR (MAX) NULL,
    [Subject_Name] NVARCHAR (MAX) NULL,
    [Faculty_Name] NVARCHAR (MAX) NULL,
    [FacultyID]    INT            NULL
);

