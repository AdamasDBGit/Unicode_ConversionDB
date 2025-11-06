CREATE TABLE [NETWORK].[T_Upgrade_Request] (
    [I_Center_Upgrade_Request_ID] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Centre_Id]                 INT            NULL,
    [S_Reason]                    VARCHAR (200)  NULL,
    [S_Remarks]                   VARCHAR (1000) NULL,
    [I_Is_Upgrade]                BIT            NULL,
    [S_Crtd_By]                   VARCHAR (20)   NULL,
    [S_Upd_By]                    VARCHAR (20)   NULL,
    [Dt_Crtd_On]                  DATETIME       NULL,
    [Dt_Upd_On]                   DATETIME       NULL,
    [I_Requested_Category]        INT            NULL,
    [I_Status]                    INT            NULL,
    CONSTRAINT [PK__T_Upgrade_Reques__5D2C9C3D] PRIMARY KEY CLUSTERED ([I_Center_Upgrade_Request_ID] ASC)
);

