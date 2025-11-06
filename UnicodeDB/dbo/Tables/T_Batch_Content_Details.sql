CREATE TABLE [dbo].[T_Batch_Content_Details] (
    [I_Batch_Content_Details_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Batch_ID]                 INT            NULL,
    [I_Term_ID]                  INT            NULL,
    [I_Module_ID]                INT            NULL,
    [I_Session_ID]               INT            NULL,
    [S_Session_Alias]            NVARCHAR (MAX) NULL,
    [S_Session_Chapter]          NVARCHAR (MAX) NULL,
    [S_Session_Description]      NVARCHAR (MAX) NULL,
    [S_Content_URL]              NVARCHAR (MAX) NULL,
    [S_Crtd_By]                  NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                 DATETIME       NULL,
    [S_Upd_By]                   NVARCHAR (MAX) NULL,
    [Dt_Upd_On]                  DATETIME       NULL,
    [S_Session_Name]             NVARCHAR (MAX) NULL,
    [S_Session_Topic]            NVARCHAR (MAX) NULL,
    [B_IsActive]                 BIT            NULL,
    [I_Folder_Id]                INT            NULL,
    CONSTRAINT [PK_T_Batch_Content_Details] PRIMARY KEY CLUSTERED ([I_Batch_Content_Details_ID] ASC)
);

