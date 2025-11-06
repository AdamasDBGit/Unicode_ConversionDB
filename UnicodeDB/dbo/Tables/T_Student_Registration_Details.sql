CREATE TABLE [dbo].[T_Student_Registration_Details] (
    [I_Registration_ID]       INT             IDENTITY (1, 1) NOT NULL,
    [I_Enquiry_Regn_ID]       INT             NULL,
    [I_Batch_ID]              INT             NULL,
    [I_Origin_Center_Id]      INT             NULL,
    [I_Receipt_Header_ID]     INT             NULL,
    [I_Status]                INT             NULL,
    [Crtd_By]                 NVARCHAR (MAX)  NULL,
    [Crtd_On]                 DATETIME        NULL,
    [Updt_By]                 NVARCHAR (MAX)  NULL,
    [Updt_On]                 DATETIME        NULL,
    [I_Destination_Center_ID] INT             NULL,
    [I_Fee_Plan_ID]           INT             NULL,
    [N_Referral_Amount]       DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_T_Student_Registration_Details] PRIMARY KEY CLUSTERED ([I_Registration_ID] ASC)
);

