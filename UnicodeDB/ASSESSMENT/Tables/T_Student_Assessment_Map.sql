CREATE TABLE [ASSESSMENT].[T_Student_Assessment_Map] (
    [I_Enquiry_Regn_ID]   INT NOT NULL,
    [I_PreAssessment_ID]  INT NOT NULL,
    [I_Exam_Component_ID] INT NOT NULL,
    [B_Is_Complete]       BIT NULL,
    [Total_Marks]         INT NULL,
    CONSTRAINT [PK_T_Student_Assessment_Map] PRIMARY KEY CLUSTERED ([I_Enquiry_Regn_ID] ASC, [I_PreAssessment_ID] ASC, [I_Exam_Component_ID] ASC)
);

