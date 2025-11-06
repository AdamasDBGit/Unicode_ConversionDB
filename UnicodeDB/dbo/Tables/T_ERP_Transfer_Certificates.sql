CREATE TABLE [dbo].[T_ERP_Transfer_Certificates] (
    [I_Transfer_Cert_Req_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Student_Detail_ID]    INT            NULL,
    [I_Transfer_Req_Status]  INT            NULL,
    [TC_Serial_No]           NVARCHAR (MAX) NULL,
    [Proposed_Release_Date]  DATETIME       NULL,
    [Actual_Release_Date]    DATETIME       NULL,
    [Is_Released]            BIT            CONSTRAINT [DF_T_ERP_Transfer_Certificates_Is_Released] DEFAULT ((0)) NULL,
    [S_Remarks]              NVARCHAR (MAX) NULL,
    [I_Created_By]           INT            NULL,
    [I_Updated_By]           INT            NULL,
    [Dt_Crtd_On]             DATETIME       NULL,
    [Dt_Upd_On]              DATETIME       NULL,
    [I_Brand_ID]             INT            NULL,
    [I_School_Session_ID]    INT            NULL,
    CONSTRAINT [PK_T_ERP_Transfer_Certificates] PRIMARY KEY CLUSTERED ([I_Transfer_Cert_Req_ID] ASC)
);

