CREATE TABLE [STUDENTFEATURES].[T_Student_Feedback] (
    [I_Student_Feedback_ID]      INT          IDENTITY (1, 1) NOT NULL,
    [I_Student_Module_Detail_ID] INT          NULL,
    [I_Employee_ID]              INT          NULL,
    [I_Status]                   INT          NULL,
    [S_Crtd_By]                  VARCHAR (20) NULL,
    [S_Upd_By]                   VARCHAR (20) NULL,
    [Dt_Crtd_On]                 DATETIME     NULL,
    [Dt_Upd_On]                  DATETIME     NULL,
    [I_User_ID]                  INT          NULL,
    [I_Enquiry_Regn_ID]          INT          NULL,
    [I_Course_ID]                INT          NULL,
    [I_Student_ID]               INT          NULL,
    CONSTRAINT [PK_T_Student_Feedback] PRIMARY KEY CLUSTERED ([I_Student_Feedback_ID] ASC)
);

