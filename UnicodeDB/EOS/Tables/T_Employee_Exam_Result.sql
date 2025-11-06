CREATE TABLE [EOS].[T_Employee_Exam_Result] (
    [I_Employee_Exam_Result_ID] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Employee_ID]             INT            NULL,
    [I_Exam_Component_ID]       INT            NULL,
    [I_No_Of_Attempts]          INT            NULL,
    [N_Marks]                   NUMERIC (8, 2) NULL,
    [B_Passed]                  BIT            NULL,
    [S_Answer_XML]              XML            NULL,
    [S_Crtd_By]                 VARCHAR (20)   NULL,
    [S_Upd_By]                  VARCHAR (20)   NULL,
    [Dt_Crtd_On]                DATETIME       NULL,
    [Dt_Upd_On]                 DATETIME       NULL,
    [I_Enquiry_Regn_ID]         INT            NULL,
    CONSTRAINT [PK__T_Employee_Exam___53B90BF3] PRIMARY KEY CLUSTERED ([I_Employee_Exam_Result_ID] ASC)
);

