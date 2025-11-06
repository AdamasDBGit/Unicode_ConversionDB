CREATE TABLE [EXAMINATION].[T_Student_Question_Answer] (
    [I_Student_Question_Answer_ID] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Center_ID]                  INT            NOT NULL,
    [I_Exam_ID]                    INT            NOT NULL,
    [I_Student_Detail_ID]          INT            NOT NULL,
    [S_Answer_XML]                 XML            NULL,
    [N_Marks]                      NUMERIC (8, 2) NULL,
    [I_No_Of_Attempts]             INT            NULL,
    [S_Crtd_By]                    VARCHAR (20)   NULL,
    [S_Upd_By]                     VARCHAR (20)   NULL,
    [Dt_Crtd_On]                   DATETIME       NULL,
    [Dt_Upd_On]                    DATETIME       NULL,
    CONSTRAINT [PK__T_Student_Questi__0BC6C43E] PRIMARY KEY CLUSTERED ([I_Student_Question_Answer_ID] ASC)
);

