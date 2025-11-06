CREATE TABLE [STUDENTFEATURES].[T_Student_Survey_Ratings] (
    [I_Student_Survey_Rating_ID] INT          IDENTITY (1, 1) NOT NULL,
    [I_Student_Survey_ID]        INT          NULL,
    [I_Survey_Question_ID]       INT          NULL,
    [I_Weightage]                INT          NULL,
    [I_Status]                   INT          NULL,
    [S_Crtd_By]                  VARCHAR (20) NULL,
    [S_Upd_By]                   VARCHAR (20) NULL,
    [Dt_Crtd_On]                 DATETIME     NULL,
    [Dt_Upd_On]                  DATETIME     NULL,
    CONSTRAINT [PK_T_Student_Survey_Ratings] PRIMARY KEY CLUSTERED ([I_Student_Survey_Rating_ID] ASC)
);

