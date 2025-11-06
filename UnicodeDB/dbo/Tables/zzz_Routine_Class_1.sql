CREATE TABLE [dbo].[zzz_Routine_Class_1] (
    [Routine Name]          NVARCHAR (MAX) NULL,
    [School Group Name]     NVARCHAR (MAX) NULL,
    [Class Name]            NVARCHAR (MAX) NULL,
    [Stream Name]           NVARCHAR (MAX) NULL,
    [Section Name]          NVARCHAR (MAX) NULL,
    [Total Periods]         INT            NULL,
    [Start Time]            NVARCHAR (MAX) NULL,
    [Period Duration]       INT            NULL,
    [Period Gap]            NVARCHAR (MAX) NULL,
    [Break Period Number]   NVARCHAR (MAX) NULL,
    [Break Period Duration] INT            NULL,
    [Number of Weekdays]    INT            NULL,
    [Faculty Class Teacher] NVARCHAR (MAX) NULL,
    [Period Number]         INT            NULL,
    [Period Start Time]     NVARCHAR (MAX) NULL,
    [Period End Time]       NVARCHAR (MAX) NULL,
    [Day Name]              NVARCHAR (MAX) NULL,
    [Subject Name]          NVARCHAR (MAX) NULL,
    [Faculty Subject Name]  NVARCHAR (MAX) NULL,
    [Faculty_ID]            INT            NULL,
    [ID]                    INT            IDENTITY (1, 1) NOT NULL
);

