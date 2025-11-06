CREATE TABLE [EOS].[T_Employee_KRA_Details] (
    [I_Employee_KRA_Detail_ID] INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Employee_ID]            INT             NOT NULL,
    [I_KRA_ID]                 INT             NOT NULL,
    [I_SubKRA_ID]              INT             NULL,
    [I_Target_Month]           INT             NULL,
    [I_Target_Year]            INT             NULL,
    [N_Target_Achieved]        NUMERIC (18, 2) NULL,
    [N_Target_Set]             NUMERIC (18, 2) NULL,
    [S_Crtd_By]                VARCHAR (20)    NULL,
    [S_Upd_By]                 VARCHAR (20)    NULL,
    [Dt_Crtd_On]               DATETIME        NULL,
    [Dt_Upd_On]                DATETIME        NULL,
    [S_Performance_Evaluation] VARCHAR (500)   NULL,
    CONSTRAINT [PK__T_Employee_KRA_D__3440609A] PRIMARY KEY CLUSTERED ([I_Employee_KRA_Detail_ID] ASC)
);

