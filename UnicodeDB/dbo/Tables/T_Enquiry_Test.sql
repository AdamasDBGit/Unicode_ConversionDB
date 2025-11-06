CREATE TABLE [dbo].[T_Enquiry_Test] (
    [I_Enquiry_Test_ID]     INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Exam_Component_ID]   INT             NULL,
    [I_Enquiry_Regn_ID]     INT             NULL,
    [Dt_Test_Date]          DATETIME        NOT NULL,
    [N_Marks]               DECIMAL (18, 2) NULL,
    [S_Answer]              XML             NULL,
    [bypass_Admission_Test] BIT             NULL,
    CONSTRAINT [PK__T_Enquiry_Test__1022305E] PRIMARY KEY CLUSTERED ([I_Enquiry_Test_ID] ASC)
);

