CREATE TABLE [PLACEMENT].[T_International_Certificate] (
    [I_Intnal_Certification_ID]      INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_International_Certificate_ID] INT NOT NULL,
    [I_Student_Detail_ID]            INT NOT NULL,
    [I_Status]                       INT NULL,
    CONSTRAINT [PK__T_International___0A943F91] PRIMARY KEY CLUSTERED ([I_Intnal_Certification_ID] ASC)
);

