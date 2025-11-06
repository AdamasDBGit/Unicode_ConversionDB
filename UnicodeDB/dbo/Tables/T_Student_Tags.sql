CREATE TABLE [dbo].[T_Student_Tags] (
    [I_Student_Tag_ID]      INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]            INT            NULL,
    [I_Enquiry_Regn_ID]     INT            NULL,
    [I_Student_Detail_ID]   INT            NULL,
    [I_Enquiry_Status_Code] INT            NULL,
    [I_Language_ID]         INT            NOT NULL,
    [I_Language_Name]       NVARCHAR (MAX) NOT NULL,
    [S_Crtd_By]             NVARCHAR (MAX) NULL,
    [S_Upd_By]              NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]            DATETIME       NULL,
    [Dt_Upd_On]             DATETIME       NULL,
    CONSTRAINT [PK__T_Studen__03A99B2672E704FC] PRIMARY KEY CLUSTERED ([I_Student_Tag_ID] ASC)
);

