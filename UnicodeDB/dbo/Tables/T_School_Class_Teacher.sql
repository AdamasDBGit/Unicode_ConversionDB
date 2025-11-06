CREATE TABLE [dbo].[T_School_Class_Teacher] (
    [I_School_Class_Teacher_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_School_Group_Class_ID]   INT            NOT NULL,
    [I_Stream_ID]               INT            NULL,
    [I_Section_ID]              INT            NULL,
    [S_Class_Teacher_Name]      NVARCHAR (MAX) NULL,
    [S_Class_Teacher_Signature] NVARCHAR (MAX) NULL,
    [S_Email]                   NVARCHAR (200) NULL,
    [Dt_Start_Date]             DATE           NULL,
    [Dt_End_Date]               DATE           NULL,
    [I_Status]                  INT            CONSTRAINT [DF_T_School_Class_Teacher_I_Status] DEFAULT ((0)) NULL,
    [Dt_CreatedBy]              INT            NULL,
    [Dt_CreatedAt]              DATETIME       NULL,
    [sms_user_id]               NVARCHAR (50)  NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'T_School_Class_Teacher', @level2type = N'COLUMN', @level2name = N'Dt_Start_Date';

