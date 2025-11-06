CREATE TABLE [LOGISTICS].[T_Kit_Master] (
    [I_Kit_ID]       INT           IDENTITY (1, 1) NOT NULL,
    [S_Kit_Code]     VARCHAR (20)  NULL,
    [S_Kit_Desc]     VARCHAR (200) NULL,
    [I_Kit_Rate_INR] FLOAT (53)    NULL,
    [I_Kit_Rate_USD] FLOAT (53)    NULL,
    [S_Crtd_By]      VARCHAR (20)  NULL,
    [S_Upd_By]       VARCHAR (20)  NULL,
    [Dt_Crtd_On]     DATETIME      NULL,
    [Dt_Upd_On]      DATETIME      NULL,
    [I_Kit_Mode]     INT           NULL
);

