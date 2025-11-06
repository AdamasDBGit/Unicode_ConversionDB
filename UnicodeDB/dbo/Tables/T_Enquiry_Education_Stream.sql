CREATE TABLE [dbo].[T_Enquiry_Education_Stream] (
    [I_Enquiry_Education_Stream_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Enquiry_Regn_ID]             INT            NOT NULL,
    [S_Crtd_By]                     NVARCHAR (MAX) NULL,
    [S_Upd_By]                      NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                    DATETIME       NULL,
    [Dt_Upd_On]                     DATETIME       NULL,
    [I_Education_Stream_ID]         INT            NULL
);

