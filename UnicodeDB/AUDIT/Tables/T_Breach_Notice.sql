CREATE TABLE [AUDIT].[T_Breach_Notice] (
    [I_Breach_Notice_ID] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Center_ID]        INT            NULL,
    [Dt_Letter_Issue_On] DATETIME       NULL,
    [S_Remarks]          VARCHAR (2000) NULL,
    [I_Document_ID]      INT            NULL,
    [S_Crtd_By]          VARCHAR (20)   NULL,
    [S_Updt_By]          VARCHAR (20)   NULL,
    [Dt_Crtd_By]         DATETIME       NULL,
    [Dt_Upd_On]          DATETIME       NULL,
    CONSTRAINT [PK__T_Breach_Notice__391AEFA7] PRIMARY KEY CLUSTERED ([I_Breach_Notice_ID] ASC)
);

