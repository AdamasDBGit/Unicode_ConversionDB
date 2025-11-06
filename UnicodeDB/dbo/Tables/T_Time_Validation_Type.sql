CREATE TABLE [dbo].[T_Time_Validation_Type] (
    [I_Time_Validation_Type_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]                INT            NULL,
    [S_Module]                  NVARCHAR (100) NULL,
    [S_Activity]                NVARCHAR (100) NULL,
    [I_Status]                  INT            NULL
);

