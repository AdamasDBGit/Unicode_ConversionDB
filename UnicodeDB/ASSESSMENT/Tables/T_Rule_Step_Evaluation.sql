CREATE TABLE [ASSESSMENT].[T_Rule_Step_Evaluation] (
    [I_Link_ID]       INT          IDENTITY (1, 1) NOT NULL,
    [S_Link_Name]     VARCHAR (50) NULL,
    [I_Rule_ID]       INT          NOT NULL,
    [I_Operand_ID1]   INT          NULL,
    [S_Operand_Name1] VARCHAR (50) NULL,
    [I_Operand_ID2]   INT          NULL,
    [S_Operand_Name2] VARCHAR (50) NULL,
    [S_Operator_Name] VARCHAR (10) NULL,
    [B_Is_LastNode]   BIT          NULL,
    [I_Status]        INT          NULL,
    [S_Crtd_By]       VARCHAR (20) NULL,
    [Dt_Crtd_On]      DATETIME     NULL,
    [S_Updt_By]       VARCHAR (20) NULL,
    [Dt_Updt_On]      DATETIME     NULL,
    CONSTRAINT [PK_T_Rule_Step_Evaluation] PRIMARY KEY CLUSTERED ([I_Link_ID] ASC)
);

