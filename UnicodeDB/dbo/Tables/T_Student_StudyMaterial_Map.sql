CREATE TABLE [dbo].[T_Student_StudyMaterial_Map] (
    [I_Student_Detail_ID] INT           NOT NULL,
    [S_StudyMaterial_No]  VARCHAR (500) NOT NULL,
    [I_Brand_ID]          INT           NULL,
    CONSTRAINT [PK_T_Student_StudyMaterial_Map] PRIMARY KEY CLUSTERED ([I_Student_Detail_ID] ASC, [S_StudyMaterial_No] ASC)
);

