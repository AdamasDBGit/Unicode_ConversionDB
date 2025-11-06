CREATE TYPE [dbo].[UT_Exam_Schedule_Subject_Details] AS TABLE (
    [I_Schedule_Subject_Detail] INT             IDENTITY (1, 1) NOT NULL,
    [I_Subject_ID]              INT             NULL,
    [I_Subject_Type_ID]         INT             NULL,
    [I_Subject_Component_ID]    INT             NULL,
    [S_Subject_Name]            VARCHAR (255)   NULL,
    [I_Slot_ID]                 INT             NULL,
    [i_Faculty_ID]              INT             NULL,
    [N_Total_Marks]             DECIMAL (18, 2) NULL,
    [N_Pass_Marks]              DECIMAL (18, 2) NULL,
    [Is_PassMandatory]          BIT             NULL,
    [Weightage]                 DECIMAL (18, 2) NULL,
    [dt_Start_date]             DATE            NULL,
    [dt_End_date]               DATE            NULL,
    [Is_Display_App]            BIT             NULL,
    [I_Subject_Sequence]        INT             NULL);

