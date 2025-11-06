CREATE TABLE [PSCERTIFICATE].[T_Student_Certificate_Request] (
    [I_Student_Cert_Request_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Student_Certificate_ID]  INT            NULL,
    [S_Student_FName]           VARCHAR (50)   NULL,
    [I_Exam_Marks]              INT            NULL,
    [S_Reiss_Reason]            VARCHAR (2000) NULL,
    [I_Status]                  INT            NULL,
    [S_Crtd_By]                 VARCHAR (20)   NULL,
    [S_Upd_By]                  VARCHAR (20)   NULL,
    [Dt_Crtd_On]                DATETIME       NULL,
    [Dt_Upd_On]                 DATETIME       NULL,
    [S_Student_MName]           VARCHAR (50)   NULL,
    [S_Student_LName]           VARCHAR (50)   NULL,
    [sRemarks]                  VARCHAR (2000) NULL
);

