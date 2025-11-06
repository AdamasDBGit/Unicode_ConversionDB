CREATE TABLE [dbo].[T_Transport_History] (
    [I_Transport_History_ID] INT             IDENTITY (1, 1) NOT NULL,
    [I_PickupPoint_ID]       INT             NOT NULL,
    [I_Brand_ID]             INT             NULL,
    [S_PickupPoint_Name]     NVARCHAR (MAX)  NULL,
    [N_Fees]                 NUMERIC (18, 2) NULL,
    [I_Status]               INT             NULL,
    [S_Crtd_By]              NVARCHAR (MAX)  NULL,
    [Dt_Crtd_On]             DATETIME        NULL,
    [S_Updt_By]              NVARCHAR (MAX)  NULL,
    [Dt_Updt_On]             DATETIME        NULL,
    [S_Academic_Session]     NVARCHAR (MAX)  NULL,
    CONSTRAINT [PK_T_Transport_History] PRIMARY KEY CLUSTERED ([I_Transport_History_ID] ASC)
);

