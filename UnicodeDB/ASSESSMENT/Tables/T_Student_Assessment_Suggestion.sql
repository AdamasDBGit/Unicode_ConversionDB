CREATE TABLE [ASSESSMENT].[T_Student_Assessment_Suggestion] (
    [I_Enquiry_Regn_ID] INT NOT NULL,
    [I_CourseList_ID]   INT NOT NULL,
    CONSTRAINT [PK_T_Student_Assessment_Suggestion] PRIMARY KEY CLUSTERED ([I_Enquiry_Regn_ID] ASC, [I_CourseList_ID] ASC)
);

