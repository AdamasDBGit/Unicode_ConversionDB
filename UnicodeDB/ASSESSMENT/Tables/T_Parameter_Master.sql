CREATE TABLE [ASSESSMENT].[T_Parameter_Master] (
    [I_ParameterID]   INT           IDENTITY (1, 1) NOT NULL,
    [S_ParameterName] VARCHAR (100) NULL,
    CONSTRAINT [PK_T_Parameter_Master] PRIMARY KEY CLUSTERED ([I_ParameterID] ASC)
);

