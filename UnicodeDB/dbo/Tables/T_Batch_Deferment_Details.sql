CREATE TABLE [dbo].[T_Batch_Deferment_Details] (
    [I_Batch_Deferment_ID]     INT            IDENTITY (1, 1) NOT NULL,
    [I_Batch_ID]               INT            NULL,
    [Dt_Batch_Hold_Start_Date] DATETIME       NULL,
    [Dt_Batch_Hold_End_Date]   DATETIME       NULL,
    [Dt_Crtd_On]               DATETIME       NULL,
    [S_Crtd_By]                NVARCHAR (MAX) NULL,
    [S_Comment]                NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_T_Batch_Deferment_Details] PRIMARY KEY CLUSTERED ([I_Batch_Deferment_ID] ASC)
);

