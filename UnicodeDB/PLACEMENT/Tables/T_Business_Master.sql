CREATE TABLE [PLACEMENT].[T_Business_Master] (
    [I_Nature_of_Business]   INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_Description_Business] VARCHAR (50) NULL,
    [S_Crtd_By]              VARCHAR (20) NULL,
    [S_Upd_By]               VARCHAR (20) NULL,
    [Dt_Crtd_On]             DATETIME     NULL,
    [Dt_Upd_On]              DATETIME     NULL,
    [I_Status]               INT          NOT NULL,
    CONSTRAINT [PK__T_Business_Maste__7D6461A5] PRIMARY KEY CLUSTERED ([I_Nature_of_Business] ASC)
);

