CREATE TABLE [LMS].[T_Issue_Category_Master] (
    [ID]                INT           IDENTITY (1, 1) NOT NULL,
    [CategoryName]      VARCHAR (MAX) NULL,
    [CategoryDesc]      VARCHAR (MAX) NULL,
    [StatusID]          INT           NULL,
    [DesignatedEmailID] VARCHAR (MAX) NULL,
    CONSTRAINT [PK__T_Issue___3214EC278FA3F071] PRIMARY KEY CLUSTERED ([ID] ASC)
);

