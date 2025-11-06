CREATE TABLE [ASSESSMENT].[T_Assessment_Rule_Workflow] (
    [I_Assessment_Rule_Map_ID]        INT          IDENTITY (1, 1) NOT NULL,
    [I_PreAssessment_ID]              INT          NOT NULL,
    [I_Rule_ID]                       INT          NOT NULL,
    [S_Evaluated_True_Category]       VARCHAR (20) NULL,
    [I_Evaluated_True_Assessment_ID]  INT          NULL,
    [I_Evaluated_True_CourseList_ID]  INT          NULL,
    [I_Evaluated_True_Rule_ID]        INT          NULL,
    [S_Evaluated_False_Category]      VARCHAR (20) NULL,
    [I_Evaluated_False_Assessment_ID] INT          NULL,
    [I_Evaluated_False_CourseList_ID] INT          NULL,
    [I_Evaluated_False_Rule_ID]       INT          NULL,
    [I_Status]                        INT          NULL,
    [S_Crtd_By]                       VARCHAR (20) NULL,
    [S_Updt_By]                       VARCHAR (20) NULL,
    [Dt_Crtd_On]                      DATETIME     NULL,
    [Dt_Updt_On]                      DATETIME     NULL,
    CONSTRAINT [PK_T_Assessment_Rule_Workflow] PRIMARY KEY CLUSTERED ([I_Assessment_Rule_Map_ID] ASC)
);

