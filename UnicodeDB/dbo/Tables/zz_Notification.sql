CREATE TABLE [dbo].[zz_Notification] (
    [Notification ID]        FLOAT (53)     NULL,
    [Notification Log ID]    FLOAT (53)     NULL,
    [Student ID]             NVARCHAR (255) NULL,
    [Student Name]           NVARCHAR (255) NULL,
    [Notification Type]      NVARCHAR (255) NULL,
    [Category]               NVARCHAR (255) NULL,
    [Priority]               NVARCHAR (255) NULL,
    [Delivery Channel]       NVARCHAR (255) NULL,
    [Recipient Name]         NVARCHAR (255) NULL,
    [Notification Date Time] NVARCHAR (255) NULL,
    [Message Content]        NVARCHAR (255) NULL,
    [Is Attachment Present]  NVARCHAR (255) NULL,
    [Created By]             NVARCHAR (255) NULL,
    [Created Date]           NVARCHAR (255) NULL,
    [Push Title]             NVARCHAR (255) NULL,
    [Email Subject]          NVARCHAR (255) NULL,
    [Render Message Body]    NVARCHAR (255) NULL,
    [Notification Status]    NVARCHAR (255) NULL,
    [Send Status]            NVARCHAR (255) NULL
);

