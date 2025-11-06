CREATE TABLE [dbo].[T_BusRoute_Master] (
    [I_Route_ID]      INT            IDENTITY (1, 1) NOT NULL,
    [S_Route_No]      NVARCHAR (MAX) NOT NULL,
    [I_Status]        INT            NULL,
    [S_Crtd_By]       NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]      DATETIME       NULL,
    [S_Updt_By]       NVARCHAR (MAX) NULL,
    [Dt_Updt_On]      DATETIME       NULL,
    [I_Brand_ID]      INT            NULL,
    [start_latitude]  NVARCHAR (MAX) NULL,
    [start_longitude] NVARCHAR (MAX) NULL,
    [I_ERP_User_ID]   INT            NULL,
    [S_Location]      NVARCHAR (MAX) NULL,
    [full_address]    NVARCHAR (MAX) NULL,
    [flag]            TINYINT        DEFAULT ((0)) NULL,
    CONSTRAINT [PK_T_BusRoute_Master] PRIMARY KEY CLUSTERED ([I_Route_ID] ASC)
);

