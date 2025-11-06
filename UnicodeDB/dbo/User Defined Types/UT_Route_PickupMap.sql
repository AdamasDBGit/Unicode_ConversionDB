CREATE TYPE [dbo].[UT_Route_PickupMap] AS TABLE (
    [I_Brand_Id]          INT             NOT NULL,
    [I_PickupPoint_ID]    INT             NULL,
    [S_PickupPoint_Name]  VARCHAR (500)   NULL,
    [PickPoint_Landmark]  VARCHAR (500)   NULL,
    [Pickup_Full_Address] VARCHAR (500)   NULL,
    [pickup_latitude]     VARCHAR (50)    NULL,
    [pickup_longitude]    VARCHAR (50)    NULL,
    [pickup_order]        INT             NULL,
    [drop_order]          INT             NULL,
    [N_Fees]              NUMERIC (18, 2) NULL);

