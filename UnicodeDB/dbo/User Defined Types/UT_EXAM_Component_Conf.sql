CREATE TYPE [dbo].[UT_EXAM_Component_Conf] AS TABLE (
    [I_Exam_Comp_Map_ID]     INT NULL,
    [I_Subject_ID]           INT NOT NULL,
    [I_Subject_Component_ID] INT NULL,
    [N_Total_Marks]          INT NULL,
    [N_Pass_Marks]           INT NULL,
    [Is_PassMandatory]       BIT NOT NULL,
    [S_Weightage]            INT NULL,
    [Is_Active_Details]      BIT NULL);

