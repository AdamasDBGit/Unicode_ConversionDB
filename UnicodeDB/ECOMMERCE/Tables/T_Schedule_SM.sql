CREATE TABLE [ECOMMERCE].[T_Schedule_SM] (
    [SMID]       INT            IDENTITY (1, 1) NOT NULL,
    [SMName]     NVARCHAR (MAX) NULL,
    [ScheduleID] INT            NULL,
    [StatusID]   INT            NULL,
    [CreatedBy]  VARCHAR (MAX)  NULL,
    [CreatedOn]  DATETIME       NULL,
    [UpdatedBy]  VARCHAR (MAX)  NULL,
    [UpdatedOn]  DATETIME       NULL,
    CONSTRAINT [PK__T_Schedu__A47B2F5654AA5CCC] PRIMARY KEY CLUSTERED ([SMID] ASC)
);

