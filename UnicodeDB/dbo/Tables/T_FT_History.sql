CREATE TABLE [dbo].[T_FT_History] (
    [I_FT_History_ID] INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_FT_SAP_ID]     INT      NULL,
    [I_FT_ID]         INT      NULL,
    [Dt_FT_Date]      DATETIME NULL,
    [I_Center_ID]     INT      NULL,
    [I_Center_FT_ID]  INT      NULL,
    CONSTRAINT [PK_T_FT_History] PRIMARY KEY CLUSTERED ([I_FT_History_ID] ASC)
);

