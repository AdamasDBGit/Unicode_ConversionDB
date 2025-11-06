CREATE TABLE [EOS].[T_Skill_Exam_Map_Audit] (
    [I_Skill_Exam_Map_Audit_ID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Skill_Exam_ID]           INT          NULL,
    [I_Centre_ID]               INT          NULL,
    [I_Skill_ID]                INT          NULL,
    [I_Exam_Component_ID]       INT          NULL,
    [Is_Pass_Mandatory]         BIT          NULL,
    [I_Cut_Off]                 INT          NULL,
    [I_Exam_Stage]              INT          NULL,
    [I_Number_Of_Resits]        INT          NULL,
    [I_Status]                  INT          NULL,
    [S_Crtd_By]                 VARCHAR (20) NULL,
    [S_Upd_By]                  VARCHAR (20) NULL,
    [Dt_Crtd_On]                DATETIME     NULL,
    [Dt_Upd_On]                 DATETIME     NULL,
    [I_Total_Time]              INT          NULL,
    CONSTRAINT [PK__T_Skill_Exam_Map__4EF456D6] PRIMARY KEY CLUSTERED ([I_Skill_Exam_Map_Audit_ID] ASC)
);

