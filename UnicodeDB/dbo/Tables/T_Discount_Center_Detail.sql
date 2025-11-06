CREATE TABLE [dbo].[T_Discount_Center_Detail] (
    [I_Discount_Center_Detail_ID] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Discount_Scheme_ID]        INT            NULL,
    [I_Centre_ID]                 INT            NULL,
    [I_Status]                    INT            NULL,
    [S_Crtd_By]                   NVARCHAR (MAX) NULL,
    [S_Upd_By]                    NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                  DATETIME       NULL,
    [Dt_Upd_On]                   DATETIME       NULL,
    CONSTRAINT [PK_T_Discount_Center_Detail] PRIMARY KEY CLUSTERED ([I_Discount_Center_Detail_ID] ASC)
);

