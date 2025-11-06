CREATE TABLE [PSCERTIFICATE].[T_Certificate_Logistic] (
    [I_Logistic_ID]             INT           IDENTITY (1, 1) NOT NULL,
    [I_Student_Certificate_ID]  INT           NULL,
    [I_Student_Cert_Request_ID] INT           NULL,
    [S_Logistic_Serial_No]      VARCHAR (100) NULL,
    [S_Crtd_By]                 VARCHAR (20)  NULL,
    [S_Upd_By]                  VARCHAR (20)  NULL,
    [Dt_Crtd_On]                DATETIME      NULL,
    [Dt_Upd_On]                 DATETIME      NULL,
    [I_Status]                  INT           NULL
);

