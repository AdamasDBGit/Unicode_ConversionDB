CREATE TABLE [dbo].[AllNewStudent] (
    [ID]                  INT            IDENTITY (1, 1) NOT NULL,
    [I_Student_Detail_ID] INT            NULL,
    [I_Enquiry_Regn_ID]   INT            NULL,
    [S_Student_ID]        NVARCHAR (MAX) NULL,
    [StudentName]         NVARCHAR (MAX) NULL,
    [S_Mobile_No]         NVARCHAR (MAX) NULL,
    [FatherName]          NVARCHAR (MAX) NULL,
    [FatherContact]       NVARCHAR (MAX) NULL,
    [MotherName]          NVARCHAR (MAX) NULL,
    [MotherContact]       NVARCHAR (MAX) NULL,
    [I_Brand_ID]          INT            NULL
);

