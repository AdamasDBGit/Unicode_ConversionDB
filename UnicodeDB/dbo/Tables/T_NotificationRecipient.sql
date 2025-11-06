CREATE TABLE [dbo].[T_NotificationRecipient] (
    [I_NotificationRecepient_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_NotificationSchedule_ID]  INT            NOT NULL,
    [I_Recepient_ID]             INT            NOT NULL,
    [S_MobileNumber]             NVARCHAR (50)  NULL,
    [S_FireBase_Token]           NVARCHAR (MAX) NULL,
    [S_Email]                    NVARCHAR (50)  NULL,
    [I_Type]                     INT            NULL,
    [I_Sent]                     INT            NULL,
    [S_CreatedBy]                NVARCHAR (50)  NULL,
    [Dt_CreatedOn]               DATETIME       NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Student=1,Teacher=2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'T_NotificationRecipient', @level2type = N'COLUMN', @level2name = N'I_Type';

