CREATE TABLE [dbo].[T_ERP_Student_Class_Routine_ExtraClass] (
    [I_ClassRoutine_ExtraClass_ID]    INT      IDENTITY (1, 1) NOT NULL,
    [R_I_Faculty_Master_ID]           INT      NULL,
    [R_I_Subject_ID]                  INT      NULL,
    [R_I_Routine_Structure_Header_ID] INT      NULL,
    [T_From_Slot]                     TIME (0) NULL,
    [T_To_Slot]                       TIME (0) NULL,
    [Dt_Period_Dt]                    DATE     NULL,
    [I_Subject_Component_ID]          INT      NULL,
    [Is_ExtraClass]                   BIT      NULL,
    [Dtt_Created_At]                  DATETIME NULL,
    [Dtt_Modified_At]                 DATETIME NULL,
    [I_Created_By]                    INT      NULL,
    [I_Modified_By]                   INT      NULL,
    [Is_Active]                       BIT      NULL,
    [I_Day_ID]                        INT      NULL
);

