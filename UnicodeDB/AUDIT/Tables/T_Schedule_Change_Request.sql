CREATE TABLE [AUDIT].[T_Schedule_Change_Request] (
    [I_Schedule_Change_Request_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Audit_Schedule_ID]          INT            NULL,
    [Dt_Requested_Date]            DATETIME       NULL,
    [S_Reason_Of_Change]           VARCHAR (2000) NULL,
    [S_Remarks]                    VARCHAR (2000) NULL,
    [I_Status_ID]                  INT            NULL,
    [S_Crtd_By]                    VARCHAR (20)   NULL,
    [S_Upd_By]                     VARCHAR (20)   NULL,
    [Dt_Crtd_On]                   DATETIME       NULL,
    [Dt_Upd_On]                    DATETIME       NULL,
    CONSTRAINT [PK__T_Schedule_Chang__5B94C746] PRIMARY KEY CLUSTERED ([I_Schedule_Change_Request_ID] ASC)
);

