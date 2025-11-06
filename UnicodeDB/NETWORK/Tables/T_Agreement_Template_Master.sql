CREATE TABLE [NETWORK].[T_Agreement_Template_Master] (
    [I_Agreement_Template_ID]   INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_Agreement_Template_Code] VARCHAR (20) NULL,
    [I_Country_ID]              INT          NULL,
    [I_Document_ID]             INT          NULL,
    [I_Status]                  INT          NULL,
    [S_Crtd_By]                 VARCHAR (20) NULL,
    [S_Upd_By]                  VARCHAR (20) NULL,
    [Dt_Crtd_On]                DATETIME     NULL,
    [Dt_Upd_On]                 DATETIME     NULL,
    CONSTRAINT [PK__T_Agreement_Temp__52A4EC29] PRIMARY KEY CLUSTERED ([I_Agreement_Template_ID] ASC)
);

