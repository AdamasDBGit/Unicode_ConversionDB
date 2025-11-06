CREATE TABLE [dbo].[T_School_Holiday_Calender] (
    [I_Calender_ID]       INT            IDENTITY (1, 1) NOT NULL,
    [I_School_Session_ID] INT            NOT NULL,
    [S_Holiday_Name]      NVARCHAR (MAX) NOT NULL,
    [I_Holiday_Type_ID]   INT            NOT NULL,
    [I_Calender_Title_ID] INT            NULL,
    [Dt_From_Date]        DATETIME       NOT NULL,
    [Dt_To_Date]          DATETIME       NOT NULL,
    [I_Status]            INT            CONSTRAINT [DF__School_Ho__I_Sta__4A6EFF4E] DEFAULT ((1)) NOT NULL,
    [S_CreatedBy]         NVARCHAR (MAX) NOT NULL,
    [Dt_CreatedOn]        DATETIME       NOT NULL,
    [S_UpdatedBy]         NVARCHAR (MAX) NULL,
    [Dt_UpdatedOn]        DATETIME       NULL
);

