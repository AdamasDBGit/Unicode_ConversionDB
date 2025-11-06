CREATE TABLE [dbo].[T_ERP_User_Profile] (
    [I_User_Profile_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [I_User_ID]           INT            NOT NULL,
    [S_EMP_Code]          NVARCHAR (50)  NULL,
    [S_EMP_Type]          NVARCHAR (50)  NULL,
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
    [S_Present_Address]   NVARCHAR (MAX) NULL,
    [S_Permanent_Address] NVARCHAR (MAX) NULL,
    [Dt_CreatedAt]        DATETIME       NULL,
    [I_Status]            INT            NULL,
    [I_Brand_ID]          INT            NULL
);

