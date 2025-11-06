CREATE TABLE [dbo].[T_School_Academic_Session_Master] (
    [I_School_Session_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]            INT            NOT NULL,
    [Dt_Session_Start_Date] DATETIME       NOT NULL,
    [Dt_Session_End_Date]   DATETIME       NOT NULL,
    [S_Label]               NVARCHAR (50)  NULL,
    [I_Status]              INT            CONSTRAINT [DF__School_Ac__I_Sta__4886B6DC] DEFAULT ((1)) NOT NULL,
    [S_CreatedBy]           NVARCHAR (MAX) NOT NULL,
    [Dt_CreatedOn]          DATETIME       NOT NULL,
    [S_UpdatedBy]           NVARCHAR (MAX) NULL,
    [Dt_UpdatedOn]          DATETIME       NULL,
    [I_Current_Session]     INT            NULL
);

