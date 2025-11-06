CREATE TABLE [ACADEMICS].[T_Academics_Visit] (
    [I_Academics_Visit_ID]       INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Center_Id]                INT            NULL,
    [I_User_ID]                  INT            NULL,
    [Dt_Planned_Visit_From_Date] DATETIME       NULL,
    [Dt_Actual_Visit_From_Date]  DATETIME       NULL,
    [S_Remarks]                  VARCHAR (2000) NULL,
    [Dt_Planned_Visit_To_Date]   DATETIME       NULL,
    [S_Crtd_By]                  VARCHAR (20)   NULL,
    [S_Upd_By]                   VARCHAR (20)   NULL,
    [Dt_Actual_Visit_To_Date]    DATETIME       NULL,
    [Dt_Crtd_On]                 DATETIME       NULL,
    [S_Purpose]                  VARCHAR (2000) NULL,
    [Dt_Upd_On]                  DATETIME       NULL,
    [C_Academic_Parameter]       CHAR (1)       NULL,
    [C_Faculty_Approval]         CHAR (1)       NULL,
    [C_Faculty_Certification]    CHAR (1)       NULL,
    [C_Infrastructure]           CHAR (1)       NULL,
    [I_Status]                   INT            NULL,
    CONSTRAINT [PK__T_Academics_Visi__4460EE73] PRIMARY KEY CLUSTERED ([I_Academics_Visit_ID] ASC)
);

