CREATE TABLE [dbo].[T_School_Group] (
    [I_School_Group_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_Id]          INT            NULL,
    [S_School_Group_Code] NVARCHAR (20)  NULL,
    [S_School_Group_Name] NVARCHAR (255) NULL,
    [I_Status]            INT            NULL,
    [Dt_CreatedBy]        INT            NULL,
    [Dt_CreatedAt]        DATE           NULL,
    [Dt_UpdatedBy]        INT            NULL,
    [Dt_UpdatedAt]        DATE           NULL
);

