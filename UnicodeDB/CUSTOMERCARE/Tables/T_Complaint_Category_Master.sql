CREATE TABLE [CUSTOMERCARE].[T_Complaint_Category_Master] (
    [I_Complaint_Category_ID] INT           IDENTITY (1, 1) NOT NULL,
    [S_Complaint_Desc]        VARCHAR (200) NULL,
    [I_Status_ID]             INT           NULL,
    [S_Crtd_By]               VARCHAR (20)  NULL,
    [S_Upd_By]                VARCHAR (20)  NULL,
    [S_Complaint_Code]        VARCHAR (20)  NULL,
    [Dt_Crtd_On]              DATETIME      NULL,
    [Dt_Upd_On]               DATETIME      NULL,
    CONSTRAINT [PK__T_Complaint_Cate__40FA71E3] PRIMARY KEY CLUSTERED ([I_Complaint_Category_ID] ASC)
);

