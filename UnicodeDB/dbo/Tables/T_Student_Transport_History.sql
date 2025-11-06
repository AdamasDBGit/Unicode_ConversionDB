CREATE TABLE [dbo].[T_Student_Transport_History] (
    [I_Student_Detail_ID]       INT            NOT NULL,
    [I_PickupPoint_ID]          INT            NOT NULL,
    [I_Route_ID]                INT            NOT NULL,
    [Dt_Transport_Deactivation] DATETIME       NULL,
    [S_Crtd_By]                 NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                DATETIME       NULL,
    [S_Updt_By]                 NVARCHAR (MAX) NULL,
    [Dt_Updt_On]                DATETIME       NULL,
    [I_school_SessionID]        INT            NULL,
    [I_Brand_ID]                INT            NULL,
    [route_start_id]            INT            NULL,
    [route_end_id]              INT            NULL,
    [drop_id]                   INT            NULL,
    [flag]                      TINYINT        DEFAULT (NULL) NULL
);

