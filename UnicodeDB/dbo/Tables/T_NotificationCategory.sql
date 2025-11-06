CREATE TABLE [dbo].[T_NotificationCategory] (
    [I_NotificationCategory_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_NotificationCategory_Name] NVARCHAR (200) NOT NULL,
    [I_Status]                    INT            NULL,
    [S_CreatedBy]                 NVARCHAR (50)  NULL,
    [Dt_CreatedOn]                DATETIME       NULL,
    [S_UpdatedBy]                 NVARCHAR (50)  NULL,
    [Dt_UpdatedOn]                DATETIME       NULL
);

