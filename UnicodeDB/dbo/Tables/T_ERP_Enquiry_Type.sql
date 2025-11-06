CREATE TABLE [dbo].[T_ERP_Enquiry_Type] (
    [I_Enquiry_Type_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Enquiry_Type_Desc] NVARCHAR (MAX) NULL,
    [I_Status]            INT            NULL,
    [S_Crtd_By]           INT            NULL,
    [S_Upd_By]            INT            NULL,
    [Dt_Crtd_On]          DATETIME       NULL,
    [Dt_Upd_On]           DATETIME       NULL,
    CONSTRAINT [PK_T_ERP_Enquiry_Type__5812E165] PRIMARY KEY CLUSTERED ([I_Enquiry_Type_ID] ASC)
);

