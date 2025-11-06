CREATE TABLE [PSCERTIFICATE].[T_File_Upload] (
    [I_File_ID]                 INT            IDENTITY (1, 1) NOT NULL,
    [I_Student_Cert_Request_ID] INT            NULL,
    [S_File_Path]               VARCHAR (2000) NULL,
    [S_Crtd_By]                 VARCHAR (20)   NULL,
    [S_Upd_By]                  VARCHAR (20)   NULL,
    [Dt_Crtd_On]                DATETIME       NULL,
    [Dt_Upd_On]                 DATETIME       NULL
);

