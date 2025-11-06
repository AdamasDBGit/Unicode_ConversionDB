CREATE TABLE [NETWORK].[T_BP_Master] (
    [I_BP_ID]    INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_BP_Type]  VARCHAR (20) NOT NULL,
    [S_Crtd_By]  VARCHAR (20) NULL,
    [S_Upd_By]   VARCHAR (20) NULL,
    [Dt_Crtd_On] DATETIME     NULL,
    [Dt_Upd_On]  DATETIME     NULL,
    [I_Status]   INT          NULL,
    CONSTRAINT [PK__T_BP_Master__548D349B] PRIMARY KEY CLUSTERED ([I_BP_ID] ASC)
);

