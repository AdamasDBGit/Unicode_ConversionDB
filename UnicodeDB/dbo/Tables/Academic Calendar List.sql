CREATE TABLE [dbo].[Academic Calendar List] (
    [Event_Name]  NVARCHAR (100) NOT NULL,
    [Start_Date]  DATE           NOT NULL,
    [End_Date]    DATE           NOT NULL,
    [Category_ID] TINYINT        NOT NULL,
    [Category]    NVARCHAR (50)  NOT NULL,
    [Remarks]     NVARCHAR (50)  NULL,
    [classId]     NVARCHAR (MAX) NULL
);

