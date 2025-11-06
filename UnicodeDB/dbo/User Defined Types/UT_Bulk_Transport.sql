CREATE TYPE [dbo].[UT_Bulk_Transport] AS TABLE (
    [U_Old_Route_No]   VARCHAR (255)   NULL,
    [U_New_Route_No]   VARCHAR (255)   NULL,
    [U_Start_Location] VARCHAR (500)   NULL,
    [U_Pickup_Name]    VARCHAR (500)   NULL,
    [U_Landmark]       VARCHAR (500)   NULL,
    [U_Fulladdress]    VARCHAR (500)   NULL,
    [U_Pickup_Order]   INT             NULL,
    [U_Drop_Order]     INT             NULL,
    [U_Monthly_Fee]    DECIMAL (18, 2) NULL);

