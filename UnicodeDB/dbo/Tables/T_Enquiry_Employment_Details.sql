CREATE TABLE [dbo].[T_Enquiry_Employment_Details] (
    [I_Enquiry_Employment_Details_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Enquiry_Regn_ID]               INT            NOT NULL,
    [S_Crtd_By]                       NVARCHAR (MAX) NULL,
    [S_Upd_By]                        NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                      DATETIME       NULL,
    [Dt_Upd_On]                       DATETIME       NULL,
    [I_Employment_Details_ID]         INT            NULL,
    [S_Experience]                    NVARCHAR (MAX) NULL,
    [S_Role]                          NVARCHAR (MAX) NULL,
    [S_Salary]                        NVARCHAR (MAX) NULL
);

