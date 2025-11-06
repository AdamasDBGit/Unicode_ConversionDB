CREATE TYPE [dbo].[UT_Transport_Fees] AS TABLE (
    [Route_No]           VARCHAR (4000)  NULL,
    [I_PickupPoint_ID]   INT             NULL,
    [Pickup_Point_Name]  VARCHAR (5000)  NULL,
    [Transport_Fee_Head] VARCHAR (5000)  NULL,
    [Configuration_Name] VARCHAR (5000)  NULL,
    [Monthly_Amount]     NUMERIC (10, 2) NULL,
    [Bimonthly_Amount]   NUMERIC (10, 2) NULL,
    [Quarterly_Amount]   NUMERIC (10, 2) NULL,
    [Yearly_Amount]      NUMERIC (10, 2) NULL);

