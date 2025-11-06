CREATE TABLE [dbo].[T_Transport_Master] (
    [I_PickupPoint_ID]       INT             IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]             INT             NULL,
    [S_PickupPoint_Name]     NVARCHAR (MAX)  NULL,
    [N_Fees]                 NUMERIC (18, 2) NULL,
    [I_Status]               INT             NULL,
    [S_Crtd_By]              NVARCHAR (MAX)  NULL,
    [Dt_Crtd_On]             DATETIME        NULL,
    [S_Updt_By]              NVARCHAR (MAX)  NULL,
    [Dt_Updt_On]             DATETIME        NULL,
    [pickup_longitude]       NVARCHAR (MAX)  NULL,
    [pickup_latitude]        NVARCHAR (MAX)  NULL,
    [pickup_index]           INT             NULL,
    [drop_index]             INT             NULL,
    [PickPoint_Landmark]     NVARCHAR (MAX)  NULL,
    [Pickup_Full_Address]    NVARCHAR (MAX)  NULL,
    [flag]                   TINYINT         NULL,
    [S_PickupPoint_Location] NVARCHAR (MAX)  NULL,
    [Fare_Code]              NVARCHAR (MAX)  NULL
);

