CREATE TABLE [LMS].[T_Batch_Details_Interface_API] (
    [ID]               INT           IDENTITY (1, 1) NOT NULL,
    [BrandID]          INT           NULL,
    [BrandName]        VARCHAR (MAX) NULL,
    [CentreID]         INT           NULL,
    [CentreCode]       VARCHAR (50)  NULL,
    [CentreName]       VARCHAR (MAX) NULL,
    [BatchID]          INT           NULL,
    [BatchCode]        VARCHAR (MAX) NULL,
    [BatchName]        VARCHAR (MAX) NULL,
    [CourseID]         INT           NULL,
    [CourseName]       VARCHAR (MAX) NULL,
    [StudentStrength]  INT           NULL,
    [DayPreference]    VARCHAR (MAX) NULL,
    [BatchStartDate]   DATETIME      NULL,
    [BatchEndDate]     DATETIME      NULL,
    [BatchStatus]      VARCHAR (50)  NULL,
    [TimeSlotsOffline] VARCHAR (MAX) NULL,
    [TimeSlotsOnline]  VARCHAR (MAX) NULL,
    [TimeSlotsHandout] VARCHAR (MAX) NULL,
    [ActionType]       VARCHAR (MAX) NULL,
    [ActionStatus]     INT           NULL,
    [NoofAttempts]     INT           NULL,
    [StatusID]         INT           NULL,
    [CreatedOn]        DATETIME      NULL,
    [CompletedOn]      DATETIME      NULL,
    [Remarks]          VARCHAR (MAX) NULL,
    [ClassMode]        VARCHAR (MAX) NULL,
    [MinBatchStrength] INT           NULL,
    [I_Language_ID]    INT           NULL,
    [I_Language_Name]  VARCHAR (200) NULL,
    [I_Category_ID]    INT           NULL,
    [Is_Cyclic_Batch]  BIT           NULL,
    CONSTRAINT [PK_T_Batch_Details_Interface_API] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE TRIGGER [LMS].[tr_BatchDetailsInterfaceAPIModified]
   ON [LMS].[T_Batch_Details_Interface_API]
   AFTER UPDATE
AS BEGIN
    SET NOCOUNT ON;
    IF UPDATE (ActionStatus) OR UPDATE (NoofAttempts) OR UPDATE (StatusID) OR UPDATE (CompletedOn) OR UPDATE (Remarks)
    BEGIN
        INSERT INTO [LMS].[T_Batch_Details_Interface_API_A]
		SELECT [ID] 
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
      ,[StudentStrength]
      ,[DayPreference]
      ,[BatchStartDate]
      ,[BatchEndDate]
      ,[BatchStatus]
      ,[TimeSlotsOffline]
      ,[TimeSlotsOnline]
      ,[TimeSlotsHandout]
      ,[ActionType]
      ,[ActionStatus]
      ,[NoofAttempts]
      ,[StatusID]
      ,[CreatedOn]
      ,[CompletedOn]
      ,[Remarks],
	  GETDATE(),
	  [ClassMode],
	  [MinBatchStrength]
	  FROM INSERTED I
    END 
END