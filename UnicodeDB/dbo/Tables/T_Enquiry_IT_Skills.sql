CREATE TABLE [dbo].[T_Enquiry_IT_Skills] (
    [I_Enquiry_IT_Skills_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Enquiry_Regn_ID]      INT            NOT NULL,
    [S_Crtd_By]              NVARCHAR (MAX) NULL,
    [S_Upd_By]               NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]             DATETIME       NULL,
    [Dt_Upd_On]              DATETIME       NULL,
    [I_IT_Skills_ID]         INT            NULL
);

