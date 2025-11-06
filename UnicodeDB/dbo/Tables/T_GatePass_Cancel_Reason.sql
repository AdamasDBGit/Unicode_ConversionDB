CREATE TABLE [dbo].[T_GatePass_Cancel_Reason] (
    [I_GatePass_Cancel_Reason_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]                  INT            NULL,
    [S_Reason]                    NVARCHAR (200) NULL,
    [I_Status]                    INT            NULL
);

