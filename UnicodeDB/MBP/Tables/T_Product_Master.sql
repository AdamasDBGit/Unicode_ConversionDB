CREATE TABLE [MBP].[T_Product_Master] (
    [I_Product_ID]          INT          IDENTITY (1, 1) NOT NULL,
    [S_Product_Name]        VARCHAR (50) NULL,
    [S_Product_Description] VARCHAR (50) NOT NULL,
    [I_Status_ID]           INT          CONSTRAINT [DF_T_Product_Master_I_Status_ID] DEFAULT ((1)) NULL,
    [S_Crtd_By]             VARCHAR (20) NULL,
    [S_Upd_By]              VARCHAR (20) NULL,
    [Dt_Crtd_On]            DATETIME     NULL,
    [Dt_Upd_On]             DATETIME     NULL,
    [I_Brand_ID]            INT          NULL,
    CONSTRAINT [PK__T_Product_Master__7D0605A0] PRIMARY KEY CLUSTERED ([I_Product_ID] ASC)
);

