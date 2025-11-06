CREATE TABLE [LOGISTICS].[T_Kit_Logistics] (
    [I_Kit_Logistics_ID] INT          IDENTITY (1, 1) NOT NULL,
    [I_Kit_ID]           INT          NULL,
    [I_Logistics_ID]     INT          NULL,
    [I_Kit_Qty]          INT          NULL,
    [S_Crtd_By]          VARCHAR (20) NULL,
    [S_Upd_By]           VARCHAR (20) NULL,
    [Dt_Crtd_On]         DATETIME     NULL,
    [Dt_Upd_On]          DATETIME     NULL
);

