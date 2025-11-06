CREATE TABLE [dbo].[T_Student_Transfer_History] (
    [I_Transfer_History_Id] INT            IDENTITY (1, 1) NOT NULL,
    [I_Transfer_Request_ID] INT            NOT NULL,
    [S_Remarks]             NVARCHAR (MAX) NULL,
    [I_Status_ID]           INT            NULL,
    [S_Crtd_By]             NVARCHAR (MAX) NULL,
    [S_Upd_By]              NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]            DATETIME       NULL,
    [Dt_Upd_On]             DATETIME       NULL,
    [I_Task_Details_Id]     INT            NULL
);

