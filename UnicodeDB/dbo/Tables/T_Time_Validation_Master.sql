CREATE TABLE [dbo].[T_Time_Validation_Master] (
    [I_Time_Validation_Master_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Time_Validation_Type_ID]   INT            NULL,
    [S_Time_Type]                 NVARCHAR (100) NULL,
    [Hour_Val]                    TIME (0)       NULL,
    [I_Status]                    INT            NULL,
    [Dt_CreatedBy]                INT            NOT NULL,
    [Dt_Created_At]               DATETIME       NOT NULL
);

