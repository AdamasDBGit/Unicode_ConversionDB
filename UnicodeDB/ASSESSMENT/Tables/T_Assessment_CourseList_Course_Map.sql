CREATE TABLE [ASSESSMENT].[T_Assessment_CourseList_Course_Map] (
    [I_Course_List_ID] INT NOT NULL,
    [I_Course_ID]      INT NOT NULL,
    CONSTRAINT [PK_T_Assessment_CourseList_Course_Map] PRIMARY KEY CLUSTERED ([I_Course_List_ID] ASC, [I_Course_ID] ASC)
);

