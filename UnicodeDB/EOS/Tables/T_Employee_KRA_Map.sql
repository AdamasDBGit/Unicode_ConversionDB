CREATE TABLE [EOS].[T_Employee_KRA_Map] (
    [I_Employee_KRA_ID] INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_KRA_ID]          INT             NULL,
    [I_Employee_ID]     INT             NULL,
    [N_Weightage]       NUMERIC (18, 2) NULL,
    [I_SubKRA_Id]       INT             NULL,
    [S_Crtd_By]         VARCHAR (20)    NULL,
    [S_Upd_By]          VARCHAR (20)    NULL,
    [Dt_Crtd_On]        DATETIME        NULL,
    [Dt_Upd_On]         DATETIME        NULL,
    [I_Status]          INT             NULL,
    [Dt_Start_Date]     DATETIME        NULL,
    [Dt_End_Date]       DATETIME        NULL,
    CONSTRAINT [PK__T_Employee_KRA_M__3628A90C] PRIMARY KEY CLUSTERED ([I_Employee_KRA_ID] ASC)
);

