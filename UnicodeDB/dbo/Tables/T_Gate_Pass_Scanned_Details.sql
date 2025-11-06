CREATE TABLE [dbo].[T_Gate_Pass_Scanned_Details] (
    [I_Gate_Pass_Scanned_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Gate_Pass_Guard_ID]   INT            NOT NULL,
    [I_Gate_Pass_Request_ID] INT            NOT NULL,
    [S_CreatedBy]            NVARCHAR (MAX) NULL,
    [Dt_CreatedOn]           DATETIME       NULL,
    [S_UpdatedBy]            NVARCHAR (MAX) NULL,
    [Dt_UpdatedOn]           DATETIME       NULL
);

