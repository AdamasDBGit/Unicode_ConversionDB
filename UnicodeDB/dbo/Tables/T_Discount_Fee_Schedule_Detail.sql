CREATE TABLE [dbo].[T_Discount_Fee_Schedule_Detail] (
    [I_Discount_Fee_Schedule_Detail_ID] INT      IDENTITY (1, 1) NOT NULL,
    [I_ERP_Fee_Structure_ID]            INT      NULL,
    [I_Discount_Brand_ID]               INT      NULL,
    [I_Status_ID]                       INT      NULL,
    [S_Crtd_By]                         INT      NULL,
    [S_Upd_By]                          INT      NULL,
    [Dt_Crtd_On]                        DATETIME NULL,
    [Dt_Upd_On]                         DATETIME NULL
);

