CREATE TABLE [EXAMINATION].[T_Offline_Users] (
    [I_Exam_Candidate_ID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Center_ID]         INT           NOT NULL,
    [S_Login_ID]          VARCHAR (200) NOT NULL,
    [S_Password]          VARCHAR (200) NOT NULL,
    [S_User_Type]         VARCHAR (50)  NOT NULL,
    [I_Reference_ID]      INT           NOT NULL,
    CONSTRAINT [PK__T_Offline_Users__55016A90] PRIMARY KEY CLUSTERED ([I_Exam_Candidate_ID] ASC)
);

