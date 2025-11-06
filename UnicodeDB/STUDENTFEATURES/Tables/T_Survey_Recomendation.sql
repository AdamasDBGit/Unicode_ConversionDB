CREATE TABLE [STUDENTFEATURES].[T_Survey_Recomendation] (
    [I_SQ_Recomendation_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_User_ID]             INT            NULL,
    [S_Recomendation]       VARCHAR (1000) NULL,
    [S_Crtd_By]             VARCHAR (20)   NULL,
    [S_Upd_By]              VARCHAR (20)   NULL,
    [Dt_Crtd_On]            DATETIME       NULL,
    [Dt_Upd_On]             DATETIME       NULL,
    CONSTRAINT [PK__T_Survey__CB7D49CF789CB0F6] PRIMARY KEY CLUSTERED ([I_SQ_Recomendation_ID] ASC)
);

