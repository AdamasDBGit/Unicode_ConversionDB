CREATE TABLE [dbo].[T_Session_Content_CuePoint_Details] (
    [I_Cue_Point_Details_ID]     INT            IDENTITY (1, 1) NOT NULL,
    [I_Batch_Content_Details_ID] INT            NULL,
    [S_Topic_Name]               NVARCHAR (MAX) NULL,
    [dt_Time]                    DATETIME       NULL,
    [S_Crtd_By]                  NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                 DATETIME       NULL,
    [S_Upd_By]                   NVARCHAR (MAX) NULL,
    [Dt_Upd_By]                  DATETIME       NULL,
    CONSTRAINT [PK_T_Session_Content_CuePoint_Details] PRIMARY KEY CLUSTERED ([I_Cue_Point_Details_ID] ASC)
);

