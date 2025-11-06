CREATE TABLE [dbo].[T_ERP_Exam_Schedule_Subject_Detail] (
    [I_Schedule_Subject_Detail]     INT              IDENTITY (1, 1) NOT NULL,
    [I_Result_Exam_Schedule_ID]     INT              NOT NULL,
    [I_Subject_Type_ID]             INT              NULL,
    [I_Subject_ID]                  INT              NULL,
    [I_Subject_Component_ID]        INT              NULL,
    [S_Subject_Name]                NVARCHAR (MAX)   NULL,
    [I_Slot_ID]                     INT              NULL,
    [i_Faculty_ID]                  INT              NULL,
    [N_Total_Marks]                 DECIMAL (18, 2)  NULL,
    [N_Pass_Marks]                  DECIMAL (18, 2)  NULL,
    [Is_PassMandatory]              BIT              NULL,
    [Weightage]                     DECIMAL (18, 2)  NULL,
    [dt_Start_date]                 DATE             NULL,
    [dt_End_date]                   DATE             NULL,
    [Is_Display_App]                BIT              NULL,
    [I_Subject_Sequence]            INT              NULL,
    [dt_Createdt]                   DATETIME         CONSTRAINT [DF__T_ERP_Exa__dt_Cr__29CDF0E9] DEFAULT (getdate()) NULL,
    [Dt_Modified_dt]                DATETIME         NULL,
    [Is_Active]                     BIT              NULL,
    [un_Schedule_Subject_Detail_ID] UNIQUEIDENTIFIER NULL
);

