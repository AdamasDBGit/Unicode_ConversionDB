CREATE TABLE [dbo].[T_Center_Fund_Transfer] (
    [I_Center_Fund_Transfer_ID]   INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Center_ID]                 INT            NULL,
    [Dt_Period_Start]             DATETIME       NULL,
    [Dt_Period_End]               DATETIME       NULL,
    [B_Stop_Center_Fund_Transfer] BIT            NULL,
    [I_Status]                    INT            NULL,
    [S_Crtd_By]                   NVARCHAR (MAX) NULL,
    [S_Upd_By]                    NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                  DATETIME       NULL,
    [Dt_Upd_On]                   DATETIME       NULL,
    CONSTRAINT [PK_T_Center_Fund_Transfer] PRIMARY KEY CLUSTERED ([I_Center_Fund_Transfer_ID] ASC)
);

