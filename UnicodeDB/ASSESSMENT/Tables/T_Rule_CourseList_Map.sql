CREATE TABLE [ASSESSMENT].[T_Rule_CourseList_Map] (
    [I_CourseList_ID]     INT          IDENTITY (1, 1) NOT NULL,
    [I_Rule_ID]           INT          NOT NULL,
    [B_Is_Evaluated_True] BIT          NULL,
    [I_Status]            INT          NULL,
    [S_Crtd_By]           VARCHAR (20) NULL,
    [S_Updt_By]           VARCHAR (20) NULL,
    [Dt_Crtd_On]          DATETIME     NULL,
    [Dt_Updt_On]          DATETIME     NULL,
    CONSTRAINT [PK_T_Rule_CourseList_Map] PRIMARY KEY CLUSTERED ([I_CourseList_ID] ASC)
);

