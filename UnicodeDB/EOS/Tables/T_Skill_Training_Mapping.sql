CREATE TABLE [EOS].[T_Skill_Training_Mapping] (
    [I_Skill_Training_Mapping_ID] INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Center_ID]                 INT NULL,
    [I_Skill_ID]                  INT NULL,
    [I_Training_ID]               INT NULL,
    [I_Training_Stage]            INT NULL,
    [I_Status]                    INT NULL,
    CONSTRAINT [PK__T_Employee_Train__62520F64] PRIMARY KEY CLUSTERED ([I_Skill_Training_Mapping_ID] ASC)
);

