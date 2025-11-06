CREATE TABLE [ASSESSMENT].[T_Assessment_Course_Map] (
    [I_PreAssessment_ID] INT          NOT NULL,
    [I_Course_ID]        INT          NOT NULL,
    [S_Ctrd_by]          VARCHAR (20) NULL,
    [S_Updt_by]          VARCHAR (20) NULL,
    [Dt_Crtd_On]         DATETIME     NULL,
    [Dt_Updt_On]         DATETIME     NULL,
    CONSTRAINT [PK_T_Assessment_Course_Map] PRIMARY KEY CLUSTERED ([I_PreAssessment_ID] ASC, [I_Course_ID] ASC)
);

