CREATE TABLE [dbo].[T_Student_Transfer_Request] (
    [I_Transfer_Request_ID]   INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Source_Centre_Id]      INT             NULL,
    [I_Destination_Centre_Id] INT             NULL,
    [I_Student_Detail_ID]     INT             NULL,
    [S_Remarks]               NVARCHAR (MAX)  NULL,
    [Dt_Request_Date]         DATETIME        NULL,
    [Dt_Transfer_Date]        DATETIME        NULL,
    [I_Status]                INT             NULL,
    [S_Crtd_By]               NVARCHAR (MAX)  NULL,
    [S_Upd_By]                NVARCHAR (MAX)  NULL,
    [Dt_Crtd_On]              DATETIME        NULL,
    [Dt_Upd_On]               DATETIME        NULL,
    [S_Workflow_GUID_ID]      NVARCHAR (MAX)  NULL,
    [I_Course_Duration]       INT             NULL,
    [I_Course_Completed]      INT             NULL,
    [N_DCCourse_Amount]       NUMERIC (18, 2) NULL,
    [Dt_effective_Date]       DATETIME        NULL,
    CONSTRAINT [PK__T_Student_Transf__1976906E] PRIMARY KEY CLUSTERED ([I_Transfer_Request_ID] ASC)
);

