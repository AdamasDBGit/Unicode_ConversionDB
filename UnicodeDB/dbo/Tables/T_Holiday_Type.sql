CREATE TABLE [dbo].[T_Holiday_Type] (
    [I_Holiday_Type_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Holiday_Type_Name] NVARCHAR (MAX) NOT NULL,
    [I_Status]            INT            CONSTRAINT [DF__Holiday_C__I_Sta__3FF170DB] DEFAULT ((1)) NOT NULL,
    [S_CreatedBy]         NVARCHAR (MAX) NOT NULL,
    [Dt_CreatedOn]        DATETIME       NOT NULL,
    [S_UpdatedBy]         NVARCHAR (MAX) NULL,
    [Dt_UpdatedOn]        DATETIME       NULL
);

