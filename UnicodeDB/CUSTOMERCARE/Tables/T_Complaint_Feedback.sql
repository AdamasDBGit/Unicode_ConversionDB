CREATE TABLE [CUSTOMERCARE].[T_Complaint_Feedback] (
    [I_Complaint_Feedback_ID] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Feedback_ID]           INT            NULL,
    [I_Complaint_Req_ID]      INT            NULL,
    [S_Feedback_By]           VARCHAR (50)   NULL,
    [Dt_Feedback_Date]        DATETIME       NULL,
    [S_Remarks]               VARCHAR (2000) NULL,
    [S_Crtd_By]               VARCHAR (20)   NULL,
    [Dt_Crtd_On]              DATETIME       NULL,
    [S_Upd_By]                VARCHAR (20)   NULL,
    [Dt_Upd_On]               DATETIME       NULL,
    CONSTRAINT [PK__T_Complaint_Feed__74100195] PRIMARY KEY CLUSTERED ([I_Complaint_Feedback_ID] ASC)
);

