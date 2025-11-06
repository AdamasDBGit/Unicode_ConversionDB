CREATE TABLE [LMS].[T_Student_Details_Interface_API] (
    [ID]                 INT             IDENTITY (1, 1) NOT NULL,
    [StudentDetailID]    INT             NULL,
    [StudentID]          VARCHAR (MAX)   NULL,
    [FirstName]          VARCHAR (MAX)   NULL,
    [MiddleName]         VARCHAR (MAX)   NULL,
    [LastName]           VARCHAR (MAX)   NULL,
    [Email]              VARCHAR (MAX)   NULL,
    [ContactNo]          VARCHAR (50)    NULL,
    [CurrAddress]        VARCHAR (MAX)   NULL,
    [Country]            VARCHAR (MAX)   NULL,
    [BrandID]            INT             NULL,
    [BrandName]          VARCHAR (MAX)   NULL,
    [CentreID]           INT             NULL,
    [CentreCode]         VARCHAR (50)    NULL,
    [CentreName]         VARCHAR (MAX)   NULL,
    [BatchID]            INT             NULL,
    [BatchCode]          VARCHAR (MAX)   NULL,
    [BatchName]          VARCHAR (MAX)   NULL,
    [CourseID]           INT             NULL,
    [CourseName]         VARCHAR (MAX)   NULL,
    [StudentStatus]      VARCHAR (MAX)   NULL,
    [StatusFlag]         BIT             NULL,
    [ActionType]         VARCHAR (MAX)   NULL,
    [ActionStatus]       INT             NULL,
    [NoofAttempts]       INT             NULL,
    [StatusID]           INT             NULL,
    [CreatedOn]          DATETIME        NULL,
    [CompletedOn]        DATETIME        NULL,
    [Remarks]            VARCHAR (MAX)   NULL,
    [OrgEmailID]         VARCHAR (MAX)   NULL,
    [DefaulterDate]      DATETIME        NULL,
    [DueAmount]          DECIMAL (14, 2) NULL,
    [SecondaryLanguage]  VARCHAR (MAX)   NULL,
    [SourceBatchID]      VARCHAR (MAX)   NULL,
    [LMSCourseEnrolment] BIT             CONSTRAINT [DF__T_Student__LMSCo__2D48B0BB] DEFAULT ((0)) NULL,
    [MandateLink]        VARCHAR (MAX)   NULL,
    [PayOutLink]         VARCHAR (MAX)   NULL,
    [CustomerID]         VARCHAR (MAX)   NULL,
    [I_Language_ID]      INT             NULL,
    [I_Language_Name]    VARCHAR (200)   NULL,
    [EnrollmentDate]     DATETIME        NULL,
    [ClassStartDate]     DATETIME        NULL
);


GO

CREATE TRIGGER [LMS].[tr_StudentDetailsInterfaceAPIModified]
   ON [LMS].[T_Student_Details_Interface_API]
   AFTER UPDATE
AS BEGIN
    SET NOCOUNT ON;
    IF UPDATE (ActionStatus) OR UPDATE (NoofAttempts) OR UPDATE (StatusID) OR UPDATE (CompletedOn) OR UPDATE (Remarks)
    BEGIN
        INSERT INTO [LMS].[T_Student_Details_Interface_API_A]
		SELECT [ID]
      ,[StudentDetailID]
      ,[StudentID]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[Email]
      ,[ContactNo]
      ,[CurrAddress]
      ,[Country]
      ,[BrandID]
      ,[BrandName]
      ,[CentreID]
      ,[CentreCode]
      ,[CentreName]
      ,[BatchID]
      ,[BatchCode]
      ,[BatchName]
      ,[CourseID]
      ,[CourseName]
      ,[StudentStatus]
      ,[StatusFlag]
      ,[ActionType]
      ,[ActionStatus]
      ,[NoofAttempts]
      ,[StatusID]
      ,[CreatedOn]
      ,[CompletedOn]
      ,[Remarks],GETDATE(),[OrgEmailID],DefaulterDate,DueAmount,SecondaryLanguage,SourceBatchID 
	  FROM INSERTED I
    END 
END