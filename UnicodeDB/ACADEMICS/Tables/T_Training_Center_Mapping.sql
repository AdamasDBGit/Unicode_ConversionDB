CREATE TABLE [ACADEMICS].[T_Training_Center_Mapping] (
    [I_Training_Center_ID] INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Center_Id]          INT NULL,
    [I_Training_ID]        INT NOT NULL,
    [I_Status]             INT NULL,
    CONSTRAINT [PK__T_Training_Cente__4C02103B] PRIMARY KEY CLUSTERED ([I_Training_Center_ID] ASC)
);

