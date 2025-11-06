CREATE TABLE [ACADEMICS].[T_Dropout_Type_Master] (
    [I_Dropout_Type_ID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_Description]     VARCHAR (50) NULL,
    [S_Crtd_By]         VARCHAR (20) NULL,
    [S_Upd_By]          VARCHAR (20) NULL,
    [Dt_Crtd_On]        DATETIME     NULL,
    [Dt_Upd_On]         DATETIME     NULL,
    CONSTRAINT [PK__T_Dropout_Type_M__5CD79682] PRIMARY KEY CLUSTERED ([I_Dropout_Type_ID] ASC)
);

