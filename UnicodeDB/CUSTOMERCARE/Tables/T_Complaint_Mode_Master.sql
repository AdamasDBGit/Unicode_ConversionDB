CREATE TABLE [CUSTOMERCARE].[T_Complaint_Mode_Master] (
    [I_Complaint_Mode_ID]    INT          IDENTITY (1, 1) NOT NULL,
    [I_Status_ID]            INT          NULL,
    [S_Complaint_Mode_Value] VARCHAR (20) NULL,
    [S_Complaint_Mode_Code]  VARCHAR (20) NULL,
    [S_Crtd_By]              VARCHAR (20) NULL,
    [S_Upd_By]               VARCHAR (20) NULL,
    [Dt_Crtd_On]             DATETIME     NULL,
    [Dt_Upd_On]              DATETIME     NULL,
    CONSTRAINT [PK__T_Complaint_Mode__44CB02C7] PRIMARY KEY CLUSTERED ([I_Complaint_Mode_ID] ASC)
);

