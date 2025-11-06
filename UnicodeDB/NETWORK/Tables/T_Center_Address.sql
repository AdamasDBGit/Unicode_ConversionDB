CREATE TABLE [NETWORK].[T_Center_Address] (
    [I_Center_Address_ID]   INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Centre_Id]           INT           NULL,
    [S_Center_Address1]     VARCHAR (100) NULL,
    [S_Center_Address2]     VARCHAR (100) NULL,
    [I_City_ID]             INT           NULL,
    [I_State_ID]            INT           NULL,
    [S_Pin_Code]            VARCHAR (10)  NULL,
    [I_Country_ID]          INT           NULL,
    [S_Telephone_No]        VARCHAR (20)  NULL,
    [S_Email_ID]            VARCHAR (50)  NULL,
    [S_Delivery_Address1]   VARCHAR (100) NULL,
    [S_Delivery_Address2]   VARCHAR (100) NULL,
    [I_Delivery_City_ID]    INT           NULL,
    [I_Delivery_State_ID]   INT           NULL,
    [S_Delivery_Pin_No]     VARCHAR (20)  NULL,
    [I_Delivery_Country_ID] INT           NULL,
    [S_Delivery_Phone_No]   VARCHAR (20)  NULL,
    [S_Delivery_Email_ID]   VARCHAR (50)  NULL,
    [I_Brand_ID]            INT           NULL,
    CONSTRAINT [PK__T_Center_Address__56757D0D] PRIMARY KEY CLUSTERED ([I_Center_Address_ID] ASC)
);

