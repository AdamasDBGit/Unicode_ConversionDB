CREATE TABLE [EXAMINATION].[T_Offline_Examination_Master] (
    [I_Center_Offline_Exam_ID] INT          IDENTITY (1, 1) NOT NULL,
    [I_Center_ID]              INT          NOT NULL,
    [I_Exam_ID]                INT          NOT NULL,
    [S_Registration_No]        VARCHAR (20) NOT NULL,
    [I_Exam_Component_ID]      INT          NOT NULL,
    [S_Component_Name]         VARCHAR (50) NOT NULL,
    [Dt_Exam_Date]             DATETIME     NULL,
    [S_Question_XML]           XML          NULL
);

