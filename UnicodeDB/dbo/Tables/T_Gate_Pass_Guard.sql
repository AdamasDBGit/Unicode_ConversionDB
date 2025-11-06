CREATE TABLE [dbo].[T_Gate_Pass_Guard] (
    [I_Gate_Pass_Guard_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_First_Name]         NVARCHAR (50)  NOT NULL,
    [S_Middle_Name]        NVARCHAR (50)  NULL,
    [S_Last_Name]          NVARCHAR (50)  NULL,
    [I_EMP_No]             INT            NULL,
    [S_Phone_No]           NVARCHAR (MAX) NOT NULL,
    [S_Email_ID]           NVARCHAR (50)  NULL,
    [S_Address]            NVARCHAR (100) NULL,
    [S_Token]              NVARCHAR (MAX) NOT NULL,
    [S_CreatedBy]          NVARCHAR (MAX) NULL,
    [Dt_CreatedOn]         DATETIME       NULL,
    [S_UpdateBy]           NVARCHAR (MAX) NULL,
    [Dt_UpdatedOn]         DATETIME       NULL
);

