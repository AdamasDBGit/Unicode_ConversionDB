CREATE TYPE [dbo].[UT_Route] AS TABLE (
    [I_PickupPoint_ID] INT            NULL,
    [S_Pickup_Name]    VARCHAR (5000) NULL,
    [S_Landmark]       VARCHAR (5000) NULL,
    [S_Location]       VARCHAR (5000) NULL,
    [S_Latitude]       VARCHAR (5000) NULL,
    [S_Longitude]      VARCHAR (5000) NULL,
    [S_Pickup_Order]   INT            NULL,
    [S_Drop_Order]     INT            NULL);

