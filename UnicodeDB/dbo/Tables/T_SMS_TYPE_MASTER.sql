CREATE TABLE [dbo].[T_SMS_TYPE_MASTER] (
    [I_SMS_TYPE_ID]       INT            IDENTITY (1, 1) NOT NULL,
    [S_SMS_TYPE_NAME]     NVARCHAR (MAX) NOT NULL,
    [S_SMS_BODY_TEMPLATE] NVARCHAR (MAX) NOT NULL,
    [I_REFERENCE_TYPE_ID] INT            NOT NULL,
    [I_Status]            INT            NULL,
    [DLT_ID]              NVARCHAR (MAX) NULL,
    [I_Brand_ID]          INT            NULL,
    CONSTRAINT [PK_T_SMS_TYPE_MASTER] PRIMARY KEY CLUSTERED ([I_SMS_TYPE_ID] ASC)
);

