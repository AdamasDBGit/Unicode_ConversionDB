CREATE TABLE [NETWORK].[T_Hardware_Master] (
    [I_Hardware_ID]   INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Brand_ID]      INT           NULL,
    [I_Plan_ID]       INT           NULL,
    [S_Hardware_Item] VARCHAR (20)  NULL,
    [S_Rec_Spec]      VARCHAR (200) NULL,
    [S_Rec_No]        VARCHAR (50)  NULL,
    [S_Crtd_By]       VARCHAR (20)  NULL,
    [S_Upd_By]        VARCHAR (20)  NULL,
    [Dt_Crtd_On]      DATETIME      NULL,
    [Dt_Upd_On]       DATETIME      NULL,
    [I_Status]        INT           NULL,
    CONSTRAINT [PK__T_Hardware_Maste__63CF782B] PRIMARY KEY CLUSTERED ([I_Hardware_ID] ASC)
);

