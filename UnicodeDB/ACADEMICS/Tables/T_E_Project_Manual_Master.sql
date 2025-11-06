CREATE TABLE [ACADEMICS].[T_E_Project_Manual_Master] (
    [I_E_Proj_Manual_ID]        INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Center_ID]               INT          NULL,
    [Dt_Crtd_On]                DATETIME     NULL,
    [Dt_Upd_On]                 DATETIME     NULL,
    [S_Crtd_By]                 VARCHAR (20) NULL,
    [S_Upd_By]                  VARCHAR (20) NULL,
    [I_Course_ID]               INT          NULL,
    [I_Term_ID]                 INT          NULL,
    [I_Module_ID]               INT          NULL,
    [I_Is_Manual_No_Compulsory] INT          NULL,
    CONSTRAINT [PK__T_E_Project_Manu__4278A601] PRIMARY KEY CLUSTERED ([I_E_Proj_Manual_ID] ASC)
);

