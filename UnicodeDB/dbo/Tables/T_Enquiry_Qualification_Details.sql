CREATE TABLE [dbo].[T_Enquiry_Qualification_Details] (
    [I_Enquiry_Qualification_ID] INT             IDENTITY (1, 1) NOT NULL,
    [I_Enquiry_Regn_ID]          INT             NOT NULL,
    [S_Name_Of_Exam]             NVARCHAR (MAX)  NULL,
    [S_University_Name]          NVARCHAR (MAX)  NULL,
    [S_Year_From]                NVARCHAR (MAX)  NULL,
    [S_Year_To]                  NVARCHAR (MAX)  NULL,
    [S_Subject_Name]             NVARCHAR (MAX)  NULL,
    [N_Marks_Obtained]           DECIMAL (18, 2) NULL,
    [N_Percentage]               DECIMAL (18, 2) NULL,
    [S_Division]                 NVARCHAR (MAX)  NULL,
    [I_Status]                   INT             NULL,
    [S_Crtd_By]                  NVARCHAR (MAX)  NULL,
    [S_Upd_By]                   NVARCHAR (MAX)  NULL,
    [Dt_Crtd_On]                 DATETIME        NULL,
    [Dt_Upd_On]                  DATETIME        NULL,
    [S_Institution]              NVARCHAR (MAX)  NULL,
    CONSTRAINT [PK_T_Enquiry_Qualification_Details] PRIMARY KEY CLUSTERED ([I_Enquiry_Qualification_ID] ASC)
);


GO
CREATE TRIGGER [dbo].[TDELETE_T_Enquiry_Qualification_Details] ON [dbo].[T_Enquiry_Qualification_Details] AFTER DELETE ASBEGININSERT INTO T_Enquiry_Qualification_Details_A(I_Enquiry_Qualification_ID,I_Enquiry_Regn_ID,S_Name_Of_Exam,S_University_Name,S_Year_From,S_Year_To,S_Subject_Name,N_Marks_Obtained,N_Percentage,S_Division,I_Status,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On,AuditedOn,AuditType)SELECT I_Enquiry_Qualification_ID,I_Enquiry_Regn_ID,S_Name_Of_Exam,S_University_Name,S_Year_From,S_Year_To,S_Subject_Name,N_Marks_Obtained,N_Percentage,S_Division,I_Status,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On, GETDATE(), 'D'FROM DELETED IEND
GO
CREATE TRIGGER [dbo].[TUPDATE_T_Enquiry_Qualification_Details] ON [dbo].[T_Enquiry_Qualification_Details] AFTER UPDATE ASBEGININSERT INTO T_Enquiry_Qualification_Details_A(I_Enquiry_Qualification_ID,I_Enquiry_Regn_ID,S_Name_Of_Exam,S_University_Name,S_Year_From,S_Year_To,S_Subject_Name,N_Marks_Obtained,N_Percentage,S_Division,I_Status,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On,AuditedOn,AuditType)SELECT I_Enquiry_Qualification_ID,I_Enquiry_Regn_ID,S_Name_Of_Exam,S_University_Name,S_Year_From,S_Year_To,S_Subject_Name,N_Marks_Obtained,N_Percentage,S_Division,I_Status,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On, GETDATE(), 'U'FROM DELETED IEND