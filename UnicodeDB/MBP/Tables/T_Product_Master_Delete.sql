CREATE TABLE [MBP].[T_Product_Master_Delete] (
    [ID]                    INT          IDENTITY (1, 1) NOT NULL,
    [I_Product_Id]          INT          NULL,
    [S_Product_Name]        VARCHAR (50) NULL,
    [S_Product_Description] VARCHAR (50) NULL,
    [I_Status_ID]           INT          NULL,
    [S_Crtd_By]             VARCHAR (20) NULL,
    [S_Upd_By]              VARCHAR (20) NULL,
    [Dt_Crtd_On]            DATETIME     NULL,
    [Dt_Upd_On]             DATETIME     NULL,
    [I_Brand_ID]            INT          NULL
);

