CREATE TABLE [dbo].[T_CourseList_Course_Map] (
    [I_CourseList_Course_ID] INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Course_ID]            INT NULL,
    [I_CourseList_ID]        INT NULL,
    [I_Status]               INT NULL,
    CONSTRAINT [PK__T_CourseList_Cou__5145E845] PRIMARY KEY CLUSTERED ([I_CourseList_Course_ID] ASC)
);

