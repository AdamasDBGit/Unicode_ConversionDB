CREATE TABLE [CUSTOMERCARE].[T_Root_Cause_Master] (
    [I_Root_Cause_ID]         INT            IDENTITY (1, 1) NOT NULL,
    [I_Status_ID]             INT            NULL,
    [I_Complaint_Category_ID] INT            NULL,
    [S_Root_Cause_Code]       VARCHAR (20)   NULL,
    [S_Root_Cause_Desc]       VARCHAR (2000) NULL,
    [S_Crtd_By]               VARCHAR (20)   NULL,
    [S_Upd_By]                VARCHAR (20)   NULL,
    [Dt_Crtd_On]              DATETIME       NULL,
    [Dt_Upd_On]               DATETIME       NULL,
    [I_Brand_ID]              INT            NULL,
    CONSTRAINT [PK__T_Root_Cause_Mas__6A86975B] PRIMARY KEY CLUSTERED ([I_Root_Cause_ID] ASC)
);

