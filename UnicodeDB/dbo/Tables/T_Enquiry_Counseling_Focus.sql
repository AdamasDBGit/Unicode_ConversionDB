CREATE TABLE [dbo].[T_Enquiry_Counseling_Focus] (
    [I_Enquiry_Counseling_Focus_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Enquiry_Regn_ID]             INT            NOT NULL,
    [S_Crtd_By]                     NVARCHAR (MAX) NULL,
    [S_Upd_By]                      NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                    DATETIME       NULL,
    [Dt_Upd_On]                     DATETIME       NULL,
    [I_Counseling_Focus_ID]         INT            NULL
);

