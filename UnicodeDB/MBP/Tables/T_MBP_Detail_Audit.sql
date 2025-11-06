CREATE TABLE [MBP].[T_MBP_Detail_Audit] (
    [I_MBP_Detail_Audit_ID] INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Product_ID]          INT             NULL,
    [I_Center_ID]           INT             NULL,
    [I_MBP_Detail_ID]       INT             NULL,
    [I_Status_ID]           INT             NULL,
    [I_Year]                INT             NULL,
    [I_Month]               INT             NULL,
    [I_Target_Enquiry]      INT             NULL,
    [I_Target_Booking]      NUMERIC (18, 2) NULL,
    [I_Target_Enrollment]   NUMERIC (18, 2) NULL,
    [I_Target_RFF]          NUMERIC (18, 2) NULL,
    [I_Target_Billing]      NUMERIC (18, 2) NULL,
    [I_Document_ID]         INT             NULL,
    [I_Type_ID]             INT             NULL,
    [S_Crtd_By]             VARCHAR (20)    NULL,
    [S_Upd_By]              VARCHAR (20)    NULL,
    [Dt_Crtd_On]            DATETIME        NULL,
    [Dt_Upd_On]             DATETIME        NULL,
    [S_Remarks]             VARCHAR (2000)  NULL,
    CONSTRAINT [PK__T_MBP_Detail_Aud__7E6F2B25] PRIMARY KEY CLUSTERED ([I_MBP_Detail_Audit_ID] ASC)
);

