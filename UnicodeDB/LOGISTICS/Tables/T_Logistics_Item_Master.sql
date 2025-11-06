CREATE TABLE [LOGISTICS].[T_Logistics_Item_Master] (
    [I_Logistics_Item_ID]  INT           IDENTITY (1, 1) NOT NULL,
    [S_Logistic_Item_Code] VARCHAR (20)  NULL,
    [S_Logistics_Desc]     VARCHAR (100) NULL,
    [S_Crtd_By]            VARCHAR (20)  NULL,
    [S_Upd_By]             VARCHAR (20)  NULL,
    [Dt_Crtd_On]           DATETIME      NULL,
    [Dt_Upd_On]            DATETIME      NULL
);

