CREATE TABLE [dbo].[zz_T_Admissions] (
    [AdmissionID]   INT            IDENTITY (1, 1) NOT NULL,
    [AdmissionDate] DATE           NULL,
    [StudentID]     NVARCHAR (MAX) NULL,
    [ClassName]     NVARCHAR (MAX) NULL,
    [AdmissionType] NVARCHAR (MAX) NULL,
    [StudentName]   NVARCHAR (MAX) NULL,
    [Stream]        NVARCHAR (MAX) NULL,
    [EnquiryNo]     NVARCHAR (MAX) NULL,
    [Remarks]       NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([AdmissionID] ASC)
);

