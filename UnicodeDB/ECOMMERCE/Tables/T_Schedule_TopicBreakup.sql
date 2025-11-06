CREATE TABLE [ECOMMERCE].[T_Schedule_TopicBreakup] (
    [TopicBreakupID] INT           IDENTITY (1, 1) NOT NULL,
    [ItemName]       VARCHAR (MAX) NULL,
    [TopicID]        INT           NULL,
    [StatusID]       INT           NULL,
    [CreatedBy]      VARCHAR (MAX) NULL,
    [CreatedOn]      DATETIME      NULL,
    [UpdatedBy]      VARCHAR (MAX) NULL,
    [UpdatedOn]      DATETIME      NULL,
    [ItemValue]      VARCHAR (MAX) NULL,
    CONSTRAINT [PK__T_Schedu__DF231BDA7335A86A] PRIMARY KEY CLUSTERED ([TopicBreakupID] ASC)
);

