CREATE TABLE [LOGISTICS].[T_Student_Despatch_Detailed] (
    [I_Despatch_ID]       INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Student_Detail_ID] INT          NULL,
    [I_Center_ID]         INT          NULL,
    [I_Kit_ID]            INT          NULL,
    [Dt_Dispatch_Date]    DATETIME     NULL,
    [S_Docket_No]         VARCHAR (50) NULL,
    [S_Transporter_Name]  VARCHAR (50) NULL,
    [I_Installment_No]    INT          NULL,
    [I_Status]            INT          NULL,
    [S_Crtd_By]           VARCHAR (20) NULL,
    [S_Upd_By]            VARCHAR (20) NULL,
    [Dt_Crtd_On]          DATETIME     NULL,
    [Dt_Upd_On]           DATETIME     NULL,
    CONSTRAINT [PK_T_Student_Despatch_Detailed] PRIMARY KEY CLUSTERED ([I_Despatch_ID] ASC)
);

