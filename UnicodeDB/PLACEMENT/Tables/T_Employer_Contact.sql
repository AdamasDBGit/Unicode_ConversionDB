CREATE TABLE [PLACEMENT].[T_Employer_Contact] (
    [I_Employer_Contact_ID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Employer_ID]         INT           NULL,
    [S_Contact_Name]        VARCHAR (50)  NULL,
    [S_Contact_Designation] VARCHAR (50)  NULL,
    [S_Contact_Address]     VARCHAR (150) NULL,
    [S_Email]               VARCHAR (50)  NULL,
    [S_Telephone]           VARCHAR (20)  NULL,
    [S_Cellphone]           VARCHAR (20)  NULL,
    [S_Fax]                 VARCHAR (20)  NULL,
    [B_Is_Primary]          BIT           NULL,
    [S_Crtd_By]             VARCHAR (20)  NULL,
    [S_Upd_By]              VARCHAR (20)  NULL,
    [Dt_Crtd_On]            DATETIME      NULL,
    [Dt_Upd_On]             DATETIME      NULL,
    [I_Status]              INT           NULL,
    CONSTRAINT [PK__T_Employer_Conta__3B61941E] PRIMARY KEY CLUSTERED ([I_Employer_Contact_ID] ASC)
);

