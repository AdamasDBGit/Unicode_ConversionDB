CREATE TABLE [MBP].[T_Product_Component] (
    [I_Product_Component_ID] INT          IDENTITY (1, 1) NOT NULL,
    [I_Product_ID]           INT          NULL,
    [I_Course_ID]            INT          NULL,
    [I_Course_Family_ID]     INT          NULL,
    [I_Status_ID]            INT          CONSTRAINT [DF_T_Product_Component_I_Status_ID] DEFAULT ((1)) NULL,
    [S_Crtd_By]              VARCHAR (20) NULL,
    [S_Upd_By]               VARCHAR (20) NULL,
    [Dt_Crtd_On]             DATETIME     NULL,
    [Dt_Upd_On]              DATETIME     NULL,
    CONSTRAINT [PK__T_Product_Compon__7B1DBD2E] PRIMARY KEY CLUSTERED ([I_Product_Component_ID] ASC)
);

