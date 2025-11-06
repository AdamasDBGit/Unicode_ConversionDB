CREATE TABLE [dbo].[T_Faculty_Master] (
    [I_Faculty_Master_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Faculty_Code]      NVARCHAR (50)  NULL,
    [S_Faculty_Name]      NVARCHAR (MAX) NULL,
    [S_Faculty_Type]      NVARCHAR (50)  NULL,
    [Dt_DOJ]              DATE           NULL,
    [I_CreatedBy]         INT            NULL,
    [Dt_DOB]              DATE           NULL,
    [S_Gender]            NVARCHAR (50)  NULL,
    [I_Religion_ID]       INT            NULL,
    [I_Maritial_ID]       INT            NULL,
    [S_Photo]             NVARCHAR (MAX) NULL,
    [S_Signature]         NVARCHAR (MAX) NULL,
    [S_PAN]               NVARCHAR (50)  NULL,
    [S_Aadhaar]           NVARCHAR (50)  NULL,
    [S_Email]             NVARCHAR (100) NULL,
    [S_Mobile_No]         NVARCHAR (50)  NULL,
    [S_Present_Address]   NVARCHAR (MAX) NULL,
    [S_Permanent_Address] NVARCHAR (MAX) NULL,
    [Dt_CreatedAt]        DATETIME       NULL,
    [I_Status]            INT            NULL,
    [I_Brand_ID]          INT            NULL,
    [I_User_ID]           INT            NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'P-Permanent,C-Contractual', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'T_Faculty_Master', @level2type = N'COLUMN', @level2name = N'S_Faculty_Type';

