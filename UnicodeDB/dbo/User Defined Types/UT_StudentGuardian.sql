CREATE TYPE [dbo].[UT_StudentGuardian] AS TABLE (
    [EnquiryID]             INT            NULL,
    [RelationID]            INT            NULL,
    [GuardianFirstName]     NVARCHAR (200) NULL,
    [GuardianMiddleName]    NVARCHAR (200) NULL,
    [GuardianLastName]      NVARCHAR (200) NULL,
    [GuardianMobile]        NVARCHAR (100) NULL,
    [GuardianEmail]         NVARCHAR (200) NULL,
    [GuardianQualification] INT            NULL,
    [Income]                INT            NULL,
    [GuardianPicture]       NVARCHAR (400) NULL,
    [GuardianCompanyName]   NVARCHAR (400) NULL,
    [GuardianDesignation]   NVARCHAR (400) NULL,
    [Occupation]            INT            NULL);

