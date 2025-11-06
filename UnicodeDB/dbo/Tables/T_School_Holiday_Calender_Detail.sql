CREATE TABLE [dbo].[T_School_Holiday_Calender_Detail] (
    [I_School_Holiday_Calender_Detail_ID] INT           IDENTITY (1, 1) NOT NULL,
    [I_Calender_ID]                       INT           NULL,
    [I_Weekly_Off_Day_ID]                 NCHAR (10)    NULL,
    [Dt_Date]                             DATETIME      NULL,
    [S_Remarks]                           NVARCHAR (50) NULL
);

