CREATE TABLE [dbo].[T_Route_Transport_Map] (
    [I_PickupPoint_ID]      INT             NOT NULL,
    [I_Route_ID]            INT             NOT NULL,
    [I_Status]              INT             NULL,
    [S_Crtd_By]             NVARCHAR (MAX)  NULL,
    [Dt_Crtd_On]            DATETIME        NULL,
    [S_Updt_By]             NVARCHAR (MAX)  NULL,
    [Dt_Updt_On]            DATETIME        NULL,
    [start_latitude]        NVARCHAR (MAX)  NULL,
    [start_longitude]       NVARCHAR (MAX)  NULL,
    [flag]                  TINYINT         DEFAULT (NULL) NULL,
    [I_Academic_Session_ID] INT             DEFAULT (NULL) NULL,
    [Dt_Effective_From]     DATE            DEFAULT (NULL) NULL,
    [Dt_Effective_To]       DATE            DEFAULT (NULL) NULL,
    [Monthly_Amount]        NUMERIC (10, 2) DEFAULT (NULL) NULL,
    [Bimonthly_Amount]      NUMERIC (10, 2) DEFAULT (NULL) NULL,
    [Quarterly_Amount]      NUMERIC (10, 2) DEFAULT (NULL) NULL,
    [Yearly_Amount]         NUMERIC (10, 2) DEFAULT (NULL) NULL,
    [Transport_Fee_Head]    NVARCHAR (MAX)  NULL,
    [Configuration_Name]    NVARCHAR (MAX)  NULL
);

