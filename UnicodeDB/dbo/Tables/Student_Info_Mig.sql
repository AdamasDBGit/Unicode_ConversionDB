CREATE TABLE [dbo].[Student_Info_Mig] (
    [IDNo]             FLOAT (53)     NULL,
    [StudentName]      NVARCHAR (255) NULL,
    [FatherName]       NVARCHAR (255) NULL,
    [MotherName]       NVARCHAR (255) NULL,
    [Gender]           NVARCHAR (255) NULL,
    [Category]         NVARCHAR (255) NULL,
    [Class]            NVARCHAR (255) NULL,
    [Sec]              NVARCHAR (255) NULL,
    [DOB]              NVARCHAR (255) NULL,
    [AddNo]            FLOAT (53)     NULL,
    [AddDate ]         DATETIME       NULL,
    [MobileNo]         FLOAT (53)     NULL,
    [ADDRESS]          NVARCHAR (255) NULL,
    [ID]               INT            IDENTITY (1, 1) NOT NULL,
    [StudentDetailsID] BIGINT         NULL,
    [StudentEnquiryID] BIGINT         NULL
);

