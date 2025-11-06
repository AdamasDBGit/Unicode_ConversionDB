CREATE TABLE [EXAMINATION].[T_Eligibility_List] (
    [I_Eligibility_List_ID] INT          IDENTITY (1, 1) NOT NULL,
    [I_Student_Detail_ID]   INT          NULL,
    [I_Exam_ID]             INT          NULL,
    [S_Registration_No]     VARCHAR (20) NULL,
    [S_Crtd_By]             VARCHAR (20) NULL,
    [S_Upd_By]              VARCHAR (20) NULL,
    [Dt_Crtd_On]            DATETIME     NULL,
    [Dt_Upd_On]             DATETIME     NULL,
    [C_Appeared_For_Exam]   CHAR (1)     NULL,
    CONSTRAINT [PK__T_Eligibility_Li__1F2F69C4] PRIMARY KEY CLUSTERED ([I_Eligibility_List_ID] ASC)
);

