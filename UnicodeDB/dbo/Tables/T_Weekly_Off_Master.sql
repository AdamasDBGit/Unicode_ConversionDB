CREATE TABLE [dbo].[T_Weekly_Off_Master] (
    [I_Weekly_Off_Day_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]          INT            NULL,
    [I_Day_ID]            INT            NOT NULL,
    [I_Calender_Title_ID] INT            NULL,
    [I_School_session_ID] INT            NULL,
    [I_WeekOff]           INT            NULL,
    [I_IsAlternative]     INT            NULL,
    [I_IsOdd]             INT            NULL,
    [I_Status]            INT            CONSTRAINT [DF__Weekly_Of__I_Sta__469E6E6A] DEFAULT ((1)) NOT NULL,
    [S_CreatedBy]         NVARCHAR (MAX) NOT NULL,
    [Dt_CreatedOn]        DATETIME       NOT NULL,
    [S_UpdatedBy]         NVARCHAR (MAX) NULL,
    [Dt_UpdatedOn]        DATETIME       NULL
);

