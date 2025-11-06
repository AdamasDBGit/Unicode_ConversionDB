CREATE TABLE [ASSESSMENT].[T_PreAssessment_ExamComponent_Mapping] (
    [I_PreAssessment_ExamComponent_ID] INT          IDENTITY (1, 1) NOT NULL,
    [I_PreAssessment_ID]               INT          NULL,
    [I_Exam_Component_ID]              INT          NULL,
    [I_Total_Time]                     INT          NULL,
    [I_Status]                         INT          NULL,
    [S_Crtd_By]                        VARCHAR (20) NULL,
    [S_Upd_By]                         VARCHAR (20) NULL,
    [Dt_Crtd_On]                       DATETIME     NULL,
    [Dt_Upd_On]                        DATETIME     NULL,
    CONSTRAINT [PK_T_PreAssessment_ExamComponent_Mapping] PRIMARY KEY CLUSTERED ([I_PreAssessment_ExamComponent_ID] ASC)
);

