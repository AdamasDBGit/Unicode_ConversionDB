CREATE TABLE [LMS].[T_Student_OrgEmail_Audit] (
    [ID]                INT           IDENTITY (1, 1) NOT NULL,
    [OrgEmail]          VARCHAR (MAX) NOT NULL,
    [IsLicenseAttached] BIT           NULL,
    [CreatedOn]         DATETIME      NULL,
    [LicenseAttachedOn] DATETIME      NULL
);

